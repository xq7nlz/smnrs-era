require "lua.client.scene.ui.home.uiRaiseLevelHero.ResetRaiseHeroOutbound"

--- @class UIPopupResetCoolDownRaiseHeroView : UIBaseView
UIPopupResetCoolDownRaiseHeroView = Class(UIPopupResetCoolDownRaiseHeroView, UIBaseView)

--- @param model UiPopupUnbindingRaiseHeroModel
function UIPopupResetCoolDownRaiseHeroView:Ctor(model)
    ---@type UIPopupUnbindingRaiseLevelConfig
    self.config = nil
    UIBaseView.Ctor(self, model)
    ---@type PlayerRaiseLevelInbound
    self.raiseInbound = nil
end

function UIPopupResetCoolDownRaiseHeroView:OnReadyCreate()
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

function UIPopupResetCoolDownRaiseHeroView:InitLocalization()
    self.config.textCancel.text = LanguageUtils.LocalizeCommon("cancel")
    self.config.textGreen.text = LanguageUtils.LocalizeCommon("confirm")
    self.config.describeText1.text = LanguageUtils.LocalizeCommon("do_you_want_to")
    self.config.describeText2.text = LanguageUtils.LocalizeCommon("reset_this_slot")
end

--- @return void
function UIPopupResetCoolDownRaiseHeroView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.raiseInbound = zg.playerData:GetRaiseLevelHero()
    if result ~= nil then
        self.index = result.index
        self.resetEffect = result.resetEffect
        self:UpdatePrice()
    end
end

--- @return void
function UIPopupResetCoolDownRaiseHeroView:Hide()
    UIBaseView.Hide(self)
end
--- @return void
---
function UIPopupResetCoolDownRaiseHeroView:UpdatePrice()
    self.slotConfig = ResourceMgr.GetRaiseHeroConfig():GetSlotConfig()
    self.config.priceText.text = self.slotConfig.rewardInbound.number
    self.config.iconCurrency.sprite = ResourceLoadUtils.LoadMoneyIcon(self.slotConfig.rewardInbound.id)
end

function UIPopupResetCoolDownRaiseHeroView:OnConfirm()
    local success = function()
        self.raiseInbound:BuyRaisedSlot(self.index)
        InventoryUtils.SubSingleRewardInBound(self.slotConfig.rewardInbound)
        PopupMgr.ShowAndHidePopup(UIPopupName.UIRaiseLevelHero, { ["show"] = false }, UIPopupName.UIPopupResetCoolDownRaiseHero)
        if self.resetEffect ~= nil then
            self.resetEffect()
        end
    end
    local failed = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_unbind"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
    local canConfirm = InventoryUtils.IsEnoughSingleResourceRequirement(self.slotConfig.rewardInbound)
    if canConfirm then
        local outbound = ResetRaiseHeroOutbound()
        outbound.resetList:Add(self.index)
        NetworkUtils.RequestAndCallback(OpCode.RAISE_HERO_RESET_COUNTDOWN_SLOT, outbound, success, failed)
    end
end