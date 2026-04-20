"""trend-scout pipeline entrypoint."""
import datetime as dt
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))

from lib import dedupe_items, write_json, load_config
from fetchers import ALL_FETCHERS


def main():
    period = sys.argv[1] if len(sys.argv) > 1 else "day"
    limit = int(sys.argv[2]) if len(sys.argv) > 2 else 10
    outdir = sys.argv[3] if len(sys.argv) > 3 else "/tmp/trend-scout"

    os.makedirs(outdir, exist_ok=True)
    config = load_config()

    errors = []
    fallback_events = []
    all_items = []

    for fetcher_fn in ALL_FETCHERS:
        items = fetcher_fn(config, period, limit, outdir, errors, fallback_events)
        all_items.extend(items)

    deduped = dedupe_items(all_items)

    raw_counts = {}
    for item in all_items:
        raw_counts[item["source"]] = raw_counts.get(item["source"], 0) + 1
    deduped_counts = {}
    for item in deduped:
        deduped_counts[item["source"]] = deduped_counts.get(item["source"], 0) + 1

    now = dt.datetime.now(dt.timezone.utc)
    metadata = {
        "generated_at": now.isoformat(),
        "period": period,
        "limit_per_source": limit,
        "cutoff": (now - dt.timedelta(days=7 if period == "week" else 1)).isoformat(),
        "output_dir": outdir,
        "sources": sorted(raw_counts),
        "raw_counts": raw_counts,
        "deduped_counts": deduped_counts,
        "counts": {
            "raw_items": len(all_items),
            "deduped_items": len(deduped),
            "raw_by_source": raw_counts,
            "deduped_by_source": deduped_counts,
        },
        "errors": errors,
        "fallback_events": fallback_events,
    }
    payload = {
        "metadata": metadata,
        "topics": deduped,
        "meta": metadata,
        "items": deduped,
    }
    write_json(outdir, "all.json", payload)
    print(json.dumps(payload, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
