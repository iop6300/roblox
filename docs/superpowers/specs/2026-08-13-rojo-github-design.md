# Rojo + GitHub 연동 설계

## 목표

빈 작업공간에 최소 Rojo 프로젝트를 구성한다. 사용자는 Windows에서 GitHub 저장소를 clone하고 Rojo CLI를 실행한 뒤 Roblox Studio의 Rojo 플러그인으로 프로젝트를 동기화한다.

## 구조

- `default.project.json`: Roblox DataModel과 로컬 파일의 매핑을 정의한다.
- `src/server/init.server.luau`: `ServerScriptService`에서 실행되는 서버 진입점이다.
- `src/client/init.client.luau`: `StarterPlayerScripts`에서 실행되는 클라이언트 진입점이다.
- `src/shared/Hello.luau`: `ReplicatedStorage.Shared`에 동기화되는 공용 모듈 예제다.
- `.gitignore`: Rojo 빌드 산출물과 운영체제 임시 파일을 제외한다.
- `README.md`: Windows용 Rojo 설치, Git clone, Studio 플러그인 연결, 동기화 확인 절차를 설명한다.

## 동기화 흐름

1. 이 작업공간의 파일을 GitHub에 push한다.
2. Windows에서 저장소를 clone 또는 pull한다.
3. 저장소 루트에서 `rojo serve`를 실행한다.
4. Roblox Studio에서 Rojo 플러그인을 열어 로컬 Rojo 서버에 연결한다.
5. Luau 파일 변경이 Studio의 대응 인스턴스에 반영된다.

GitHub는 파일 전달과 버전 관리에 사용하며, Rojo의 실시간 연결은 Windows PC 안에서 이루어진다.

## 오류 처리

- Rojo 실행 파일을 찾지 못하면 설치와 PATH 확인 방법을 안내한다.
- 플러그인이 연결되지 않으면 CLI 실행 여부, 포트, Studio 플러그인 설치 여부를 차례로 확인한다.
- 프로젝트 매핑 오류를 줄이기 위해 최소한의 명시적 `$className` 및 `$path` 매핑을 사용한다.

## 검증

- `rojo sourcemap default.project.json`으로 프로젝트 매핑 구문을 검사한다.
- 가능하면 `rojo build default.project.json`으로 place 파일 생성을 확인한다.
- Windows에서 Studio 연결 후 Output 창의 서버·클라이언트 메시지를 확인한다.

## 범위 밖

Wally 패키지 관리, 자동 배포, GitHub Actions, 데이터 저장소, 게임 기능 구현은 이번 최초 연결 범위에 포함하지 않는다.
