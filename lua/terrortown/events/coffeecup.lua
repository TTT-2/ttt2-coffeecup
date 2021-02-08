if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_coffeecup"
end

if SERVER then
	function EVENT:Trigger(finder)
		self:AddAffectedPlayers({finder:SteamID64()})

		return self:Add({
			finder = {
				nick = finder:Nick(),
				sid64 = finder:SteamID64(),
				role = finder:GetSubRole(),
				team = finder:GetTeam()
			}
		})
	end

	function EVENT:CalculateScore()
		local event = self.event

		self:SetPlayerScore(event.finder.sid64, {
			score = GetConVar("ttt_coffeecup_reward_size"):GetInt()
		})
	end
end

function EVENT:Serialize()

end
