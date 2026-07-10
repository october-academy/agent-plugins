#!/bin/bash
# Plugin Validation Script
# Validates plugin structure, JSON syntax, and cross-references

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
PLUGINS_DIR="$ROOT_DIR/plugins"
MARKETPLACE_FILE="$ROOT_DIR/.claude-plugin/marketplace.json"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

echo "=========================================="
echo "  Plugin Validation Script"
echo "=========================================="
echo ""

# Function to print error
error() {
    echo -e "${RED}ERROR:${NC} $1"
    ERRORS=$((ERRORS+1))
}

# Function to print warning
warning() {
    echo -e "${YELLOW}WARNING:${NC} $1"
    WARNINGS=$((WARNINGS+1))
}

# Function to print success
success() {
    echo -e "${GREEN}OK:${NC} $1"
}

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq."
    exit 1
fi

# 1. Validate marketplace.json
echo "=== Validating marketplace.json ==="
if [ -f "$MARKETPLACE_FILE" ]; then
    if jq empty "$MARKETPLACE_FILE" 2>/dev/null; then
        success "marketplace.json is valid JSON"

        # Check top-level required fields
        for field in name version owner; do
            value=$(jq -r ".${field} // empty" "$MARKETPLACE_FILE" 2>/dev/null)
            if [ -z "$value" ]; then
                error "marketplace.json missing top-level '$field' field"
            else
                success "marketplace.json has top-level '$field' field"
            fi
        done
    else
        error "marketplace.json has invalid JSON syntax"
    fi
else
    error "marketplace.json not found"
fi
echo ""

# 2. Validate each plugin
echo "=== Validating plugins ==="
for plugin_dir in "$PLUGINS_DIR"/*/; do
    plugin_name=$(basename "$plugin_dir")
    echo ""
    echo "--- Checking: $plugin_name ---"

    # Check plugin.json exists
    plugin_json="$plugin_dir/.claude-plugin/plugin.json"
    if [ -f "$plugin_json" ]; then
        if jq empty "$plugin_json" 2>/dev/null; then
            success "plugin.json is valid JSON"

            # Check required fields
            name=$(jq -r '.name // empty' "$plugin_json")
            version=$(jq -r '.version // empty' "$plugin_json")
            description=$(jq -r '.description // empty' "$plugin_json")

            [ -z "$name" ] && error "plugin.json missing 'name' field"
            [ -z "$version" ] && warning "plugin.json missing 'version' field"
            [ -z "$description" ] && warning "plugin.json missing 'description' field"

            # Codex keys its plugin cache by version and requires strict semver
            if [ -n "$version" ]; then
                if echo "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+([-+][0-9A-Za-z.-]+)?$'; then
                    success "plugin.json version is strict semver"
                else
                    error "plugin.json version '$version' is not strict semver (required for Codex plugin cache)"
                fi
            fi

            # Check plugin.json name matches directory name
            if [ -n "$name" ]; then
                if [ "$name" = "$plugin_name" ]; then
                    success "plugin.json name matches directory name"
                else
                    error "plugin.json name '$name' does not match directory name '$plugin_name'"
                fi
            fi
        else
            error "plugin.json has invalid JSON syntax"
        fi
    else
        error "plugin.json not found"
    fi

    # Check README.md exists
    if [ -f "$plugin_dir/README.md" ]; then
        success "README.md exists"

        # Check for Installation section (English or Korean heading)
        if grep -qE "^## (Installation|설치)" "$plugin_dir/README.md"; then
            success "README.md has Installation section"
        else
            warning "README.md missing Installation section"
        fi
    else
        error "README.md not found"
    fi

    # Check commands have valid frontmatter
    if [ -d "$plugin_dir/commands" ]; then
        for cmd_file in "$plugin_dir/commands"/*.md; do
            [ -f "$cmd_file" ] || continue
            cmd_name=$(basename "$cmd_file" .md)

            # Check for YAML frontmatter
            if head -1 "$cmd_file" | grep -q "^---$"; then
                success "commands/$cmd_name.md has frontmatter"
            else
                warning "commands/$cmd_name.md missing YAML frontmatter"
            fi
        done
    fi

    # Check skills have valid frontmatter
    if [ -d "$plugin_dir/skills" ]; then
        for skill_dir in "$plugin_dir/skills"/*/; do
            [ -d "$skill_dir" ] || continue
            skill_name=$(basename "$skill_dir")
            # Skip local eval/test workspaces (gitignored: **/skills/*-workspace/)
            case "$skill_name" in
                *-workspace) continue ;;
            esac
            skill_file="$skill_dir/SKILL.md"

            if [ -f "$skill_file" ]; then
                if head -1 "$skill_file" | grep -q "^---$"; then
                    success "skills/$skill_name/SKILL.md has frontmatter"
                else
                    warning "skills/$skill_name/SKILL.md missing YAML frontmatter"
                fi
            else
                error "skills/$skill_name/SKILL.md not found"
            fi
        done
    fi

    # Check agents have valid frontmatter
    if [ -d "$plugin_dir/agents" ]; then
        for agent_file in "$plugin_dir/agents"/*.md; do
            [ -f "$agent_file" ] || continue
            agent_name=$(basename "$agent_file" .md)

            if head -1 "$agent_file" | grep -q "^---$"; then
                success "agents/$agent_name.md has frontmatter"
            else
                warning "agents/$agent_name.md missing YAML frontmatter"
            fi
        done
    fi

    # Check hooks.json if exists
    hooks_json="$plugin_dir/hooks/hooks.json"
    if [ -f "$hooks_json" ]; then
        if jq empty "$hooks_json" 2>/dev/null; then
            success "hooks/hooks.json is valid JSON"

            # Hook events must stay within the set both Claude Code and Codex support
            CODEX_HOOK_EVENTS=" PreToolUse PermissionRequest PostToolUse PreCompact PostCompact SessionStart UserPromptSubmit SubagentStart SubagentStop Stop "
            while IFS= read -r event_name; do
                [ -n "$event_name" ] || continue
                case "$CODEX_HOOK_EVENTS" in
                    *" $event_name "*)
                        success "hooks.json event '$event_name' is supported by Claude Code and Codex"
                        ;;
                    *)
                        warning "hooks.json event '$event_name' is not in the Codex-supported hook event set"
                        ;;
                esac
            done < <(jq -r '(.hooks // {}) | keys[]' "$hooks_json" 2>/dev/null)

            # Check referenced hook scripts exist (resolve ${CLAUDE_PLUGIN_ROOT})
            plugin_root="${plugin_dir%/}"
            while IFS= read -r hook_command; do
                [ -n "$hook_command" ] || continue
                resolved="${hook_command//\$\{CLAUDE_PLUGIN_ROOT\}/$plugin_root}"
                script_path="${resolved%% *}"
                if [ -f "$script_path" ]; then
                    success "hooks.json references existing script: ${script_path#"$plugin_root"/}"
                else
                    error "hooks.json references missing script: $script_path"
                fi
            done < <(jq -r '.. | .command? // empty' "$hooks_json")
        else
            error "hooks/hooks.json has invalid JSON syntax"
        fi
    fi

    # Check .mcp.json if exists
    mcp_json="$plugin_dir/.mcp.json"
    if [ -f "$mcp_json" ]; then
        if jq empty "$mcp_json" 2>/dev/null; then
            success ".mcp.json is valid JSON"
        else
            error ".mcp.json has invalid JSON syntax"
        fi
    fi
done

# 3. Cross-reference validation
echo ""
echo "=== Cross-reference validation ==="

# Check marketplace entries match plugin directories
if [ -f "$MARKETPLACE_FILE" ]; then
    marketplace_plugins=$(jq -r '.plugins[].name' "$MARKETPLACE_FILE" 2>/dev/null)

    for mp_plugin in $marketplace_plugins; do
        if [ -d "$PLUGINS_DIR/$mp_plugin" ]; then
            success "marketplace plugin '$mp_plugin' has matching directory"
        else
            error "marketplace plugin '$mp_plugin' has no matching directory"
        fi
    done

    # Check all plugin directories are in marketplace
    for plugin_dir in "$PLUGINS_DIR"/*/; do
        plugin_name=$(basename "$plugin_dir")
        if echo "$marketplace_plugins" | grep -q "^$plugin_name$"; then
            success "plugin '$plugin_name' is registered in marketplace"
        else
            warning "plugin '$plugin_name' is not registered in marketplace"
        fi
    done
