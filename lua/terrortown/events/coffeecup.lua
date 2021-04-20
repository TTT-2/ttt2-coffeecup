if CLIENT then
	EVENT.icon = Material("vgui/ttt/vskin/events/coffeecup")
	EVENT.title = "title_event_coffeecup"

	function EVENT:GetText()
		return {
			{
				string = "desc_event_coffeecup",
				params = {
					player = self.event.finder.nick,
				}
			}
		}
	end
end

if SERVER then
	function EVENT:Trigger(finder)
		local mode = GetConVar("ttt_coffeecup_reward_mode"):GetInt()
		local size = GetConVar("ttt_coffeecup_reward_size"):GetInt()

		self:AddAffectedPlayers(
			{finder:SteamID64()},
			{finder:Nick()}
		)

		if mode == CC_MODE_CREDITS then
			finder:AddCredits(size)
		elseif mode == CC_MODE_PS_POINTS then
			if not isfunction(finder.PS2_AddStandardPoints) then
				MsgN("[COFFEECUP][WARNING] This mode requires pointshop 2.")

				return
			end

			finder:PS2_AddStandardPoints(size)
		elseif mode == CC_MODE_PC_POINTS_PREMIUM then
			if not isfunction(finder.PS2_AddPremiumPoints) then
				MsgN("[COFFEECUP][WARNING] This mode requires pointshop 2.")

				return
			end

			finder:PS2_AddPremiumPoints(size)
		end

		return self:Add({
			finder = {
				nick = finder:Nick(),
				sid64 = finder:SteamID64(),
				role = finder:GetSubRole(),
				team = finder:GetTeam(),
			},
			mode = mode,
			size = size
		})
	end

	function EVENT:CalculateScore()
		local event = self.event

		-- only give points if reward mode is set to score points
		if event.mode ~= CC_MODE_SCORE then return end

		self:SetPlayerScore(event.finder.sid64, {
			score = event.size
		})
	end
end

function EVENT:Serialize()

end
