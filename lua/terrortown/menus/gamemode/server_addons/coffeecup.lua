CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_server_addons_coffeecup_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_addons_coffeecup")

    form:MakeSlider({
        serverConvar = "ttt_coffeecup_amount",
        label = "label_coffeecup_amount",
        min = 1,
        max = 25,
        decimal = 0,
    })

    form:MakeSlider({
        serverConvar = "ttt_coffeecup_reward_size",
        label = "label_coffeecup_reward_size",
        min = 1,
        max = 25,
        decimal = 0,
    })

    form:MakeComboBox({
        serverConvar = "ttt_coffeecup_reward_mode",
        label = "label_coffeecup_reward_mode",
        choices = {
            {
                title = LANG.TryTranslation("label_coffeecup_score_points"),
                value = 1,
            },
            {
                title = LANG.TryTranslation("label_coffeecup_credits"),
                value = 2,
            },
            {
                title = LANG.TryTranslation("label_coffeecup_pointshop_points"),
                value = 3,
            },
            {
                title = LANG.TryTranslation("label_coffeecup_pointshop_premium_points"),
                value = 4,
            },
        },
    })
end