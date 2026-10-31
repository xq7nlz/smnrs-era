--- @class UIGuildWarEndBattleView
UIGuildWarEndBattleView = Class(UIGuildWarEndBattleView)

--- @return void
function UIGuildWarEndBattleView:Ctor(object)
    --- @type UIGuildWarVictoryConfig
    self.config = UIBaseConfig(object)
    --- @type UIGuildWarMedalConfig
    self.medal1 = UIBaseConfig(self.config.rewardAnchor:GetChild(0))
    --- @type UIGuildWarMedalConfig
    self.medal2 = UIBaseConfig(self.config.rewardAnchor:GetChild(1))
    --- @type UIGuildWarMedalConfig
    self.medal3 = UIBaseConfig(self.config.rewardAnchor:GetChild(2))
    ---@type GuildWarConfig
    self.guildWarConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig()
end

--- @return void
function UIGuildWarEndBattleView:InitLocalize()
    self.medal1.textWin.text = LanguageUtils.LocalizeCommon("win")
    self.medal2.textWin.text = string.format(LanguageUtils.LocalizeCommon("min_hero_dead_requirement"), 5 - self.guildWarConfig.minAttackerHeroDeadRequirement)
    self.medal3.textWin.text = string.format(LanguageUtils.LocalizeCommon("max_round_requirement"), self.guildWarConfig.maxRoundRequirement)
end