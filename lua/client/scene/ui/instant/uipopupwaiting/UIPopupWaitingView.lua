--- @class UIPopupWaitingView : UIBaseView
UIPopupWaitingView = Class(UIPopupWaitingView, UIBaseView)

--- @param model UIPopupWaitingModel
function UIPopupWaitingView:Ctor(model)
	UIBaseView.Ctor(self, model)

	--- @type UIPopupWaitingModel
	self.model = model
end

--- @return void
function UIPopupWaitingView:CheckLoadLocalize()
	--- do nothing
end

--- @return void
--- @param opCode OpCode
function UIPopupWaitingView:OnReadyShow(opCode)
	XDebug.Log("Waiting show " .. tostring(opCode))
	if self.countTimeCoroutine ~= nil then
		XDebug.Log("Waiting show already" .. tostring(opCode))
		return
	end

	self.model.canClosePopup = false
	self.countTimeCoroutine = Coroutine.start(function()
		coroutine.waitforseconds(self.model.timeCanClose)
		if self.model.canClosePopup == true then
			self:Hide()
		else
			self.model.canClosePopup = true
			coroutine.waitforseconds((self.model.timeAutoClose - self.model.timeCanClose))
			XDebug.Log("Hide popup waiting long time")
			PopupMgr.HidePopup(self.model.uiName)
			TouchUtils.CatchError()
			TouchUtils.Reset()
			zg.netDispatcherMgr:Reset()
			self:StopCoroutine()

			PopupUtils.ShowPopupDisconnect(DisconnectReason.NO_NETWORK_CONNECTION, function ()
				SceneMgr.RequestAndResetToMainArea()
			end)
		end
	end)
end

function UIPopupWaitingView:StopCoroutine()
	if self.countTimeCoroutine then
		Coroutine.stop(self.countTimeCoroutine)
		self.countTimeCoroutine = nil
	end
end

--- @return void
function UIPopupWaitingView:Hide()
	if self.countTimeCoroutine == nil then
		UIBaseView.Hide(self)
		return
	end

	if self.model.canClosePopup == true then
		self:StopCoroutine()
		UIBaseView.Hide(self)
	else
		self.model.canClosePopup = true
	end
end