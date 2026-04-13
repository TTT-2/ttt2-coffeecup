if SERVER then
	CreateConVar("ttt_coffeecup_amount", "2", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt_coffeecup_reward_size", "3", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt_coffeecup_reward_mode", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
end

-- global CVars
CC_MODE_SCORE = 1
CC_MODE_CREDITS = 2
CC_MODE_PS_POINTS = 3
CC_MODE_PC_POINTS_PREMIUM = 4
