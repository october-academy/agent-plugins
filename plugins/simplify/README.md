# Simplify

코드를 명확성, 일관성, 유지보수성을 위해 단순화하고 정제합니다. 기능은 그대로 유지합니다.

## 설치

```bash
claude plugin install simplify@october-plugins
```

## 사용법

```bash
/simplify                 # 최근 수정된 코드 단순화
/simplify src/utils.ts    # 특정 파일 단순화
```

## 특징

- **기능 보존**: 코드 동작은 변경하지 않고 구현 방식만 개선
- **프로젝트 표준 적용**: CLAUDE.md의 코딩 컨벤션 준수
- **최근 수정 코드 집중**: 세션에서 수정된 코드를 대상으로 함
- **Opus 모델 사용**: 고품질 분석을 위해 Opus 사용

## 원칙

1. **명확성 > 간결성**: 한 줄 코드보다 읽기 쉬운 코드 선호
2. **중첩 삼항 금지**: switch문이나 if/else 체인 사용
3. **복잡도 감소**: 불필요한 중첩과 추상화 제거
4. **균형 유지**: 과도한 단순화로 유지보수성 저하 방지

## 개선 대상

- 불필요한 복잡성과 깊은 중첩
- 중복 코드와 과도한 추상화
- 불명확한 변수/함수명
- 이해하기 어려운 "영리한" 코드
- 가독성을 희생한 한 줄 코드

## 예시

**Before:**
```javascript
const result = items.length > 0 ? items[0].active ? items[0].value : items[0].fallback ?? null : defaultValue;
```

**After:**
```javascript
function getItemValue(items, defaultValue) {
  if (items.length === 0) {
    return defaultValue;
  }

  const firstItem = items[0];
  if (firstItem.active) {
    return firstItem.value;
  }

  return firstItem.fallback ?? null;
}
```
