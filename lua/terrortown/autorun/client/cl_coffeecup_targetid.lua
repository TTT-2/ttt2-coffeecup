-- handle looking at sodas
hook.Add("TTTRenderEntityInfo", "ttt2_coffeecup_hightlight_entity", function(tData)
	local ent = tData:GetEntity()
	local client = LocalPlayer()

	if ent:GetClass() ~= "ent_ttt_coffeecup" then return end

	tData:EnableText()
	tData:EnableOutline()
	tData:SetOutlineColor(client:GetRoleColor())

	tData:SetTitle(LANG.TryTranslation("coffecup_name"))
	tData:SetSubtitle(LANG.GetParamTranslation("coffecup_pickup", {usekey = Key("+use", "USE")}))
	tData:SetKeyBinding("+use")

	local mode = GetConVar("ttt_coffeecup_reward_mode"):GetInt()
	local modeString = ""

	if mode == CC_MODE_SCORE then
		modeString = "coffecup_help_score"
	elseif mode == CC_MODE_CREDITS then
		modeString = "coffecup_help_credits"
	elseif mode == CC_MODE_PS_POINTS then
		modeString = "coffecup_help_ps_points"
	elseif mode == CC_MODE_PC_POINTS_PREMIUM then
		modeString = "coffecup_help_ps_points_premium"
	end

	tData:AddDescriptionLine(LANG.GetParamTranslation(modeString, {amount = GetConVar("ttt_coffeecup_reward_size"):GetInt()}))
end)