fi

# 4. Version consistency check
echo ""
echo "=== Version consistency ==="

if [ -f "$MARKETPLACE_FILE" ]; then
    for plugin_dir in "$PLUGINS_DIR"/*/; do
        plugin_name=$(basename "$plugin_dir")
        plugin_json="$plugin_dir/.claude-plugin/plugin.json"

        if [ -f "$plugin_json" ]; then
            pj_version=$(jq -r '.version // "not set"' "$plugin_json")
            mp_version=$(jq -r ".plugins[] | select(.name==\"$plugin_name\") | .version // \"not set\"" "$MARKETPLACE_FILE")

            if [ "$pj_version" = "$mp_version" ]; then
                success "$plugin_name version match: $pj_version"
            else
                error "$plugin_name version mismatch: plugin.json=$pj_version, marketplace.json=$mp_version"
            fi
        fi
    done
fi

# 5. Description consistency check
echo ""
echo "=== Description consistency ==="

if [ -f "$MARKETPLACE_FILE" ]; then
    for plugin_dir in "$PLUGINS_DIR"/*/; do
        plugin_name=$(basename "$plugin_dir")
        plugin_json="$plugin_dir/.claude-plugin/plugin.json"

        if [ -f "$plugin_json" ]; then
            pj_description=$(jq -r '.description // "not set"' "$plugin_json")
            mp_description=$(jq -r ".plugins[] | select(.name==\"$plugin_name\") | .description // \"not set\"" "$MARKETPLACE_FILE")

            if [ "$pj_description" = "$mp_description" ]; then
                success "$plugin_name description match"
            else
                error "$plugin_name description mismatch: plugin.json=\"$pj_description\", marketplace.json=\"$mp_description\""
            fi
        fi
    done
fi

# Summary
echo ""
echo "=========================================="
echo "  Validation Summary"
echo "=========================================="
echo -e "Errors:   ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
echo ""

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}Validation FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}Validation PASSED${NC}"
    exit 0
fi
