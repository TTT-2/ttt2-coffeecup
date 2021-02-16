CreateConVar("ttt_coffeecup_amount", "2", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
CreateConVar("ttt_coffeecup_reward_size", "3", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
CreateConVar("ttt_coffeecup_reward_mode", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})

hook.Add("TTTUlxInitCustomCVar", "TTTCoffeeCupInitRWCVar", function(name)
	ULib.replicatedWritableCvar("ttt_coffeecup_amount", "rep_ttt_coffeecup_amount", GetConVar("ttt_coffeecup_amount"):GetInt(), true, false, name)
	ULib.replicatedWritableCvar("ttt_coffeecup_reward_size", "rep_ttt_coffeecup_reward_size", GetConVar("ttt_coffeecup_reward_size"):GetInt(), true, false, name)
	ULib.replicatedWritableCvar("ttt_coffeecup_reward_mode", "rep_ttt_coffeecup_reward_mode", GetConVar("ttt_coffeecup_reward_mode"):GetInt(), true, false, name)
end)

-- global CVars
CC_MODE_SCORE = 1
CC_MODE_CREDITS = 2
CC_MODE_PS_POINTS = 3
CC_MODE_PC_POINTS_PREMIUM = 4

if CLIENT then
	hook.Add("TTTUlxModifyAddonSettings", "TTTCoffeeCupModifySettings", function(name)
		local tttrspnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

		-- Basic Settings
		local tttrsclp1 = vgui.Create("DCollapsibleCategory", tttrspnl)
		tttrsclp1:SetSize(390, 93)
		tttrsclp1:SetExpanded(1)
		tttrsclp1:SetLabel("Basic Settings")

		local tttrslst1 = vgui.Create("DPanelList", tttrsclp1)
		tttrslst1:SetPos(5, 25)
		tttrslst1:SetSize(390, 93)
		tttrslst1:SetSpacing(5)

		tttrslst1:AddItem(xlib.makeslider{
			label = "ttt_coffeecup_amount (Def. 2)",
			repconvar = "rep_ttt_coffeecup_amount",
			min = 0,
			max = 25,
			decimal = 0,
			parent = tttrslst1
		})

		tttrslst1:AddItem(xlib.makeslider{
			label = "ttt_coffeecup_reward_size (Def. 3)",
			repconvar = "rep_ttt_coffeecup_reward_size",
			min = 0,
			max = 25,
			decimal = 0,
			parent = tttrslst1
		})

		tttrslst1:AddItem(xlib.makelabel{
			label = "ttt_coffeecup_reward_mode:",
			parent = tttrslst1
		})

		tttrslst1:AddItem(xlib.makecombobox{
			enableinput = false,
			choices = {
				"Score Points",
				"Credits",
				"Pointshop Points",
				"Pointshop Premium Points"
			},
			isNumberConvar = true,
			repconvar = "rep_ttt_coffeecup_reward_mode",
			numOffset = 0,
			parent = tttrslst1
		})

		-- add to ULX
		xgui.hookEvent("onProcessModules", nil, tttrspnl.processModules)
		xgui.addSubModule("Coffee Cup", tttrspnl, nil, name)
	end)
end
