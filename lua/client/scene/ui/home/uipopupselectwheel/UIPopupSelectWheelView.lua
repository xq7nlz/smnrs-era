---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupSelectWheel.UIPopupSelectWheelConfig"

--- @class UIPopupSelectWheelView : UIBaseView
UIPopupSelectWheelView = Class(UIPopupSelectWheelView, UIBaseView)

--- @return void
--- @param model UIPopupSelectWheelModel
function UIPopupSelectWheelView:Ctor(model)
	---@type UIPopupSelectWheelConfig
	self.config = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIPopupSelectWheelModel
	self.model = model
end

function UIPopupSelectWheelView:OnReadyCreate()
	---@type UIPopupSelectWheelConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBasic.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickBasic()
	end)
	self.config.buttonPremium.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickPremium()
	end)

end

--- @return void
function UIPopupSelectWheelView:RequireVipOrLevelAndStageCasinoPremium()
	local levelRequire, stageRequire = ClientConfigUtils.GetLevelStageRequire(MinorFeatureType.CASINO_PREMIUM_SPIN)
	local vipUnlock = ResourceMgr.GetVipConfig():RequireLevelUnlockCasinoPremium()
	return vipUnlock, levelRequire, stageRequire
end

--- @return void
function UIPopupSelectWheelView:InitLocalization()
	self.config.localizeBasicCasino.text = LanguageUtils.LocalizeCasinoType(CasinoType.Basic)
	self.config.localizePremiumCasino.text = LanguageUtils.LocalizeCasinoType(CasinoType.Premium)
	self.config.textTapToClose.gameObject:SetActive(false)
	local vipUnlock, levelRequire, stageRequire = self:RequireVipOrLevelAndStageCasinoPremium()
	self.config.textDestinyUnlock.text = LanguageUtils.NotificationRequireVipOrLevelAndStage(vipUnlock, levelRequire, stageRequire)
end

--- @return void
function UIPopupSelectWheelView:OnReadyShow()
	if zg.playerData:GetMethod(PlayerDataMethod.CASINO) == nil then
		PlayerDataRequest.RequestAndCallback({PlayerDataMethod.CASINO })
	end
	local vipUnlock, levelRequire, stageRequire = self:RequireVipOrLevelAndStageCasinoPremium()
	local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
	local enablePremiumSpin = vip.casinoUnlockPremiumSpin == true or (levelRequire == nil and stageRequire == nil)

	self.config.textDestinyUnlock.gameObject:SetActive(not enablePremiumSpin)
	self.config.bgTextDestiny:SetActive(enablePremiumSpin)
	UIUtils.SetInteractableButton(self.config.buttonPremium, enablePremiumSpin)
	self.config.iconDestinyWheel.color = enablePremiumSpin and U_Color.white or U_Color(0.3, 0.3, 0.3, 1)
end

--- @return void
function UIPopupSelectWheelView:OnClickBasic()
	if zg.playerData:GetMethod(PlayerDataMethod.CASINO) ~= nil then
		PopupMgr.HidePopup(UIPopupName.UIMainArea)
		PopupMgr.HidePopup(UIPopupName.UIPopupSelectWheel)
		PopupMgr.ShowPopup(UIPopupName.UIWheelOfFate, { ["casinoType"] = CasinoType.Basic })
	end
end

--- @return void
function UIPopupSelectWheelView:OnClickPremium()
	local vipUnlock, levelRequire, stageRequire = self:RequireVipOrLevelAndStageCasinoPremium()
	local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
	if vip.casinoUnlockPremiumSpin == true or (levelRequire == nil and stageRequire == nil) then
		if zg.playerData:GetMethod(PlayerDataMethod.CASINO) ~= nil then
			PopupMgr.HidePopup(UIPopupName.UIMainArea)
			PopupMgr.HidePopup(UIPopupName.UIPopupSelectWheel)
			PopupMgr.ShowPopup(UIPopupName.UIWheelOfFate, { ["casinoType"] = CasinoType.Premium })
		end
	else
		SmartPoolUtils.NotificationRequireVipOrLevelAndStage(vipUnlock, levelRequire, stageRequire)
	end
end

--- @return void
function UIPopupSelectWheelView:OnReadyHide()
	UIBaseView.OnReadyHide(self)
end