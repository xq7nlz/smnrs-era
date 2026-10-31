--- @class UIVictoryGuildWarLayout : UIVictoryLayout
UIVictoryGuildWarLayout = Class(UIVictoryGuildWarLayout, UIVictoryLayout)

function UIVictoryGuildWarLayout:InitLayoutConfig()
    --- @type UIVictoryGuildWarLayoutConfig
    self.layoutConfig = UIBaseConfig(self.anchor)
    --- @type UIGuildWarMedalConfig
    self.medal1 = UIBaseConfig(self.layoutConfig.rewardAnchor:GetChild(0))
    --- @type UIGuildWarMedalConfig
    self.medal2 = UIBaseConfig(self.layoutConfig.rewardAnchor:GetChild(1))
    --- @type UIGuildWarMedalConfig
    self.medal3 = UIBaseConfig(self.layoutConfig.rewardAnchor:GetChild(2))
end

function UIVictoryGuildWarLayout:InitLocalization()
    UIVictoryLayout.InitLocalization(self)
    --- @type string
    self.localizeGetPoint = LanguageUtils.LocalizeCommon("your_guild_get")
    self.medal1.textWin.text = LanguageUtils.LocalizeCommon("win")
    local guildWarConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig()
    self.medal2.textWin.text = string.format(LanguageUtils.LocalizeCommon("min_hero_dead_requirement"), 5 - guildWarConfig.minAttackerHeroDeadRequirement)
    self.medal3.textWin.text = string.format(LanguageUtils.LocalizeCommon("max_round_requirement"), guildWarConfig.maxRoundRequirement)
end

--- @param data {}
function UIVictoryGuildWarLayout:ShowData(data)
    local guildWarRecordData = zg.playerData:GetGuildData():GetGuildWarRecordData()
    --- @type {medalGain, condition1, condition2, condition3}
    local challengeResult = guildWarRecordData.challengeResult
    self:ShowPointGain(guildWarRecordData.challengeSlot,
            challengeResult.medalGain,
            challengeResult.condition1,
            challengeResult.condition2,
            challengeResult.condition3)
end

--- @param challengePosition number
--- @param maxMedal number
--- @param isMatchingCondition1 boolean
--- @param isMatchingCondition2 boolean
--- @param isMatchingCondition3 boolean
function UIVictoryGuildWarLayout:ShowPointGain(challengePosition, maxMedal, isMatchingCondition1, isMatchingCondition2, isMatchingCondition3)
    self.medal1.iconGuildWarMedals:SetActive(isMatchingCondition1)
    self.medal2.iconGuildWarMedals:SetActive(isMatchingCondition2)
    self.medal3.iconGuildWarMedals:SetActive(isMatchingCondition3)

    local conditionMatchingCount = 0
    local countMatching = function(isMatching)
        if isMatching then
            conditionMatchingCount = conditionMatchingCount + 1
        end
    end
    countMatching(isMatchingCondition1)
    countMatching(isMatchingCondition2)
    countMatching(isMatchingCondition3)
    if conditionMatchingCount > maxMedal then
        conditionMatchingCount = maxMedal
    end
    local eloPositionConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig()
    local slotElo = eloPositionConfig:GetEloByPosition(challengePosition)
    local point = conditionMatchingCount * slotElo
    self.layoutConfig.textMedal.text = string.format(self.localizeGetPoint, UIUtils.SetColorString(UIUtils.green_light, point))
end