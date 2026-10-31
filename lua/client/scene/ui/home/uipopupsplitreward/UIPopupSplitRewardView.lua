--- @class UIPopupSplitRewardView : UIBaseView
UIPopupSplitRewardView = Class(UIPopupSplitRewardView, UIBaseView)

--- @return void
--- @param model UIPopupManyManyRewardModel
function UIPopupSplitRewardView:Ctor(model, ctrl)
	--- @type UIPopupSplitRewardConfig
	self.config = nil
	--- @type ItemsTableView
	self.itemsTable = nil
	--- @type function
	self.callback = nil
	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupManyManyRewardModel
	self.model = self.model
end

--- @return void
function UIPopupSplitRewardView:OnReadyCreate()
	---@type UIPopupManyManyRewardConfig
	self.config = UIBaseConfig(self.uiTransform)
	SmartPool.Instance:SpawnUIEffectPool(EffectPoolType.PopupReward, self.config.fxUiPopup)

	self.config.background.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)

	self.itemsTable1 = ItemsTableView(self.config.content)
	self.itemsTable2 = ItemsTableView(self.config.content2)
end

--- @return void
function UIPopupSplitRewardView:InitLocalization()
	self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("congratulation")
	self.config.splitText.text = LanguageUtils.LocalizeCommon("complete_reward")
	self.config.localizeTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIPopupSplitRewardView:OnReadyShow(data)
	assert(data)
	self.itemsTable1:Show()
	self.itemsTable2:Show()
	self:UpdateView(data)
	zg.audioMgr:PlaySfxUi(SfxUiType.CLAIM)
end

--- @return void
function UIPopupSplitRewardView:OnFinishAnimation()
	UIBaseView.OnFinishAnimation(self)
	self:CheckAndInitTutorial()
end

--- @return void
function UIPopupSplitRewardView:Hide()
	UIBaseView.Hide(self)
	if self.callback ~= nil then
		self.callback()
		self.callback = nil
	end
	self.itemsTable1:Hide()
	self.itemsTable2:Hide()
	self:RemoveListenerTutorial()
end

--- @return void
function UIPopupSplitRewardView:UpdateView(data)
	self.model.resourceList1 = data.resourceList1
	self.model.resourceList2 = data.resourceList2
	if data.localize then
		self.config.splitText.text = LanguageUtils.LocalizeCommon(data.localize)
	end
	self.itemsTable1:SetData(self.model.resourceList1)
	self.itemsTable2:SetData(self.model.resourceList2)
	if data.activeEffectItem ~= nil then
		---@type List
		local listItem = self.itemsTable1:GetItems()
		---@param iconView IconView
		for _, iconView in pairs(listItem:GetItems()) do
			iconView:ActiveEffectItemIcon(data.activeEffectItem)
		end
		listItem = self.itemsTable2:GetItems()
		---@param iconView IconView
		for _, iconView in pairs(listItem:GetItems()) do
			iconView:ActiveEffectItemIcon(data.activeEffectItem)
		end
	end
	if data.activeEffectBlackSmith ~= nil then
		---@type List
		local listItem = self.itemsTable1:GetItems()
		---@param iconView IconView
		for _, iconView in pairs(listItem:GetItems()) do
			iconView:ActiveEffectVip2(data.activeEffectBlackSmith)
		end
		listItem = self.itemsTable2:GetItems()
		---@param iconView IconView
		for _, iconView in pairs(listItem:GetItems()) do
			iconView:ActiveEffectVip2(data.activeEffectBlackSmith)
		end
	end

	self.callback = data.callback

	local totalResource = self.model.resourceList1:Count()
	self.config.contentGrid.constraintCount = totalResource <= 9 and 9 or math.ceil(totalResource / 2)
	totalResource = self.model.resourceList2:Count()
	local spacing = totalResource <= 4 and 4 or math.ceil(totalResource / 2)
	self.config.contentGrid2.constraintCount = spacing
end

--- @return void
function UIPopupSplitRewardView:OnReadyHide()
	UIBaseView.OnReadyHide(self)
	self.config.splitText.text = LanguageUtils.LocalizeCommon("complete_reward")
	zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
end

function UIPopupSplitRewardView:OnClickBackOrClose()
	self:OnReadyHide()
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIPopupSplitRewardView:ShowTutorial(tutorial, step)
	if step == TutorialStep.CLOSE_POPUP_REWARD then
		tutorial:ViewFocusCurrentTutorial(self.config.background,0.6)
	end
end