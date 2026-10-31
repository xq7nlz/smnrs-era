--- @class UIEventBossChallengeQuestItem : UIEventQuestItem
UIEventBossChallengeQuestItem = Class(UIEventBossChallengeQuestItem, MotionIconView)

function UIEventBossChallengeQuestItem:Ctor()
    MotionIconView.Ctor(self)
end

function UIEventBossChallengeQuestItem:SetPrefabName()
    self.prefabName = 'event_quest_boss_challenge_item'
    self.uiPoolType = UIPoolType.UIEventBossChallengeQuestItem
end

--- @param transform UnityEngine_Transform
function UIEventBossChallengeQuestItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventBossChallengeItemConfig
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.itemAnchor)
end

function UIEventBossChallengeQuestItem:InitLocalization()
    self.config.localizeCollect.text = LanguageUtils.LocalizeCommon("claim")
    self.config.goToClaimed.text = LanguageUtils.LocalizeCommon("go")
end

function UIEventBossChallengeQuestItem:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param questUnitInBound QuestUnitInBound
--- @param questElementConfig QuestElementConfig
function UIEventBossChallengeQuestItem:SetData(questElementConfig,questUnitInBound)
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
    if questElementConfig:GetRequirementsByIndex(2) == -1 and questElementConfig._questType == 300 then
        self.config.textQuestContent.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("event_halloween_quest_tavern_all_star"),
                tostring(mainReq))
    else
        self.config.textQuestContent.text = LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, questElementConfig)
    end
end

--- @param questState QuestState
--- @param featureMapping number
function UIEventBossChallengeQuestItem:SetButtonVisual(questState, featureMapping)
    self.config.collectButton.gameObject:SetActive(false)
    self.config.goToButton.gameObject:SetActive(false)
    self.config.tick:SetActive(false)

    if questState == QuestState.LOCKED then

    elseif (questState == QuestState.DOING or questState == QuestState.HIDDEN)
            and featureMapping ~= -1 then
        self.config.goToButton.gameObject:SetActive(true)
        self.config.collectButton.gameObject:SetActive(false)
    elseif questState == QuestState.DONE_REWARD_NOT_CLAIM then
        self.config.collectButton.gameObject:SetActive(true)
    elseif questState == QuestState.LOCKED_NOT_CALCULATED then

    elseif questState == QuestState.COMPLETED then
        self.config.tick:SetActive(true)
        ---@param v RootIconView
        for _, v in pairs(self.itemsTableView.iconViewList:GetItems()) do
            v:ActiveTickSelect(true)
        end
    elseif questState == QuestState.INITIAL then

    end
end

--- @param func function
function UIEventBossChallengeQuestItem:AddClaimListener(func)
    self.config.collectButton.onClick:RemoveAllListeners()
    self.config.collectButton.onClick:AddListener(function()
        if func ~= nil then
            func()
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @param func function
function UIEventBossChallengeQuestItem:SetButtonGotoData(func)
    self:AddGotoListener(func)
end

--- @param func function
function UIEventBossChallengeQuestItem:AddGotoListener(func)
    self.config.goToButton.onClick:RemoveAllListeners()
    self.config.goToButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        if func ~= nil then
            func()
        end
    end)
end

--- @return void
function UIEventBossChallengeQuestItem:RemoveAllListeners()
    self.config.collectButton.onClick:RemoveAllListeners()
end

return UIEventBossChallengeQuestItem