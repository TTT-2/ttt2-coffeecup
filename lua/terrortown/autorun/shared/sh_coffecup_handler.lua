coffeeCup = coffeeCup or {}

coffeeCup.replacementTypes = {
	"prop_physics",
	"prop_physics_multiplayer",
	"prop_dynamic"
}

coffeeCup.models = {
	"models/props/cs_office/coffee_mug.mdl",
	"models/props/cs_office/coffee_mug2.mdl",
	"models/props/cs_office/coffee_mug3.mdl"
}

coffeeCup.cups = {

}

if SERVER then
	util.AddNetworkString("ttt2_coffecup_mstack_found")

	resource.AddFile("materials/vgui/ttt/coffeecup.png")

	function coffeeCup.SetupCups()
		-- get all suitable entities
		local suitableEnts = {}

		for i = 1, #coffeeCup.replacementTypes do
			local type = coffeeCup.replacementTypes[i]

			table.Add(suitableEnts, ents.FindByClass(type))
		end

		table.Shuffle(suitableEnts)

		local cup_amount = math.min(GetConVar("ttt_coffeecup_amount"):GetInt(), #suitableEnts)

		for i = 1, cup_amount do
			local ent = suitableEnts[i]
			local pos = ent:GetPos()

			ent:Remove()

			local coffeeCupEnt = ents.Create("ent_ttt_coffeecup")

			coffeeCupEnt:SetModel(table.Random(coffeeCup.models))
			coffeeCupEnt:SetPos(pos)
			coffeeCupEnt:Spawn()

			coffeeCup.cups[#coffeeCup.cups + 1] = coffeeCupEnt
		end

		local mode = GetConVar("ttt_coffeecup_reward_mode"):GetInt()
		local modeString = ""

		if mode == CC_MODE_SCORE then
			modeString = "coffeecup_hunt_started_score"
		elseif mode == CC_MODE_CREDITS then
			modeString = "coffeecup_hunt_started_credits"
		elseif mode == CC_MODE_PS_POINTS then
			modeString = "coffeecup_hunt_started_ps_points"
		elseif mode == CC_MODE_PC_POINTS_PREMIUM then
			modeString = "coffeecup_hunt_started_ps_points_premium"
		end

		LANG.MsgAll(modeString, {cup_amount = cup_amount, amount = GetConVar("ttt_coffeecup_reward_size"):GetInt()}, MSG_MSTACK_PLAIN)
	end

	function coffeeCup.RemoveCups()
		for i = 1, #coffeeCup.cups do
			local cup = coffeeCup.cups[i]

			if not IsValid(cup) then continue end

			cup:Remove()
		end

		LANG.MsgAll("coffeecup_hunt_over", nil, MSG_MSTACK_PLAIN)
	end

	function coffeeCup.PickupCup(ent, ply)
		events.Trigger(EVENT_COFFEECUP, ply)

		ent:Remove()

		net.Start("ttt2_coffecup_mstack_found")
		net.WriteUInt(GetConVar("ttt_coffeecup_reward_size"):GetInt(), 8)
		net.Send(ply)
	end

	hook.Add("TTTBeginRound", "ttt2_coffecup_choose_ents", function()
		coffeeCup.SetupCups()
	end)

	hook.Add("TTTEndRound", "ttt2_coffecup_remove_ents", function()
		coffeeCup.RemoveCups()
	end)
end

if CLIENT then
	local materialCoffeCup = Material("vgui/ttt/coffeecup.png")

	net.Receive("ttt2_coffecup_mstack_found", function()
		local mode = GetConVar("ttt_coffeecup_reward_mode"):GetInt()
		local modeString = ""

		if mode == CC_MODE_SCORE then
			modeString = "coffeecup_granted_reward_score"
		elseif mode == CC_MODE_CREDITS then
			modeString = "coffeecup_granted_reward_credits"
		elseif mode == CC_MODE_PS_POINTS then
			modeString = "coffeecup_granted_reward_ps_points"
		elseif mode == CC_MODE_PC_POINTS_PREMIUM then
			modeString = "coffeecup_granted_reward_ps_points_premium"
		end

		MSTACK:AddColoredImagedMessage(
			LANG.GetParamTranslation(modeString, {amount = net.ReadUInt(8)}),
			nil,
			materialCoffeCup
		)
	end)
end
