---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupQuestNodeInfo.UIPopupQuestNodeInfoConfig"

--- @class UIPopupQuestNodeInfoView : UIBaseView
UIPopupQuestNodeInfoView = Class(UIPopupQuestNodeInfoView, UIBaseView)

--- @return void
--- @param model UIPopupQuestNodeInfoModel
function UIPopupQuestNodeInfoView:Ctor(model)
    --- @type UIPopupQuestNodeInfoConfig
    self.config = nil
    --- @type RootIconView
    self.rootIconView = nil

    UIBaseView.Ctor(self, model)
    --- @type UIPopupQuestNodeInfoModel
    self.model = model
end

--- @return void
function UIPopupQuestNodeInfoView:OnReadyCreate()
    ---@type UIPopupQuestNodeInfoConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()
end

function UIPopupQuestNodeInfoView:_InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIPopupQuestNodeInfoView:InitLocalization()
    self.config.textGo.text = LanguageUtils.LocalizeCommon("go")
    self.config.textComplete.text = LanguageUtils.LocalizeCommon("completed")
    self.config.textQuestReward.text = LanguageUtils.LocalizeCommon("reward")
end

--- @param data {questUnitInBound : QuestUnitInBound, onClickComplete, questElementConfig : QuestElementConfig}
function UIPopupQuestNodeInfoView:OnReadyShow(data)
    local questUnitInBound = data.questUnitInBound
    self.config.buttonComplete.gameObject:SetActive(false)
    self.config.buttonGo.gameObject:SetActive(false)

    local targetToLocalize = data.questElementConfig:GetRequirementsToLocalize()
    if targetToLocalize ~= nil then
        self.config.textTittle.text = string.gsub(QuestDataInBound.GetLocalizeQuestTreeName(questUnitInBound.questId), "{1}", targetToLocalize)
    else
        self.config.textTittle.text = QuestDataInBound.GetLocalizeQuestTreeName(questUnitInBound.questId)
    end

    self:AddOnClickCompleteListener(data.onClickComplete)
    --- @type RewardInBound
    local reward = data.questElementConfig:GetMainRewardData()
    --- @type number
    local featureMapping = data.questElementConfig:GetFeatureMappingData()
    local resNum = reward.number
    if MathUtils.IsNumber(resNum) == false then
        resNum = ClientMathUtils.ConvertingCalculation(resNum)
    end
    self:GetItemIconView():SetIconData(reward:GetIconData())
    self.rootIconView:RegisterShowInfo()

    if questUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM then
        self.config.buttonComplete.gameObject:SetActive(true)
    elseif questUnitInBound.questState == QuestState.DOING and featureMapping ~= -1 then
        self.config.buttonGo.onClick:RemoveAllListeners()
        self.config.buttonGo.onClick:AddListener(function()
            QuestDataInBound.GoQuest(questUnitInBound.questId, data.questElementConfig, function()
                self:OnReadyHide()
                PopupMgr.HidePopup(UIPopupName.UIQuest)
            end)
        end)
        self.config.buttonGo.gameObject:SetActive(true)
    end

    local content = LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, data.questElementConfig)
    self.config.textTarget.text = string.format("%s <color=#%s>(%d/%d)</color>", content, "6E3A08", questUnitInBound.number, data.questElementConfig:GetMainRequirementTarget())
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
end

--- @return void
function UIPopupQuestNodeInfoView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return RootIconView
function UIPopupQuestNodeInfoView:GetItemIconView()
    if self.rootIconView == nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAndhor)
    end
    return self.rootIconView
end

function UIPopupQuestNodeInfoView:AddOnClickCompleteListener(listener)
    self.config.buttonComplete.onClick:RemoveAllListeners()
    if listener ~= nil then
        self.config.buttonComplete.onClick:AddListener(listener)
    end
end

function UIPopupQuestNodeInfoView:Hide()
    UIBaseView.Hide(self)
    self:ReturnPool()
    self:RemoveListenerTutorial()
end

function UIPopupQuestNodeInfoView:ReturnPool()
    if self.rootIconView ~= nil then
        self.rootIconView:ReturnPool()
        self.rootIconView = nil
    end
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIPopupQuestNodeInfoView:ShowTutorial(tutorial, step)
    --XDebug.Log(step)
    if step == TutorialStep.CLICK_GO then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonGo, U_Vector2(400, 200), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_QUEST_COMPLETE then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonComplete, U_Vector2(400, 200), nil, nil, TutorialHandType.CLICK)
    end
end


