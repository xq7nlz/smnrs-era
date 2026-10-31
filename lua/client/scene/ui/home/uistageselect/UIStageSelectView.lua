--- @class UIStageSelectView : UIBaseView
UIStageSelectView = Class(UIStageSelectView, UIBaseView)

--- @return void
--- @param model UIStageSelectModel
function UIStageSelectView:Ctor(model, ctrl)
    ---@type UIStageSelectConfig
    self.config = nil
    ---@type ItemsTableView
    self.scrollView = nil
    ---@type function
    self.callbackAutoBattle = nil

    ---@type UnityEngine_GameObject
    self.particleGold = nil
    ---@type UnityEngine_GameObject
    self.particleGem = nil
    ---@type UnityEngine_GameObject
    self.particleGoldEnd = nil
    ---@type UnityEngine_GameObject
    self.particleGemEnd = nil

    ---@type UnityEngine_Transform
    self.posGoldEnd = nil
    ---@type UnityEngine_Transform
    self.particleGemEnd = nil

    -- init variables here
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIStageSelectModel
    self.model = self.model
end

--- @return void
function UIStageSelectView:OnReadyCreate()
    ---@type UIStageSelectConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.scrollView = ItemsTableView(self.config.content)

    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAutoBattle.onClick:AddListener(function()
        self:OnClickAutoBattle()
    end)
    self.config.buttonBattle.onClick:AddListener(function()
        self:OnClickBattle()
    end)

    --self.particleGold = ResourceLoadUtils.LoadUIEffect("fx_ui_claim", self.config.transform.parent)
    --self.particleGem = ResourceLoadUtils.LoadUIEffect("fx_ui_claim_green", self.config.transform.parent)
    --self.particleGemEnd = ResourceLoadUtils.LoadUIEffect("fx_ui_claim_icon_gem", self.config.transform.parent)
    --self.particleGoldEnd = ResourceLoadUtils.LoadUIEffect("fx_ui_claim_icon_gold", self.config.transform.parent)
    --
    --self.particleGold:SetActive(false)
    --self.particleGem:SetActive(false)
    --self.particleGoldEnd:SetActive(false)
    --self.particleGemEnd:SetActive(false)
end

--- @return void
function UIStageSelectView:InitLocalization()
    self.config.localizeItemLoot.text = LanguageUtils.LocalizeCommon("item_loot")

end

--- @return void
function UIStageSelectView:Init(result)
    if result ~= nil then
        if result.stageId ~= nil then
            self.model.stageId = result.stageId
            self.callbackAutoBattle = result.callbackAutoBattle
            self.model.resourceList = result.listItem
            self.model:UpdateData()

            self:UpdateUI()
        end
    end
end

--- @return void
function UIStageSelectView:SetDataIdleReward(gold, gem, exp, listItem)
    if gold ~= nil then
        self.config.gold:SetActive(true)
        self.config.textGold.text = ClientConfigUtils.FormatNumber(gold)
    else
        self.config.gold:SetActive(false)
    end
    if gem ~= nil then
        self.config.gem:SetActive(true)
        self.config.textGem.text = ClientConfigUtils.FormatNumber(gem)
    else
        self.config.gem:SetActive(false)
    end
    if exp ~= nil then
        self.config.exp:SetActive(true)
        self.config.textExp.text = ClientConfigUtils.FormatNumber(exp)
    else
        self.config.exp:SetActive(false)
    end
    self.model.resourceList = listItem
    self.scrollView:SetData(self.model.resourceList)
    ---@param v IconView
    for _, v in pairs(self.scrollView:GetItems():GetItems()) do
        v:RegisterShowInfo()
    end
    self.difficult, self.map, self.stage = ClientConfigUtils.GetIdFromStageId(zg.playerData:GetCampaignData().stageIdle)
    self.config.textStage.text = string.format("%s %s-%s", LanguageUtils.LocalizeCommon("stage"), self.map, self.stage)
    self.config.emptyLoot:SetActive(self.model.resourceList:Count() == 0)
end

