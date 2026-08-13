# Rojo + GitHub 연동 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Windows의 Roblox Studio와 로컬 Rojo CLI로 동기화할 수 있는 최소 프로젝트를 만든다.

**Architecture:** `default.project.json`이 서버, 클라이언트, 공용 Luau 소스를 Roblox DataModel에 매핑한다. GitHub는 원격 작업공간과 Windows 사이의 파일 전달에만 사용하고, 실시간 Rojo 연결은 Windows 내부에서 수행한다.

**Tech Stack:** Rojo 7.x, Luau, Roblox Studio, Git

---

### Task 1: 프로젝트 구조와 Rojo 매핑

**Files:**
- Create: `default.project.json`
- Create: `.gitignore`

- [ ] **Step 1: 생성 전 검사를 실행한다**

Run: `test ! -e default.project.json && test ! -e .gitignore`
Expected: exit code 0.

- [ ] **Step 2: 최소 DataModel 매핑을 작성한다**

`default.project.json`은 `ReplicatedStorage.Shared`, `ServerScriptService.Server`, `StarterPlayer.StarterPlayerScripts.Client`를 각각 `src/shared`, `src/server`, `src/client`에 매핑하고 Workspace 기본 속성을 정의한다. `.gitignore`는 `*.rbxl`, `*.rbxlx`, `sourcemap.json`, Windows 및 편집기 임시 파일을 제외한다.

- [ ] **Step 3: JSON 구문과 매핑 경로를 검사한다**

Run: `python3 -m json.tool default.project.json >/dev/null && test -d src/shared && test -d src/server && test -d src/client`
Expected: exit code 0.

### Task 2: 동기화 확인용 Luau 진입점

**Files:**
- Create: `src/shared/Hello.luau`
- Create: `src/server/init.server.luau`
- Create: `src/client/init.client.luau`

- [ ] **Step 1: 생성 전 검사를 실행한다**

Run: `test ! -e src/shared/Hello.luau && test ! -e src/server/init.server.luau && test ! -e src/client/init.client.luau`
Expected: exit code 0.

- [ ] **Step 2: 공용 모듈과 서버·클라이언트 진입점을 작성한다**

`Hello.luau`는 실행 환경 이름을 받아 연결 확인 문자열을 반환한다. 서버와 클라이언트 진입점은 이 모듈을 require하여 Roblox Studio Output에 각각 한 줄을 출력한다.

- [ ] **Step 3: 파일명 규칙과 참조를 정적으로 검사한다**

Run: `rg -n 'require.*Hello|print' src/server/init.server.luau src/client/init.client.luau && rg -n 'function Hello.message' src/shared/Hello.luau`
Expected: 모든 파일과 심볼이 출력된다.

### Task 3: Windows 연결 문서

**Files:**
- Create: `README.md`

- [ ] **Step 1: README 부재를 확인한다**

Run: `test ! -e README.md`
Expected: exit code 0.

- [ ] **Step 2: Windows 설치와 연결 절차를 작성한다**

문서에는 Rojo CLI 설치, Studio 플러그인 설치, GitHub clone, 저장소 루트에서 `rojo serve`, 플러그인의 Connect, Output 확인, pull/edit/push 흐름과 문제 해결 순서를 포함한다.

- [ ] **Step 3: 필수 명령과 안내가 있는지 검사한다**

Run: `rg -n 'rojo serve|git clone|Connect|Output' README.md`
Expected: 네 연결 단계가 모두 검색된다.

### Task 4: 전체 검증

**Files:**
- Verify: `default.project.json`
- Verify: `src/shared/Hello.luau`
- Verify: `src/server/init.server.luau`
- Verify: `src/client/init.client.luau`
- Verify: `README.md`

- [ ] **Step 1: JSON과 전체 파일 구성을 검사한다**

Run: `python3 -m json.tool default.project.json >/dev/null && test -s src/shared/Hello.luau && test -s src/server/init.server.luau && test -s src/client/init.client.luau && test -s README.md`
Expected: exit code 0.

- [ ] **Step 2: Rojo가 설치되어 있으면 프로젝트 자체를 검사한다**

Run: `if command -v rojo >/dev/null; then rojo sourcemap default.project.json --output sourcemap.json && test -s sourcemap.json; else echo 'Rojo CLI not installed; JSON/static checks completed'; fi`
Expected: sourcemap 생성 성공 또는 명시적인 설치되지 않음 메시지.

- [ ] **Step 3: 변경 내용을 검토한다**

Run: `find . -maxdepth 4 -type f -not -path './.git/*' -print | sort`
Expected: 설계 및 계획 문서, Rojo 설정, 세 Luau 파일, README가 출력된다.

Git 초기화, GitHub 저장소 생성, commit 및 push는 사용자 승인 후 별도 단계로 수행한다.
