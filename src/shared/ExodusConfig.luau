local Config = {
	SurvivalSeconds = 25,
	SupplySeconds = 45,
	WaterGoal = 3,
	SupplyGoal = 3,
	DefaultWalkSpeed = 16,
	Chapters = {
		[0] = { Title = "프롤로그", Objective = "모세와 대화하세요" },
		[1] = { Title = "첫 번째 재앙 · 피로 변한 강", Objective = "깨끗한 물 항아리 3개를 찾으세요" },
		[2] = { Title = "두 번째 재앙 · 개구리", Objective = "개구리 떼를 피해 살아남으세요" },
		[3] = { Title = "세 번째 재앙 · 이와 각다귀", Objective = "주민을 위한 구호 물자 3개를 모으세요" },
		[4] = { Title = "첫 여정 완료", Objective = "다음 이야기를 기다려 주세요" },
	},
	Colors = {
		Sand = Color3.fromRGB(218, 181, 116),
		Sandstone = Color3.fromRGB(194, 142, 82),
		River = Color3.fromRGB(122, 24, 35),
		Palm = Color3.fromRGB(52, 107, 63),
		Gold = Color3.fromRGB(242, 190, 62),
		Tent = Color3.fromRGB(112, 74, 53),
		Danger = Color3.fromRGB(97, 163, 79),
	},
}

return Config
