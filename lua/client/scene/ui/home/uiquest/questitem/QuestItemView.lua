--- @class QuestItemView : MotionIconView
QuestItemView = Class(QuestItemView, MotionIconView)

function QuestItemView:Ctor()
    --- @type QuestItemViewConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    MotionIconView.Ctor(self)
end

function QuestItemView:SetPrefabName()
    self.prefabName = 'quest_item'
    self.uiPoolType = UIPoolType.QuestItemView
end

--- @param transform UnityEngine_Transform
function QuestItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type QuestItemViewConfig
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.itemAnchor)
end

function QuestItemView:InitLocalization()
    self.config.localizeCollect.text = LanguageUtils.LocalizeCommon("claim")
    self.config.localizeGo.text = LanguageUtils.LocalizeCommon("go")
end

function QuestItemView:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param questElementConfig QuestElementConfig
--- @param questUnitInBound QuestUnitInBound
--- @param recordProgress number
--- @param extraRewards List
function QuestItemView:SetData(questElementConfig, questUnitInBound, recordProgress, extraRewards)
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

        if questType == QuestType.HERO_COLLECT_ALL_BASE_STAR then
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

--- @param questState QuestState
--- @param featureMapping number
function QuestItemView:SetButtonVisual(questState, featureMapping)
    self.config.collectButton.gameObject:SetActive(false)
    self.config.goButton.gameObject:SetActive(false)
    self.config.tick:SetActive(false)

    if questState == QuestState.LOCKED then

    elseif (questState == QuestState.DOING or questState == QuestState.HIDDEN)
            and featureMapping ~= -1 then
        self.config.goButton.gameObject:SetActive(true)
        self.config.collectButton.gameObject:SetActive(false)
    elseif questState == QuestState.DONE_REWARD_NOT_CLAIM then
        self.config.collectButton.gameObject:SetActive(true)
    elseif questState == QuestState.LOCKED_NOT_CALCULATED then

    elseif questState == QuestState.COMPLETED then
        self.config.tick:SetActive(true)
    elseif questState == QuestState.INITIAL then

    end
end

--- @param func function
function QuestItemView:AddClaimListener(func)
    self.config.collectButton.onClick:RemoveAllListeners()
    self.config.collectButton.onClick:AddListener(function()
        if func ~= nil then
            func()
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @param func function
function QuestItemView:AddGoListener(func)
    self.config.goButton.onClick:RemoveAllListeners()
    self.config.goButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func ~= nil then
            func()
        end
    end)
end

--- @return void
function QuestItemView:RemoveAllListeners()
    self.config.collectButton.onClick:RemoveAllListeners()
    self.config.goButton.onClick:RemoveAllListeners()
end

return QuestItemView