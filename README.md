# 영상 포트폴리오 템플릿

정적 HTML/CSS/JS 기반의 영상 포트폴리오 템플릿입니다. 사이트 콘텐츠는 `data/site.json` 한 파일로 관리하고, `admin/` 페이지에서 값을 편집한 뒤 JSON을 복사해 반영하는 흐름을 사용합니다.

## 브랜치 역할

- `main`: 다른 사람이 clone해서 템플릿으로 사용할 기본 소스 브랜치
- `gh-pages`: 현재 완성본을 보존하고 GitHub Pages에서 배포할 브랜치

## GitHub Pages 설정

GitHub 저장소의 Pages 설정에서 배포 소스를 `gh-pages` 브랜치의 `/ (root)`로 지정하세요. 관리자 페이지의 "GitHub site.json 열기" 버튼도 이 기준으로 `gh-pages`의 `data/site.json`을 가리키도록 맞춰져 있습니다.

## 편집 흐름

1. `admin/index.html`을 열어 브랜드, 히어로, 작업물, 가격, 문의 정보를 수정합니다.
2. JSON 탭에서 결과를 복사하거나 `site.json`을 다운로드합니다.
3. 생성한 내용을 `data/site.json`에 반영합니다.
4. 정적 페이지인 `index.html`, `pricing.html`, `contact.html`에서 결과를 확인합니다.

## main -> gh-pages 동기화

`main`과 `gh-pages`의 차이를 `data/site.json` 하나로 유지하고 싶다면 아래 스크립트를 사용하세요.

```bash
bash scripts/sync-gh-pages.sh
```

이 스크립트는 다음 순서로 동작합니다.

1. 작업 트리가 깨끗한지 확인합니다.
2. `gh-pages` 브랜치의 `data/site.json`을 임시로 보관합니다.
3. `main`을 `gh-pages`에 병합합니다.
4. 마지막에 `data/site.json`만 다시 `gh-pages` 버전으로 복원한 뒤 병합 커밋을 만듭니다.

즉, HTML/CSS/JS 수정은 `main`에서 가져오고, 배포용 JSON만 `gh-pages`에 남길 수 있습니다.

## 템플릿 기본값

- 기본 브랜드: `studio / your-name`
- 기본 문의: `Email / your@email.com`
- 프로젝트/통계/작업물 섹션은 빈 템플릿 상태에서 과하게 보이지 않도록 기본 비활성화되어 있습니다.
