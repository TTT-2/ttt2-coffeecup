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

		local amount = math.min(GetConVar("ttt_coffeecup_amount"):GetInt(), #suitableEnts)

		for i = 1, amount do
			local ent = suitableEnts[i]
			local pos = ent:GetPos()

			ent:Remove()

			local coffeeCupEnt = ents.Create("ent_ttt_coffeecup")

			coffeeCupEnt:SetModel(table.Random(coffeeCup.models))
			coffeeCupEnt:SetPos(pos)
			coffeeCupEnt:Spawn()

			coffeeCup.cups[#coffeeCup.cups + 1] = coffeeCupEnt
		end

		LANG.MsgAll("coffeecup_hunt_started", {amount = amount, points = GetConVar("ttt_coffeecup_reward_size"):GetInt()}, MSG_MSTACK_PLAIN)
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
		-- ToDo this should be improved in the future once the scoring system
		-- gets improved with the round end screen rework
		ply:AddFrags(GetConVar("ttt_coffeecup_reward_size"):GetInt())

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
		MSTACK:AddColoredImagedMessage(
			LANG.GetParamTranslation("coffeecup_granted_reward", {reward = net.ReadUInt(8)}),
			nil,
			materialCoffeCup
		)
	end)
end
