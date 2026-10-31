--- @class UIMiniQuestTreeView
UIMiniQuestTreeView = Class(UIMiniQuestTreeView)

--- @return void
--- @param transform UnityEngine_Transform
function UIMiniQuestTreeView:Ctor(transform)
    --- @type UIMiniQuestTreeConfig
    self.config = nil
    --- @type RootIconView
    self.rootIconView = nil
    --- @type function
    self.onClickGo = nil
    --- @type function
    self.onClickComplete = nil
    self:OnCreate(transform)
end

--- @return void
function UIMiniQuestTreeView:OnCreate(transform)
    ---@type UIMiniQuestTreeConfig
    self.config = UIBaseConfig(transform)
    self:InitButtonListener()
end

function UIMiniQuestTreeView:InitLocalization()
    self.config.localizeGo.text = LanguageUtils.LocalizeCommon("go")
    self.config.localizeClose.text = LanguageUtils.LocalizeCommon("hide")
    self.config.localizeComplete.text = LanguageUtils.LocalizeCommon("claim")
end

function UIMiniQuestTreeView:InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCollapsed()
    end)
    self.config.buttonGo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.onClickGo ~= nil then
            self.onClickGo()
        end
    end)
    self.config.buttonComplete.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.onClickComplete ~= nil then
            self.onClickComplete()
        end
    end)
    self.config.buttonExpand.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickExpand()
    end)
end

--- @param data {questUnitInBound : QuestUnitInBound, onClaimSuccess, isCollapsed}
function UIMiniQuestTreeView:OnReadyShow(data)
    LanguageUtils.CheckInitLocalize(self, UIMiniQuestTreeView.InitLocalization)
    self.config.buttonGo.gameObject:SetActive(false)
    self.config.buttonComplete.gameObject:SetActive(false)
    if data.isCollapsed ~= nil then
        self:SetCollapseState(data.isCollapsed)
        self.config.gameObject:SetActive(true)
    end

    local questUnitInBound = data.questUnitInBound

    --- @type QuestElementConfig
    local questElementConfig = ResourceMgr.GetQuestConfig():GetQuestTree():Get(questUnitInBound.questId)

    local reward = questElementConfig:GetMainRewardData()
    self:GetItemIconView():SetIconData(reward:GetIconData())
    self.rootIconView:RegisterShowInfo()

    local mainReq = questElementConfig:GetMainRequirementTarget()
    if questElementConfig:GetQuestType() == QuestType.HERO_COLLECT_ALL_BASE_STAR then
        local factionReq = questElementConfig:GetRequirements():Get(4)
        if MathUtils.IsNumber(factionReq) == true then
            mainReq = ResourceMgr.GetHeroMenuConfig():GetNumberOfHeroBaseByStarAndFaction(mainReq, factionReq)
        else
            mainReq = ResourceMgr.GetHeroMenuConfig():GetNumberOfHeroBaseByStarAndFaction(mainReq, nil)
        end
    end
    self.config.textProgress.text = string.format("%d/%d", questUnitInBound.number, mainReq)
    self.config.bgQuestProgressBar.fillAmount = questUnitInBound.number / mainReq
    self.config.bgQuestProgressBarFull:SetActive(self.config.bgQuestProgressBar.fillAmount >= 1)
    self.config.questContent.text = LanguageUtils.LocalizeQuestDescription(questUnitInBound.questId, questElementConfig)

    --- @type number
    local featureMapping = questElementConfig:GetFeatureMappingData()
    local resNum = reward.number
    if MathUtils.IsNumber(resNum) == false then
        resNum = ClientMathUtils.ConvertingCalculation(resNum)
    end

    if questUnitInBound.questState == QuestState.DOING and featureMapping ~= -1 then
        self.config.buttonGo.gameObject:SetActive(true)
        self.onClickGo = function()
            QuestDataInBound.GoQuest(questUnitInBound.questId, questElementConfig, nil, true)
        end
    elseif questUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM then
        self.config.buttonComplete.gameObject:SetActive(true)
        self.onClickComplete = function()
            --- @param rewardList List
            local onClaimSuccess = function(rewardList)
                self:Hide()
                --- @type QuestDataInBound
                local questDataInBound = zg.playerData:GetMethod(PlayerDataMethod.QUEST)
                questDataInBound:SetQuestTreeComplete(questUnitInBound.questId)
                if data.onClaimSuccess ~= nil then
                    data.onClaimSuccess()
                end
                PopupUtils.ClaimAndShowRewardList(rewardList)
            end
            QuestDataInBound.RequestClaimQuest(OpCode.QUEST_TREE_CLAIM, questUnitInBound.questId, onClaimSuccess)
        end
    end
end

--- @return RootIconView
function UIMiniQuestTreeView:GetItemIconView()
    if self.rootIconView == nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
    end
    return self.rootIconView
end

--- @return boolean
function UIMiniQuestTreeView:IsActiveSelf()
    return self.config.gameObject.activeSelf
end

function UIMiniQuestTreeView:Hide()
    self.config.buttonExpand.gameObject:SetActive(false)
    self.config.popup.gameObject:SetActive(false)
    self.config.gameObject:SetActive(false)
    self.config.buttonComplete.gameObject:SetActive(false)
end

function UIMiniQuestTreeView:OnClickCollapsed()
    zg.playerData:GetQuest().questTreeDataInBound.isCollapsed = true
    DOTweenUtils.DOScale(self.config.popup, U_Vector3.zero, 0.1,
            U_Ease.Linear,
            function()
                self.config.buttonExpand.gameObject:SetActive(true)
                self.config.popup.gameObject:SetActive(false)
            end)
end

function UIMiniQuestTreeView:OnClickExpand()
    zg.playerData:GetQuest().questTreeDataInBound.isCollapsed = false
    self.config.buttonExpand.gameObject:SetActive(false)
    self.config.popup.localScale = U_Vector3.zero
    self.config.popup.gameObject:SetActive(true)
    DOTweenUtils.DOScale(self.config.popup, U_Vector3.one, 0.1,
            U_Ease.Linear,
            function()

            end)
end

--- @param isCollapsed boolean
function UIMiniQuestTreeView:SetCollapseState(isCollapsed)
    self.config.buttonExpand.gameObject:SetActive(isCollapsed)
    if isCollapsed then
        self.config.popup.localScale = U_Vector3.zero
    else
        self.config.popup.localScale = U_Vector3.one
    end
    self.config.popup.gameObject:SetActive(not isCollapsed)
end