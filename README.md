# Roblox Studio + Rojo Starter

이 저장소는 Windows PC에서 Rojo를 실행하고 Roblox Studio와 실시간으로 동기화하기 위한 최소 프로젝트입니다. GitHub는 원격 작업공간과 Windows 사이에서 파일을 전달하는 용도로 사용합니다.

## 1. Windows에 필요한 도구 설치

1. [Git for Windows](https://git-scm.com/download/win)를 설치합니다.
2. [Rojo 공식 설치 안내](https://rojo.space/docs/v7/getting-started/installation/)에 따라 Rojo CLI 7.x를 설치합니다.
   - 가장 간단한 방법은 [Rojo GitHub Releases](https://github.com/rojo-rbx/rojo/releases)에서 Windows 실행 파일을 내려받아 PATH에 추가하는 것입니다.
   - 설치 후 PowerShell에서 `rojo --version`을 실행해 확인합니다.
3. PowerShell에서 아래 명령으로 현재 CLI와 맞는 Studio 플러그인을 설치합니다.

```powershell
rojo plugin install
```

Rojo CLI와 Studio 플러그인은 같은 메이저 버전을 사용해야 합니다.

## 2. GitHub에서 프로젝트 받기

GitHub 저장소가 만들어진 뒤 PowerShell에서 다음 명령을 실행합니다. 주소의 `<YOUR_GITHUB_REPOSITORY_URL>`은 실제 저장소 URL로 바꿉니다.

```powershell
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd roblox
```

저장소 폴더 이름이 `roblox`가 아니라면 `cd` 뒤에 실제 폴더 이름을 입력하세요.

## 3. Roblox Studio 연결

프로젝트 루트(`default.project.json`이 있는 폴더)에서 실행합니다.

```powershell
rojo serve
```

터미널에 로컬 주소와 포트가 표시되면 다음 순서로 연결합니다.

1. Roblox Studio에서 새 Baseplate를 엽니다.
2. 상단 **Plugins** 탭에서 **Rojo**를 누릅니다.
3. Rojo 패널에서 **Connect**를 누릅니다.
4. 동기화 확인 창이 나타나면 변경 내용을 확인하고 적용합니다.
5. Studio의 **View > Output**을 연 뒤 Play를 누릅니다.

연결되면 Output에 다음 두 메시지가 표시됩니다.

```text
[Rojo] Server code is connected and running!
[Rojo] Client code is connected and running!
```

`rojo serve`가 실행 중인 동안 이 폴더의 `.luau` 파일을 수정하면 Studio에 반영됩니다. 작업이 끝나면 PowerShell에서 `Ctrl+C`로 Rojo를 종료합니다.

## 4. GitHub 동기화 흐름

Windows에서 최신 변경을 받으려면:

```powershell
git pull
```

Windows에서 수정한 파일을 GitHub에 올리려면 변경 내용을 검토한 뒤 commit과 push를 사용합니다. 여러 장치에서 동시에 같은 파일을 수정하지 않는 것이 충돌을 줄이는 가장 쉬운 방법입니다.

## 연결 문제 확인

- `rojo` 명령을 찾지 못함: Rojo 실행 파일이 PATH에 등록됐는지 확인하고 PowerShell을 다시 엽니다.
- Studio에 Rojo 버튼이 없음: `rojo plugin install`을 다시 실행한 뒤 Studio를 재시작합니다.
- Connect 실패: 프로젝트 루트에서 `rojo serve`가 계속 실행 중인지 확인합니다.
- 코드가 보이지 않음: `default.project.json`이 현재 PowerShell 폴더에 있는지 확인합니다.
- Output 메시지가 없음: Studio에서 Play를 시작했는지 확인하고 Output의 검색 필터를 지웁니다.
