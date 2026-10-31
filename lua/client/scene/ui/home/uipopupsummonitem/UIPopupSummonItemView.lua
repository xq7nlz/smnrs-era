---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupSummonItem.UIPopupSummonItemConfig"

--- @class UIPopupSummonItemView : UIBaseView
UIPopupSummonItemView = Class(UIPopupSummonItemView, UIBaseView)

--- @return void
--- @param model UIPopupSummonItemModel
--- @param ctrl UIPopupSummonItemCtrl
function UIPopupSummonItemView:Ctor(model, ctrl)
	---@type UIPopupSummonItemConfig
	self.config = nil
	---@type FragmentIconView
	self.itemView = nil
	---@type function
	self.callbackSummon = nil
	---@type InputNumberView
	self.inputView = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupSummonItemModel
	self.model = model
	--- @type UIPopupSummonItemCtrl
	self.ctrl = ctrl
end

--- @return void
function UIPopupSummonItemView:OnReadyCreate()
	---@type UIPopupSummonItemConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSummon.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickSummon()
	end)
end

--- @return void
function UIPopupSummonItemView:InitLocalization()
	local localizeSummon = LanguageUtils.LocalizeCommon("summon")
	self.config.localizeTitle.text = localizeSummon
	self.config.localizeSummon.text = localizeSummon
end

function UIPopupSummonItemView:OnReadyShow(result)
	self:Init(result)
end

--- @return void
function UIPopupSummonItemView:OnFinishAnimation()
	UIBaseView.OnFinishAnimation(self)
	self:CheckAndInitTutorial()
end

--- @return void
function UIPopupSummonItemView:Init(result)
	self.model:InitData(result.fragmentData)
	self.callbackSummon = result.callbackSummon
	if self.itemView == nil then
		self.itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.FragmentIconView, self.config.item)
	end
	if self.inputView == nil then
		self.inputView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.inputNumber)
		local changeInput = function(value)
			self:OnChangeInput(value)
		end
		self.inputView.onChangeInput = changeInput
	end
	self.inputView:SetData(self.model.maxSummon, math.min(1, self.model.maxSummon), self.model.maxSummon)
	self:OnChangeInput(self.model.maxSummon)
end

--- @return void
function UIPopupSummonItemView:Hide()
	UIBaseView.Hide(self)
	self.itemView:ReturnPool()
	self.itemView = nil
	self.inputView:ReturnPool()
	self.inputView = nil
	self:RemoveListenerTutorial()
end

--- @return void
function UIPopupSummonItemView:UpdateNumberSummon()
	self.itemView:SetIconData(FragmentIconData.CreateInstance(self.model.fragmentData.type, self.model.fragmentData.itemId, self.model.numberFragment, self.model.fragmentData.countFull))
end

--- @return void
function UIPopupSummonItemView:OnChangeInput(value)
	self.model.number = value
	self.model:UpdateData()
	self:UpdateNumberSummon()
end

--- @return void
function UIPopupSummonItemView:OnClickSummon()
	PopupMgr.HidePopup(UIPopupName.UIPopupSummonItem)
	if self.callbackSummon ~= nil then
		self.callbackSummon(self.model.number)
	end
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIPopupSummonItemView:ShowTutorial(tutorial, step)
	XDebug.Log(step)
	if step == TutorialStep.CLICK_SUMMON_HERO_FRAGMENT then
		XDebug.Log("CLICK_SUMMON_HERO_FRAGMENT")
		tutorial:ViewFocusCurrentTutorial(self.config.buttonSummon, U_Vector2(400, 200), nil, nil, TutorialHandType.CLICK)
	end
end