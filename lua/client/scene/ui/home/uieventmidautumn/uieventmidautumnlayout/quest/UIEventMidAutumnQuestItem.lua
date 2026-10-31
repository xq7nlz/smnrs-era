--- @class UIEventMidAutumnQuestItem : UIEventQuestItem
UIEventMidAutumnQuestItem = Class(UIEventMidAutumnQuestItem, MotionIconView)

function UIEventMidAutumnQuestItem:Ctor()
    MotionIconView.Ctor(self)
    self:InitButtonListener()
end

function UIEventMidAutumnQuestItem:SetPrefabName()
    self.prefabName = 'event_mid_autumn_quest_item'
    self.uiPoolType = UIPoolType.UIEventMidAutumnQuestItem
end

--- @param transform UnityEngine_Transform
function UIEventMidAutumnQuestItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventMidAutumnQuestItemConfig
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.itemAnchor)
end

function UIEventMidAutumnQuestItem:InitLocalization()
    self.config.textClaimed.text = LanguageUtils.LocalizeCommon("claimed")
    self.config.localizeCollect.text = LanguageUtils.LocalizeCommon("claim")
    self.config.localizeGo.text = LanguageUtils.LocalizeCommon("go")
end

function UIEventMidAutumnQuestItem:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param questUnitInBound QuestUnitInBound
--- @param questElementConfig QuestElementConfig
function UIEventMidAutumnQuestItem:SetData(questUnitInBound)
    local questElementConfig = questUnitInBound.config
    --- @type QuestType
    local questType = questElementConfig:GetQuestType()
    local listIconReward = RewardInBound.GetItemIconDataList(questElementConfig:GetListReward())
    self.itemsTableView:SetData(listIconReward, UIPoolType.RootIconView)
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
    if questElementConfig:GetRequirementsByIndex(2) == 180 and questElementConfig._questType == 2001 then
        self.config.textQuestContent.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("event_mid_autumn_text_quest_bet"),
               tostring(mainReq))
    elseif questElementConfig:GetRequirementsByIndex(2) == 221 and questElementConfig._questType == 2001 then
        self.config.textQuestContent.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("event_christmas_text_quest_bet"),
                tostring(mainReq))
    elseif questElementConfig._questType == 2901 and questElementConfig:GetMainRewardData().id == 222 then
        self.config.textQuestContent.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("event_christmas_blessing_quest"),
                tostring(mainReq))
    elseif questElementConfig:GetRequirementsByIndex(2) == -1 and questElementConfig._questType == 300 then
        self.config.textQuestContent.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("event_halloween_quest_tavern_all_star"),
                    tostring(mainReq))
    else
        self.config.textQuestContent.text = LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, questElementConfig)
    end
end

--- @param questState QuestState
--- @param featureMapping number
function UIEventMidAutumnQuestItem:SetButtonVisual(questState, featureMapping)
    self.config.claimedButton.gameObject:SetActive(false)
    self.config.collectButton.gameObject:SetActive(false)
    self.config.goButton.gameObject:SetActive(false)
    self.config.tick:SetActive(false)
    self.config.localizeCollect.text = LanguageUtils.LocalizeCommon("claim")
    if questState == QuestState.LOCKED then

    elseif (questState == QuestState.DOING or questState == QuestState.HIDDEN) then
        self.config.goButton.gameObject:SetActive(true)
        self.config.collectButton.gameObject:SetActive(false)
    elseif questState == QuestState.DONE_REWARD_NOT_CLAIM then
        self.config.collectButton.gameObject:SetActive(true)
    elseif questState == QuestState.LOCKED_NOT_CALCULATED then

    elseif questState == QuestState.COMPLETED then
        self.config.collectButton.gameObject:SetActive(false)
        self.config.claimedButton.gameObject:SetActive(true)
        self.config.localizeCollect.text = LanguageUtils.LocalizeCommon("claimed")
        self.config.tick:SetActive(true)
        ---@param v RootIconView
        for _, v in pairs(self.itemsTableView.iconViewList:GetItems()) do
            v:ActiveTickSelect(true)
        end
    elseif questState == QuestState.INITIAL then

    end
end

--- @param func function
function UIEventMidAutumnQuestItem:AddClaimListener(func)
    self.config.collectButton.onClick:RemoveAllListeners()
    self.config.collectButton.onClick:AddListener(function()
        if func ~= nil then
            func()
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @param func function
function UIEventMidAutumnQuestItem:SetButtonGotoData(func)
    self:AddGotoListener(func)
end

--- @param func function
function UIEventMidAutumnQuestItem:AddGotoListener(func)
    self.config.goButton.onClick:RemoveAllListeners()
    self.config.goButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        if func ~= nil then
            func()
        end
    end)
end

--- @param func function
function UIEventMidAutumnQuestItem:InitButtonListener()
    self.config.claimedButton.onClick:RemoveAllListeners()
    self.config.claimedButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
    end)
end

--- @return void
function UIEventMidAutumnQuestItem:RemoveAllListeners()
    self.config.collectButton.onClick:RemoveAllListeners()
    self.config.goButton.onClick:RemoveAllListeners()
end

return UIEventMidAutumnQuestItem