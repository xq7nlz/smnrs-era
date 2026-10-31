require("lua.client.scene.ui.home.uiFreeGemPopup.UIFreeGemOptionView")

--- @class UIFreeGemPopupView : UIBaseView
UIFreeGemPopupView = Class(UIFreeGemPopupView, UIBaseView)

--- @param model UIFreeGemPopupModel
function UIFreeGemPopupView:Ctor(model)
	--- @type UIFreeGemPopupConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UIFreeGemPopupModel
	self.model = model

	--- @type UIFreeGemOptionView
	self.view = nil
end

--- @return number
function UIFreeGemPopupView.GetWatchAdConfigID()
	local val = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.WatchAd)
	if (val == nil) then
		val = -1
	end
	local result = 2
	if (val > 0) then
		result = val
	end
	--XDebug.Log("Watch AD DataId before " .. tostring(val) .. " after " .. tostring(result))
	--print(">>>> Client Used Watch AD DataId after modify ", result)
	return math.floor(result)
end

function UIFreeGemPopupView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtons()
end

function UIFreeGemPopupView:InitButtons()
	self.config.close.onClick:RemoveAllListeners()
	self.config.close.onClick:AddListener(function()
		self:Hide()
	end)
end

function UIFreeGemPopupView:InitLocalization()

end

--- @param data {callbackClose : function}
function UIFreeGemPopupView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)

	--- @type number
	self.option = self:GetWatchAdConfigID()

	self.config.Opt1.gameObject:SetActive(false)
	self.config.Opt2.gameObject:SetActive(false)
	if self.option == 1 then
		self.view = UIFreeGemOptionView(self.config.Opt1)
	else
		self.view = UIFreeGemOptionView(self.config.Opt2)
	end

	self.view:Init()
end

--- @return void
function UIFreeGemPopupView:Hide()
	if self.model.type == UIPopupType.BLUR_POPUP then
		uiCanvas.config.blurCacher.rawImage.gameObject:SetActive(false)
	end
	if self.coroutineDelayTut ~= nil then
		Coroutine.stop(self.coroutineDelayTut)
		self.coroutineDelayTut = nil
	end
	self:SetActive(false)
	self:CheckRemoveUpdateTimeNextDay()
	if self.listenerChangeLanguage ~= nil then
		self.listenerChangeLanguage:Unsubscribe()
	end
	self.view:Hide()
end