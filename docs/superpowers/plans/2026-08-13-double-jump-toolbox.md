# Double Jump and Toolbox Implementation Plan

**Goal:** 점프맵에 이중 점프와 E키 속도 코일 상자를 추가한다.

**Architecture:** 클라이언트가 이중 점프 입력을 처리하고 서버가 도구 상자와 Tool 상태를 권위 있게 관리한다. 수치는 공용 설정에서 공유한다.

**Tech Stack:** Luau, Roblox Humanoid, ProximityPrompt, Tool

## Task 1: 공용 설정

- [ ] `ObbyConfig.luau`에 이중 점프 힘과 속도 코일 수치를 추가한다.
- [ ] 설정 키가 존재하는지 검사한다.

## Task 2: 이중 점프

- [ ] 기존 클라이언트 코드에 기능 부재 검사를 실행한다.
- [ ] Humanoid 상태와 Space 입력을 이용한 공중 추가 점프를 구현한다.
- [ ] 지상 착지 시 추가 점프 횟수가 초기화되는지 검사한다.

## Task 3: 도구 상자와 속도 코일

- [ ] 서버 코드에 기능 부재 검사를 실행한다.
- [ ] 시작점 상자와 ProximityPrompt를 생성한다.
- [ ] 플레이어별 획득 상태와 Tool 장착 효과를 구현한다.
- [ ] 사망 후 재지급과 중복 방지를 검사한다.

## Task 4: 전체 검증

- [ ] JSON과 Luau 핵심 연결을 정적으로 검사한다.
- [ ] Git diff 오류와 변경 범위를 확인한다.
