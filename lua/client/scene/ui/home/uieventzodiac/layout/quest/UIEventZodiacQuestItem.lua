--- @class UIEventZodiacQuestItem : UIEventQuestItem
UIEventZodiacQuestItem = Class(UIEventZodiacQuestItem, MotionIconView)

function UIEventZodiacQuestItem:Ctor()
    MotionIconView.Ctor(self)
    self:InitButtonListener()
end

function UIEventZodiacQuestItem:SetPrefabName()
    self.prefabName = 'event_zodiac_quest_item'
    self.uiPoolType = UIPoolType.UIEventZodiacQuestItem
end


--- @param transform UnityEngine_Transform
function UIEventZodiacQuestItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventZodiacQuestItemConfig
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.itemAnchor)
end

function UIEventZodiacQuestItem:InitLocalization()
    self.config.localizeCollect.text = LanguageUtils.LocalizeCommon("claim")
    self.config.textClaimed.text = LanguageUtils.LocalizeCommon("claimed")
end

function UIEventZodiacQuestItem:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param questElementConfig QuestElementConfig
--- @param questUnitInBound QuestUnitInBound
--- @param recordProgress number
--- @param extraRewards List
function UIEventZodiacQuestItem:SetData(questElementConfig, questUnitInBound, recordProgress, extraRewards)
    --- @type QuestType
    local questType = questElementConfig:GetQuestType()
    local listIconReward = RewardInBound.GetItemIconDataList(questElementConfig:GetListReward())
    if extraRewards ~= nil then
        for i = 1, extraRewards:Count() do
            listIconReward:Add(extraRewards:Get(i):GetIconData())
        end
    end

    self.itemsTableView:SetData(listIconReward)
    self.config.bgQuestProgressBarFull:SetActive(false)
    local mainReq = questElementConfig:GetMainRequirementTarget()
    if questUnitInBound ~= nil then
        mainReq = questUnitInBound.fixedTarget or mainReq
        local number = questUnitInBound.number
        self:SetButtonVisual(questUnitInBound.questState, questElementConfig:GetFeatureMappingData())

        if questType == QuestType.DAILY_QUEST_COMPLETE then
            local factionReq = questElementConfig:GetRequirements():Get(4)
            if MathUtils.IsNumber(factionReq) == true then
                mainReq = ResourceMgr.GetHeroMenuConfig():GetNumberOfHeroBaseByStarAndFaction(mainReq, factionReq)
            else
                mainReq = ResourceMgr.GetHeroMenuConfig():GetNumberOfHeroBaseByStarAndFaction(mainReq, nil)
            end
        end
        self.config.textProgress.text = string.format("%d/%d", number, mainReq)
        self.config.bgQuestProgressBar2.fillAmount = number / mainReq
        self.config.bgQuestProgressBarFull:SetActive(self.config.bgQuestProgressBar2.fillAmount >= 1 or questUnitInBound.questState == QuestState.COMPLETED)
    else
        self.config.bgQuestProgressBar2.fillAmount = 0
        self.config.textProgress.text = string.format("?/%d", mainReq)
    end
    --self.config.textQuestContent.text = questUnitInBound.groupId .. "]" .. "[" .. tostring(questElementConfig.orderInGroup) .. "]" .. LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, questElementConfig)
    self.config.textQuestContent.text = LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, questElementConfig)
end

--- @param questState QuestState
--- @param featureMapping number
function UIEventZodiacQuestItem:SetButtonVisual(questState, featureMapping)
    self.config.claimedButton.gameObject:SetActive(false)
    self.config.collectButton.gameObject:SetActive(false)
    self.config.questProgress:SetActive(true)
    if questState == QuestState.LOCKED then

    elseif (questState == QuestState.DOING or questState == QuestState.HIDDEN)
            and featureMapping ~= -1 then
    elseif questState == QuestState.DONE_REWARD_NOT_CLAIM then
        self.config.collectButton.gameObject:SetActive(true)
        self.config.questProgress:SetActive(false)
    elseif questState == QuestState.LOCKED_NOT_CALCULATED then

    elseif questState == QuestState.COMPLETED then
        self.config.collectButton.gameObject:SetActive(false)
        self.config.questProgress:SetActive(false)
        self.config.claimedButton.gameObject:SetActive(true)
    elseif questState == QuestState.INITIAL then

    end
end

--- @param func function
function UIEventZodiacQuestItem:AddClaimListener(func)
    self.config.collectButton.onClick:RemoveAllListeners()
    self.config.collectButton.onClick:AddListener(function()
        if func ~= nil then
            func()
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @param func function
function UIEventZodiacQuestItem:InitButtonListener()
    self.config.claimedButton.onClick:RemoveAllListeners()
    self.config.claimedButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
    end)
end

--- @return void
function UIEventZodiacQuestItem:RemoveAllListeners()
    self.config.collectButton.onClick:RemoveAllListeners()
end

return UIEventZodiacQuestItem