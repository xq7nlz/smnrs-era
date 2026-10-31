--- @class UIEventAiryuuQuestItem : UIEventQuestItem
UIEventAiryuuQuestItem = Class(UIEventAiryuuQuestItem, MotionIconView)

function UIEventAiryuuQuestItem:Ctor()
    MotionIconView.Ctor(self)
    self:InitButtonListener()
end

function UIEventAiryuuQuestItem:SetPrefabName()
    self.prefabName = 'event_airyuu_quest_item'
    self.uiPoolType = UIPoolType.UIEventAiryuuQuestItem
end

--- @param transform UnityEngine_Transform
function UIEventAiryuuQuestItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventAiryuuQuestItemConfig
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.itemAnchor)
end

function UIEventAiryuuQuestItem:InitLocalization()
    self.config.textClaimed.text = LanguageUtils.LocalizeCommon("claimed")
    self.config.textCollect.text = LanguageUtils.LocalizeCommon("collect")
    self.config.textGo.text = LanguageUtils.LocalizeCommon("go")
end

function UIEventAiryuuQuestItem:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param questElementConfig QuestElementConfig
--- @param questUnitInBound QuestUnitInBound
--- @param recordProgress number
--- @param extraRewards List
function UIEventAiryuuQuestItem:SetData(questElementConfig, questUnitInBound, recordProgress, extraRewards)
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
function UIEventAiryuuQuestItem:SetButtonVisual(questState, featureMapping)
    self.config.claimedButton.gameObject:SetActive(false)
    self.config.collectButton.gameObject:SetActive(false)
    self.config.goButton.gameObject:SetActive(false)
    self.config.questProgress:SetActive(true)
    self.config.bgQuestProgressBar2.gameObject:SetActive(true)
    if questState == QuestState.LOCKED then

    elseif (questState == QuestState.DOING or questState == QuestState.HIDDEN) then
        self.config.goButton.gameObject:SetActive(true)
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
function UIEventAiryuuQuestItem:AddClaimListener(func)
    self.config.collectButton.onClick:RemoveAllListeners()
    self.config.collectButton.onClick:AddListener(function()
        if func ~= nil then
            func()
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @param func function
function UIEventAiryuuQuestItem:InitButtonListener()
    self.config.claimedButton.onClick:RemoveAllListeners()
    self.config.claimedButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
    end)
end

--- @param func function
function UIEventAiryuuQuestItem:AddGoListener(func)
    self.config.goButton.onClick:RemoveAllListeners()
    self.config.goButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func ~= nil then
            func()
        end
    end)
end

--- @return void
function UIEventAiryuuQuestItem:RemoveAllListeners()
    self.config.goButton.onClick:RemoveAllListeners()
end

return UIEventAiryuuQuestItem