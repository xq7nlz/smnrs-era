---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.EventServerOpenItemConfig"

--- @class BattlePassQuestItemView : UIEventQuestItem
BattlePassQuestItemView = Class(BattlePassQuestItemView, UIEventQuestItem)


--- @return void
function BattlePassQuestItemView:SetPrefabName()
    self.prefabName = 'event_battle_pass_quest_item_view'
    self.uiPoolType = UIPoolType.BattlePassQuestItem
end

--- @param questElementConfig QuestElementConfig
--- @param questUnitInBound QuestUnitInBound
--- @param recordProgress number
--- @param extraReward RewardInBound
function BattlePassQuestItemView:SetData(questElementConfig, questUnitInBound, recordProgress, extraReward)
    --- @type QuestType
    local questType = questElementConfig:GetQuestType()
    self.config.specialDeal:SetActive(false)
    local listIconReward = RewardInBound.GetItemIconDataList(questElementConfig:GetListReward())
    if extraReward ~= nil then
        listIconReward:Add(extraReward:GetIconData())
    end
    self.itemsTableView:SetData(listIconReward)

    self.config.bgQuestProgressBarFull:SetActive(false)
    local mainReq = questElementConfig:GetMainRequirementTarget()
    if questUnitInBound ~= nil then
        mainReq = questUnitInBound.fixedTarget or mainReq
        local number = questUnitInBound.number
        self:SetButtonVisual(questUnitInBound.questState, questElementConfig:GetFeatureMappingData())

        if questType == QuestType.HERO_COLLECT_ALL_BASE_STAR then
            local factionReq = questElementConfig:GetRequirements():Get(4)
            if MathUtils.IsNumber(factionReq) == true then
                mainReq = ResourceMgr.GetHeroMenuConfig():GetNumberOfHeroBaseByStarAndFaction(mainReq, factionReq)
            else
                mainReq = ResourceMgr.GetHeroMenuConfig():GetNumberOfHeroBaseByStarAndFaction(mainReq, nil)
            end
        end
            self.config.textProgress.text = string.format("%d/%d", number, mainReq)
            self.config.bgQuestProgressBar2.gameObject:SetActive(true)
            self.config.bgQuestProgressBar2.fillAmount = number / mainReq
            self.config.bgQuestProgressBarFull:SetActive(self.config.bgQuestProgressBar2.fillAmount >= 1 or questUnitInBound.questState == QuestState.COMPLETED)
    else
        self.config.textProgress.text = string.format("?/%d", mainReq)
        self.config.bgQuestProgressBar2.fillAmount = 0
    end
    --self.config.textQuestContent.text = questUnitInBound.groupId .. "]" .. "[" .. tostring(questElementConfig.orderInGroup) .. "]" .. LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, questElementConfig)
    self.config.textQuestContent.text = LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, questElementConfig)
    if recordProgress ~= nil then
        self.config.textQuestRecord.text = string.format("%s <color=#%s>%s</color>",
                LanguageUtils.LocalizeCommon("highest_ever"),
                UIUtils.green_dark,
                recordProgress)
    else
        self.config.textQuestRecord.text = ""
    end
end

return BattlePassQuestItemView