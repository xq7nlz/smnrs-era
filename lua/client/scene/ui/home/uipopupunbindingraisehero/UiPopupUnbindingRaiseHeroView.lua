require "lua.client.scene.ui.home.uiRaiseLevelHero.UnbindingRaiseHeroOutbound"
--- @class UiPopupUnbindingRaiseHeroView : UIBaseView
UiPopupUnbindingRaiseHeroView = Class(UiPopupUnbindingRaiseHeroView, UIBaseView)

--- @return void
--- @param model UiPopupUnbindingRaiseHeroModel
function UiPopupUnbindingRaiseHeroView:Ctor(model)
    ---@type UIPopupUnbindingRaiseLevelConfig
    self.config = nil
    UIBaseView.Ctor(self, model)
    ---@type PlayerRaiseLevelInbound
    self.raiseInbound = nil
end
--- @return void
function UiPopupUnbindingRaiseHeroView:OnReadyCreate()
    ---@type UIPopupEnhanceConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.background.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.closeButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.confirmButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnConfirm()
    end)
end

--- @return void
function UiPopupUnbindingRaiseHeroView:InitLocalization()
    self.config.cancelText.text = LanguageUtils.LocalizeCommon("cancel")
    self.config.greenText.text = LanguageUtils.LocalizeCommon("confirm")
    self.config.revertText.text = LanguageUtils.LocalizeCommon("revert_to")
    self.config.congratulationText.text = LanguageUtils.LocalizeCommon("notification")
    self.config.describeText.text = string.format("%s %s", LanguageUtils.LocalizeCommon("describe_unbinding_raise_level"), tostring(UIUtils.SetColorString(UIUtils.color6, "24:00:00")))
end

--- @return void
function UiPopupUnbindingRaiseHeroView:OnReadyShow(result)
    self.raiseInbound = zg.playerData:GetRaiseLevelHero()
    if result ~= nil then
        self.index = result.index
        self.inventoryId = result.inventoryId
        self.resetEffect = result.resetEffect
        self.originLevel = self.raiseInbound:GetRaisedSlot(self.index).originLevel
        self:UpdateUIHero(result)
    end
end

--- @return void
function UiPopupUnbindingRaiseHeroView:Hide()
    UIBaseView.Hide(self)
    if self.hero1 ~= nil then
        self.hero1:ReturnPool()
        self.hero1 = nil
    end
    if self.hero2 ~= nil then
        self.hero2:ReturnPool()
        self.hero2 = nil
    end
end

--- @return void
function UiPopupUnbindingRaiseHeroView:UpdateUIHero(result)
    ---@type HeroResource
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(result.inventoryId)
    local heroIconData1 = HeroIconData.CreateByHeroResource(heroResource)
    if self.hero1 == nil then
        self.hero1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.hero1)
    end
    if self.hero2 == nil then
        self.hero2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.hero2)
    end
    self.config.levelText1.text = string.format("%s %s", LanguageUtils.LocalizeCommon("level"), self.raiseInbound.pentaGram:GetLowestHero())
    self.config.levelText2.text = string.format("%s %s", LanguageUtils.LocalizeCommon("level"), self.originLevel)
    self.hero1:SetIconData(heroIconData1)
    self.hero2:SetIconData(heroIconData1)
    self.hero1.config.txtLv.gameObject:SetActive(false)
    self.hero2.config.txtLv.gameObject:SetActive(false)
end

function UiPopupUnbindingRaiseHeroView:OnConfirm()
    local success = function()
        self.raiseInbound:RemoveRaisedSlot(self.index, self.inventoryId)

        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(self.inventoryId)
        heroResource.heroLevel = self.originLevel
        PopupMgr.ShowAndHidePopup(UIPopupName.UIRaiseLevelHero, { ["show"] = false }, UIPopupName.UIPopupUnbindingRaiseHero)
        if self.resetEffect ~= nil then
            self.resetEffect()
        end
    end
    local failed = function(logicCode)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeLogicCode(logicCode))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
    local outbound = UnbindingRaiseHeroOutbound()
    outbound.slotList:Add(self.index)
    NetworkUtils.RequestAndCallback(OpCode.RAISE_HERO_UNBIND_RAISED_HEROES, outbound, success, failed)
end