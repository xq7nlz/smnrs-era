---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiMailPreview.UIMailPreviewConfig"

--- @class UIMailPreviewView : UIBaseView
UIMailPreviewView = Class(UIMailPreviewView, UIBaseView)

--- @return void
--- @param model UIMailPreviewModel
function UIMailPreviewView:Ctor(model)
	---@type UIMailPreviewConfig
	self.config = nil
	---@type UILoopScroll
	self.uiScroll = nil
	---@type MailData
	self.currentMail = nil

	self.callbackClaim = nil
	self.callbackDelete = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIMailPreviewModel
	self.model = model
end

--- @return void
function UIMailPreviewView:OnReadyCreate()
	---@type UIMailPreviewConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonClaim.onClick:AddListener(function ()
		self:OnClickClaim()
		zg.audioMgr:PlaySfxUi(SfxUiType.CLAIM)
	end)
	self.config.buttonReply.onClick:AddListener(function ()
		self:OnClickReply()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
	self.config.buttonDelete.onClick:AddListener(function ()
		self:OnClickDelete()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)

	--- @param obj RootIconView
	--- @param index number
	local onUpdateItem = function(obj, index)
		---@type RewardInBound
		local reward = self.currentMail.listReward:Get(index + 1)
		obj:SetIconData(reward:GetIconData())
		obj:SetActiveColor(self.currentMail.mailState ~= MailState.REWARD_RECEIVED)
	end
	--- @param obj RootIconView
	--- @param index number
	local onCreateItem = function(obj, index)
		onUpdateItem(obj, index)
		obj:RegisterShowInfo()
	end
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem, onUpdateItem)
end

--- @return void
function UIMailPreviewView:InitLocalization()
	self.config.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
	self.config.localizeDelete.text = LanguageUtils.LocalizeCommon("delete")
	self.config.localizeReply.text = LanguageUtils.LocalizeCommon("reply")
	self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIMailPreviewView:OnReadyShow(result)
	if result ~= nil then
		self:_Init(result)
	end
end

--- @return void
--- @param result {currentMail:MailData, callbackClaim, callbackDelete, tittle : string}
function UIMailPreviewView:_Init(result)
	self.currentMail = result.currentMail
	self.callbackDelete = result.callbackDelete
	self.callbackClaim = result.callbackClaim
	self.canDelete = result.canDelete

	self:ShowMail()
end

--- @return void
function UIMailPreviewView:ShowMail()
	self.config.textTitle.text = self.currentMail:GetSubject()
	self.config.textContent.text = "\n" .. self.currentMail:GetContent()
	if self.currentMail:IsPlayerMail() then
		self.config.buttonReply.gameObject:SetActive(true)
	else
		self.config.buttonReply.gameObject:SetActive(false)
	end
	self.config.textFrom.text = self.currentMail:GetLocalizeSender()
	if self.currentMail:CanDelete() then
		self.config.buttonDelete.gameObject:SetActive(true)
		self.config.buttonClaim.gameObject:SetActive(false)
	else
		self.config.buttonDelete.gameObject:SetActive(false)
		self.config.buttonClaim.gameObject:SetActive(true)
	end

	if self.canDelete == false then
		UIUtils.SetInteractableButton(self.config.buttonDelete, false)
	else
		UIUtils.SetInteractableButton(self.config.buttonDelete, true)
	end

	if self.currentMail.listReward == nil or self.currentMail.listReward:Count() == 0 then
		self.config.rectScrollContent.sizeDelta = U_Vector2(self.config.rectScrollContent.sizeDelta.x, 330)
		self.config.reward:SetActive(false)
	else
		self.config.rectScrollContent.sizeDelta = U_Vector2(self.config.rectScrollContent.sizeDelta.x, 190)
		self.config.reward:SetActive(true)
	end

	if(self.currentMail.listReward:Count() < 5) then
		self.config.content.constraintCount = self.currentMail.listReward:Count()
		Coroutine.start(function ()
			self.uiScroll.scroll.enabled = true
			self.uiScroll:Resize(self.currentMail.listReward:Count())
			coroutine.waitforendofframe()
			coroutine.waitforendofframe()
			self.uiScroll.scroll.enabled = false
		end)
	else
		self.config.content.constraintCount = 5
		self.uiScroll.scroll.enabled = true
		self.uiScroll:Resize(self.currentMail.listReward:Count())
	end
end

--- @return void
function UIMailPreviewView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

--- @return void
function UIMailPreviewView:OnClickClaim()
	local callbackSuccess = function()
		---@type List
		local listResource = List()
		---@param v RewardInBound
		for _, v in pairs(self.currentMail.listReward:GetItems()) do
			v:AddToInventory()
			listResource:Add(v:GetIconData())
		end
		self.currentMail.mailState = MailState.REWARD_RECEIVED
		if self.callbackClaim ~= nil then
			self.callbackClaim(self.currentMail)
		end
		self:ShowMail()
		if listResource:Count() > 0 then
			PopupUtils.ShowRewardList(listResource)
		end
	end
	local callbackFailed = function()

	end
	NetworkUtils.RequestAndCallback(OpCode.MAIL_REWARD_CLAIM, MailActionOutBound(false, self.currentMail:IsPlayerMail(), self.currentMail.mailId), callbackSuccess, callbackFailed)
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
end

--- @return void
function UIMailPreviewView:OnClickReply()
	PopupMgr.ShowPopup(UIPopupName.UIFriendMail, {["id"] = self.currentMail.senderPlayerId})
end

--- @return void
function UIMailPreviewView:OnClickDelete()
	PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("do_want_delete_mail"), nil, function()
		local callbackSuccess = function()
			if self.callbackDelete ~= nil then
				self.callbackDelete(self.currentMail)
			end
			self:OnReadyHide()
		end
		local callbackFailed = function()

		end
		NetworkUtils.RequestAndCallback( OpCode.MAIL_DELETE, MailActionOutBound(false, self.currentMail:IsPlayerMail(), self.currentMail.mailId), callbackSuccess, callbackFailed)
	end)
end