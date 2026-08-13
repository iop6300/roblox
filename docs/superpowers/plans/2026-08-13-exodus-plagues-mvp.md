# Exodus Plagues Adventure MVP Implementation Plan

**Goal:** 첫 세 재앙을 연속 임무로 체험하는 스토리형 Roblox 어드벤처를 만든다.

**Architecture:** 서버 권위형 진행 관리와 절차적 맵 생성, RemoteEvent 기반 HUD 갱신으로 구성한다. 클라이언트는 UI와 현재 환경에 필요한 대체 입력·카메라만 담당한다.

**Tech Stack:** Luau, Roblox ProximityPrompt, RemoteEvent, Humanoid

## Task 1: 공용 게임 설정

- [ ] 장 제목, 목표 수량, 제한 시간과 색상을 ExodusConfig에 정의한다.
- [ ] 필수 세 장의 설정 존재 여부를 검사한다.

## Task 2: 맵과 서버 진행

- [ ] 기존 점프맵 서버 코드 부재 검사를 실행한다.
- [ ] 마을, 강, 궁전 입구, 모세 NPC와 임무 오브젝트를 생성한다.
- [ ] 플레이어별 프롤로그와 세 장의 진행 상태를 구현한다.
- [ ] 사망 재시작, 중복 타이머, 수집 중복 방지를 검사한다.

## Task 3: 스토리 HUD와 조작

- [ ] 기존 점프맵 UI 부재 검사를 실행한다.
- [ ] 장 제목, 목표, 타이머, 대사 UI를 구현한다.
- [ ] PlayerModule 부재 시 WASD와 3인칭 카메라가 유지되는지 검사한다.

## Task 4: 전체 검증

- [ ] JSON과 RemoteEvent 양쪽 연결을 검사한다.
- [ ] 세 장의 시작·성공·실패 경로를 정적으로 검사한다.
- [ ] Git diff 오류와 변경 범위를 확인한다.
