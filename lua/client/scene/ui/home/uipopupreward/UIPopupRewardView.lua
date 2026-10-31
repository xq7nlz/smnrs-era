--- @class UIPopupRewardView : UIBaseView
UIPopupRewardView = Class(UIPopupRewardView, UIBaseView)

--- @return void
--- @param model UIPopupRewardModel
function UIPopupRewardView:Ctor(model, ctrl)
	--- @type UIPopupRewardConfig
	self.config = nil
	--- @type ItemsTableView
	self.itemsTable = nil
	--- @type function
	self.callback = nil
	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupRewardModel
	self.model = self.model
end

--- @return void
function UIPopupRewardView:OnReadyCreate()
	---@type UIPopupRewardConfig
	self.config = UIBaseConfig(self.uiTransform)
	SmartPool.Instance:SpawnUIEffectPool(EffectPoolType.PopupReward, self.config.fxUiPopup)

	self.config.background.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)

	self.itemsTable = ItemsTableView(self.config.content)
end

--- @return void
function UIPopupRewardView:InitLocalization()
	self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("congratulation")
	self.config.localizeTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIPopupRewardView:OnReadyShow(data)
	assert(data)
	self.itemsTable:Show()
	self:UpdateView(data)
	zg.audioMgr:PlaySfxUi(SfxUiType.CLAIM)
end

--- @return void
function UIPopupRewardView:OnFinishAnimation()
	UIBaseView.OnFinishAnimation(self)
	self:CheckAndInitTutorial()
end

--- @return void
function UIPopupRewardView:Hide()
	UIBaseView.Hide(self)
	if self.callback ~= nil then
		self.callback()
		self.callback = nil
	end
	self.itemsTable:Hide()
	self:RemoveListenerTutorial()
end

--- @return void
function UIPopupRewardView:UpdateView(data)
	self.model.resourceList = data.resourceList
	self.itemsTable:SetData(self.model.resourceList)
	if data.activeEffectItem ~= nil then
		---@type List
		local listItem = self.itemsTable:GetItems()
		---@param iconView IconView
		for _, iconView in pairs(listItem:GetItems()) do
			iconView:ActiveEffectItemIcon(data.activeEffectItem)
		end
	end
	if data.activeEffectBlackSmith ~= nil then
		---@type List
		local listItem = self.itemsTable:GetItems()
		---@param iconView IconView
		for _, iconView in pairs(listItem:GetItems()) do
			iconView:ActiveEffectVip2(data.activeEffectBlackSmith)
		end
	end

	self.callback = data.callback

	local totalResource = self.model.resourceList:Count()
	self.config.contentGrid.constraintCount = totalResource <= 7 and totalResource or 7
end

--- @return void
function UIPopupRewardView:OnReadyHide()
	UIBaseView.OnReadyHide(self)
	zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
end

function UIPopupRewardView:OnClickBackOrClose()
	self:OnReadyHide()
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIPopupRewardView:ShowTutorial(tutorial, step)
	if step == TutorialStep.CLOSE_POPUP_REWARD then
		tutorial:ViewFocusCurrentTutorial(self.config.background,0.6)
	end
end