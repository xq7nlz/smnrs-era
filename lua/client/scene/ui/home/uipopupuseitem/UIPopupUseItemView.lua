---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupUseItem.UIPopupUseItemConfig"

--- @class UIPopupUseItemView : UIBaseView
UIPopupUseItemView = Class(UIPopupUseItemView, UIBaseView)

--- @return void
--- @param model UIPopupUseItemModel
function UIPopupUseItemView:Ctor(model)
	---@type UIPopupUseItemConfig
	self.config = nil
	---@type IconView
	self.itemView = nil
	---@type function
	self.callbackUse = nil
	---@type InputNumberView
	self.inputView = nil
	
	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupUseItemModel
	self.model = model
end

--- @return void
function UIPopupUseItemView:OnReadyCreate()
	---@type UIPopupUseItemConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSummon.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickUse()
	end)
end

function UIPopupUseItemView:OnReadyShow(result)
	self:Init(result)
end

--- @return void
function UIPopupUseItemView:OnFinishAnimation()
	UIBaseView.OnFinishAnimation(self)
	self:CheckAndInitTutorial()
end

--- @return void
---@param result PopupUseItemData
function UIPopupUseItemView:Init(result)
	self.callbackUse = result.callbackUse
	if self.itemView ~= nil then
		self.itemView:ReturnPool()
	end
	if result.createItem ~= nil then
		self.itemView = result.createItem(self.config.item)
	end
	if self.inputView == nil then
		self.inputView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.inputNumber)
		self.inputView.onChangeInput = result.changeInput
	end
	self.inputView:SetData(result.maxInput, result.minInput, result.maxInput)
	self.config.textItem.text = result.textItem or ""
	self.config.localizeSummon.text = result.textButton or ""
	self.config.localizeTitle.text = result.title or ""
end

--- @return void
function UIPopupUseItemView:Hide()
	UIBaseView.Hide(self)
	if self.itemView ~= nil then
		self.itemView:ReturnPool()
		self.itemView = nil
	end
	if self.inputView ~= nil then
		self.inputView:ReturnPool()
		self.inputView = nil
	end
	self:RemoveListenerTutorial()
end

--- @return void
function UIPopupUseItemView:OnClickUse()
	if self.callbackUse ~= nil then
		self.callbackUse(self.inputView.value)
	end
	PopupMgr.HidePopup(UIPopupName.UIPopupUseItem)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIPopupUseItemView:ShowTutorial(tutorial, step)
	if step == TutorialStep.CLICK_SUMMON_HERO_FRAGMENT then
		XDebug.Log("CLICK_SUMMON_HERO_FRAGMENT")
		tutorial:ViewFocusCurrentTutorial(self.config.buttonSummon, U_Vector2(400, 200), nil, nil, TutorialHandType.CLICK)
	end
end

