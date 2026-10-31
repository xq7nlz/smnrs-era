--- @class EventSeasonalQuestItem : UIEventQuestItem
EventSeasonalQuestItem = Class(EventSeasonalQuestItem, MotionIconView)

function EventSeasonalQuestItem:Ctor()
    MotionIconView.Ctor(self)
    self:InitButtonListener()
end

function EventSeasonalQuestItem:SetPrefabName()
    self.prefabName = 'event_seasonal_quest_item'
    self.uiPoolType = UIPoolType.EventSeasonalQuestItem
end

--- @param transform UnityEngine_Transform
function EventSeasonalQuestItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type EventSeasonalQuestItemConfig
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.itemAnchor)
end

function EventSeasonalQuestItem:InitLocalization()
    self.config.textClaimed.text = LanguageUtils.LocalizeCommon("claimed")
    self.config.textCollect.text = LanguageUtils.LocalizeCommon("collect")
    self.config.textGo.text = LanguageUtils.LocalizeCommon("go")
end

function EventSeasonalQuestItem:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param questElementConfig QuestElementConfig
--- @param questUnitInBound QuestUnitInBound
--- @param recordProgress number
--- @param extraRewards List
function EventSeasonalQuestItem:SetData(questElementConfig, questUnitInBound, recordProgress, extraRewards)
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
        self:SetButtonVisual(questUnitInBound.questState, questElementConfig:GetFeatureMappingData(), number, mainReq)

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
    self.config.textQuestContent.text = string.format("%s %s %s",
            LanguageUtils.LocalizeCommon("make"),
            questUnitInBound.config._listRequirements:Get(1),
            LanguageUtils.LocalizeMoneyType(questUnitInBound.config._listRequirements:Get(2)))
end

--- @param questState QuestState
--- @param featureMapping number
function EventSeasonalQuestItem:SetButtonVisual(questState, featureMapping, currentNumber, numberRequire)
    self.config.claimedButton.gameObject:SetActive(false)
    self.config.collectButton.gameObject:SetActive(false)
    self.config.goButton.gameObject:SetActive(false)
    self.config.questProgress:SetActive(true)
    self.config.bgQuestProgressBar2.gameObject:SetActive(true)
    if currentNumber >= numberRequire and questState == QuestState.DOING then
        questState = QuestState.DONE_REWARD_NOT_CLAIM
    end
    if questState == QuestState.LOCKED then

    elseif (questState == QuestState.DOING or questState == QuestState.HIDDEN) then
        --self.config.goButton.gameObject:SetActive(true)
    elseif questState == QuestState.DONE_REWARD_NOT_CLAIM then
        self.config.collectButton.gameObject:SetActive(true)
        self.config.bgQuestProgressBarFull:SetActive(true)
        self.config.bgQuestProgressBar2.gameObject:SetActive(false)
    elseif questState == QuestState.LOCKED_NOT_CALCULATED then

    elseif questState == QuestState.COMPLETED then
        self.config.collectButton.gameObject:SetActive(false)
        self.config.bgQuestProgressBarFull:SetActive(true)
        self.config.bgQuestProgressBar2.gameObject:SetActive(false)
        self.config.claimedButton.gameObject:SetActive(true)
    elseif questState == QuestState.INITIAL then

    end
end

--- @param func function
function EventSeasonalQuestItem:AddClaimListener(func)
    self.config.collectButton.onClick:RemoveAllListeners()
    self.config.collectButton.onClick:AddListener(function()
        if func ~= nil then
            func()
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @param func function
function EventSeasonalQuestItem:InitButtonListener()
    self.config.claimedButton.onClick:RemoveAllListeners()
    self.config.claimedButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
    end)
end

--- @return void
function EventSeasonalQuestItem:RemoveAllListeners()
    self.config.goButton.onClick:RemoveAllListeners()
end

--- @param func function
function EventSeasonalQuestItem:AddGoListener(func)
    self.config.goButton.onClick:RemoveAllListeners()
    self.config.goButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func ~= nil then
            func()
        end
    end)
end

return EventSeasonalQuestItem