--- @return void
function UIStageSelectView:UpdateUI()
    self.config.buttonBattle.gameObject:SetActive(false)
    if self.model.stageId == zg.playerData:GetCampaignData().stageNext then
        self.config.buttonAutoBattle.gameObject:SetActive(false)
    else
        if self.callbackAutoBattle ~= nil then
            self.config.buttonAutoBattle.gameObject:SetActive(true)
        else
            self.config.buttonAutoBattle.gameObject:SetActive(false)
        end
    end

    self.config.textStage.text = string.format("%s %s-%s", LanguageUtils.LocalizeCommon("stage"), self.model.map, self.model.stage)
    self.config.gold:SetActive(false)
    self.config.exp:SetActive(false)
    self.config.gem:SetActive(false)

    --- @type VipData
    local vipData = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    local timeRewardMoney = ResourceMgr.GetCampaignDataConfig():GetTimeRewardMoney()
    local idleMoney = ResourceMgr.GetIdleRewardConfig():GetIdleMoney(self.model.stageId)
    for _, v in pairs(idleMoney:GetItems()) do
        ---@type IdleMoneyConfig
        local idleMoney = v
        if idleMoney.typeId == ResourceType.Money then
            if idleMoney.id == MoneyType.GOLD then
                self.config.gold:SetActive(true)
                self.config.textGold.text = string.format("+%s/%ss", idleMoney.number * (1 + vipData.campaignBonusGold), timeRewardMoney)
            elseif idleMoney.id == MoneyType.MAGIC_POTION then
                self.config.gem:SetActive(true)
                self.config.textGem.text = string.format("+%s/%ss", idleMoney.number * (1 + vipData.campaignBonusMagicPotion), timeRewardMoney)
            end
        else
            self.config.exp:SetActive(true)
            self.config.textExp.text = string.format("+%s/%ss", idleMoney.number * (1 + vipData.campaignBonusExpSummoners), timeRewardMoney)
        end
    end
    self.scrollView:SetData(self.model.resourceList)
    ---@param v IconView
    for _, v in pairs(self.scrollView:GetItems():GetItems()) do
        v:RegisterShowInfo()
    end
    self.config.emptyLoot:SetActive(self.model.resourceList:Count() == 0)
end

--- @return void
function UIStageSelectView:OnClickAutoBattle()
    PopupMgr.HidePopup(UIPopupName.UIStageSelect)
    if self.callbackAutoBattle ~= nil then
        self.callbackAutoBattle(self.model.stageId)
    end
end

--- @return void
function UIStageSelectView:OnClickBattle()
    PopupMgr.HidePopup(UIPopupName.UIStageSelect)
    local result = {}
    result.gameMode = GameMode.CAMPAIGN
    ---@type DefenderTeamData
    local dataStage = ResourceMgr.GetCampaignDataConfig():GetCampaignStageConfigById(self.model.stageId)
    local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
    result.battleTeamInfo = battleTeamInfo
    result.bgParams = zg.playerData:GetCampaignData().stageCurrent
    result.callbackPlayBattle = function(uiFormationTeamData, callback)
        ---@param battleResultInBound BattleResultInBound
        local callbackSuccess = function(battleResultInBound)
            if battleResultInBound.isWin == true then
                zg.playerData.rewardList = ResourceMgr.GetCampaignDataConfig():GetCampaignRewardById(self.model.stageId)
                PlayerDataRequest.Request(PlayerDataMethod.CAMPAIGN)
                zg.playerData:AddListRewardToInventory()
            else
                zg.playerData.rewardList = nil
            end
            if callback ~= nil then
                callback()
            end
        end
        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            if logicCode == LogicCode.CAMPAIGN_STAGE_INVALID then
                PlayerDataRequest.Request(PlayerDataMethod.CAMPAIGN)
            end
        end
        BattleFormationRequest.BattleRequest(OpCode.CAMPAIGN_CHALLENGE, uiFormationTeamData, zg.playerData:GetCampaignData().stageNext, callbackSuccess, onFailed)
    end
    PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end

--- @return void
function UIStageSelectView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self:Init(result)
end

--- @return void
function UIStageSelectView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return void
function UIStageSelectView:Hide()
    UIBaseView.Hide(self)
    self.scrollView:Hide()

    self:RemoveListenerTutorial()
    --self:PlayEffect()
end

--- @return void
function UIStageSelectView:PlayEffect()
    --EFFECT
    local time = 0.5
    self.particleGold.transform:SetAsLastSibling()
    self.particleGem.transform:SetAsLastSibling()
    self.particleGold:SetActive(false)
    self.particleGold.transform.position = self.config.posGoldStart.position
    self.particleGold:SetActive(true)
    self.particleGold.transform:DOMove(self.posGoldEnd.position, time)
    self.particleGem:SetActive(false)
    self.particleGem.transform.position = self.config.posGemStart.position
    self.particleGem:SetActive(true)
    self.particleGem.transform:DOMove(self.posGemEnd.position, time)
    self.particleGoldEnd.transform.position = self.posGoldEnd.position
    self.particleGemEnd.transform.position = self.posGemEnd.position
    Coroutine.start(function()
        coroutine.waitforseconds(time)
        self.particleGoldEnd.transform:SetAsLastSibling()
        self.particleGemEnd.transform:SetAsLastSibling()
        self.particleGoldEnd:SetActive(true)
        self.particleGemEnd:SetActive(true)
        coroutine.waitforseconds(2)
        self.particleGold:SetActive(false)
        self.particleGem:SetActive(false)
        self.particleGoldEnd:SetActive(false)
        self.particleGemEnd:SetActive(false)
    end)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIStageSelectView:ShowTutorial(tutorial, step)
    if step == TutorialStep.CLOSE_POPUP_REWARD then
        tutorial:ViewFocusCurrentTutorial(self.config.bgClose, 0.6)
    end
end