--- @class UIEventQuestItem : QuestItemView
UIEventQuestItem = Class(UIEventQuestItem, QuestItemView)

function UIEventQuestItem:Ctor()
    --- @type ItemsTableView
    self.itemsTableView = nil
    ---@type UIEventQuestItemConfig
    self.config = nil
    QuestItemView.Ctor(self)
end

function UIEventQuestItem:SetPrefabName()
    self.prefabName = 'event_quest_item_view'
    self.uiPoolType = UIPoolType.EventQuestItem
end

function UIEventQuestItem:SetItemSpacing(spacing)
    if spacing ~= nil then
        if self.config.itemLayoutGroup ~= nil  then
            self.config.itemLayoutGroup.spacing = spacing
        end
    end
end
--- @param questElementConfig QuestElementConfig
--- @param questUnitInBound QuestUnitInBound
--- @param recordProgress number
--- @param extraReward RewardInBound
function UIEventQuestItem:SetData(questElementConfig, questUnitInBound, recordProgress, extraReward)
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
        if questType == QuestType.CAMPAIGN_STAGE_PASS then
            local pos = self.config.textQuestContent.transform.localPosition
            self.config.textQuestContent.transform.localPosition = U_Vector3(pos.x,30,pos.z)
            self.config.textProgress.text = "";
            self.config.bgQuestProgressBar2.gameObject:SetActive(false)
            self.config.bgQuestProgressBarFull:SetActive(false)
            self.config.bgQuestProgressBarSlot.enabled = false
        else
            local pos = self.config.textQuestContent.transform.localPosition
            self.config.textQuestContent.transform.localPosition = U_Vector3(pos.x,61.37,pos.z)
            self.config.bgQuestProgressBarSlot.enabled = true
            self.config.textProgress.text = string.format("%d/%d", number, mainReq)
            self.config.bgQuestProgressBar2.fillAmount = number / mainReq
            self.config.bgQuestProgressBarFull:SetActive(self.config.bgQuestProgressBar2.fillAmount >= 1 or questUnitInBound.questState == QuestState.COMPLETED)
        end
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

function UIEventQuestItem:ReturnPool()
    QuestItemView.ReturnPool(self)
    self:SetItemSpacing(0)
end


return UIEventQuestItem