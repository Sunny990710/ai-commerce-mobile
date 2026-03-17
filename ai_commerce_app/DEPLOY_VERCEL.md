# Vercel로 Flutter Web 배포하기

두 가지 방법 중 편한 것을 선택하세요.

---

## 방법 1: Vercel CLI로 빠르게 배포 (권장)

가장 간단한 방법입니다. 로컬에서 빌드 후 바로 배포합니다.

### 1단계: Vercel CLI 설치

```bash
npm i -g vercel
```

### 2단계: Flutter Web 빌드

```bash
cd ai_commerce_app
flutter build web
```

### 3단계: 배포

```bash
vercel build/web
```

처음 실행 시:
- Vercel 로그인 안내가 나오면 진행
- 프로젝트 설정 질문에는 Enter로 기본값 사용 가능

### 4단계: 프로덕션 배포 (선택)

```bash
vercel build/web --prod
```

배포가 끝나면 `https://프로젝트이름.vercel.app` 주소가 생성됩니다.

---

## 방법 2: GitHub 연동 자동 배포

코드를 푸시할 때마다 자동으로 배포됩니다.

### 1단계: GitHub에 코드 올리기

```bash
cd ai-commerce-mobile
git add .
git commit -m "Vercel 배포 준비"
git push origin main
```

### 2단계: Vercel 가입 및 프로젝트 연결

1. [vercel.com](https://vercel.com) 접속 → **Sign Up**
2. **GitHub로 계속** 클릭
3. **Add New Project** → **Import Git Repository**
4. `ai-commerce-mobile` 저장소 선택
5. **Import** 클릭

### 3단계: 프로젝트 설정

| 설정 | 값 |
|------|-----|
| **Root Directory** | `ai_commerce_app` |
| **Framework Preset** | Other |
| **Build Command** | (기본값 사용 - vercel.json에 있음) |
| **Output Directory** | (기본값 사용 - build/web) |

**Root Directory**가 중요합니다. `ai_commerce_app`로 설정해야 Flutter 프로젝트를 인식합니다.

### 4단계: 배포

**Deploy** 버튼을 누르면 됩니다.

> ⚠️ **참고**: Flutter SDK를 설치하는 과정 때문에 첫 배포에 **5~10분** 정도 걸릴 수 있습니다.

---

## 배포 후 확인

- Vercel 대시보드에서 **Visit** 또는 생성된 URL로 접속
- Flutter Web은 SPA라서 새로고침 시에도 라우팅이 정상 동작합니다 (vercel.json의 rewrites 설정)

---

## 문제 해결

### "Flutter not found" 에러
- **방법 1**을 사용하세요 (로컬 빌드 후 배포)
- 방법 2에서 install 단계 실패 시, Vercel 대시보드의 **Settings → General → Build Command**에서 빌드 명령을 확인하세요.

### 404 에러 (새로고침 시)
- `vercel.json`의 `rewrites` 설정이 적용되어 있는지 확인하세요.
