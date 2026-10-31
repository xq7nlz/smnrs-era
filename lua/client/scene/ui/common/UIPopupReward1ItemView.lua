--- @class UIPopupReward1ItemView : IconView
UIPopupReward1ItemView = Class(UIPopupReward1ItemView, IconView)

--- @return void
function UIPopupReward1ItemView:Ctor()
	IconView.Ctor(self)
end

--- @return void
function UIPopupReward1ItemView:SetPrefabName()
	self.prefabName = 'popup_reward_1_item'
	self.uiPoolType = UIPoolType.Reward1ItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIPopupReward1ItemView:SetConfig(transform)
	assert(transform)
	--- @type UIPopupReward1ItemConfig
	---@type UIPopupReward1ItemConfig
	self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData ItemIconData
function UIPopupReward1ItemView:SetIconData(iconData)
	self.config.itemRewardPannelEffect.gameObject:SetActive(false)
	self.config.itemRewardPannelEffect.gameObject:SetActive(true)
	self.config.transform.localPosition = U_Vector3.zero
	if iconData ~= nil then
		self:Init(iconData)
	end
	zg.audioMgr:PlaySfxUi(SfxUiType.CLAIM)
	self:PlayAnimShow()
end

--- @return void
function UIPopupReward1ItemView:OnFinishAnimation()
	self:CheckAndInitTutorial()
	Coroutine.start(function ()
		coroutine.waitforseconds(1)
		self:ReturnPool()
	end)
end

--- @return void
function UIPopupReward1ItemView:CheckAndInitTutorial()
	self:CheckTutorial()
	self:InitListenerTutorial()
end

--- @return void
function UIPopupReward1ItemView:InitListenerTutorial()
	self.listenerTutorial = RxMgr.tutorialFocus:Subscribe(RxMgr.CreateFunction(self, self.CheckTutorial))
end

--- @return void
function UIPopupReward1ItemView:RemoveListenerTutorial()
	if self.listenerTutorial ~= nil then
		self.listenerTutorial:Unsubscribe()
		self.listenerTutorial = nil
	end
end

--- @return void
function UIPopupReward1ItemView:Init(data)
	if data ~= nil then
		---@type ItemIconData
		local itemIconData = data
		if self.iconView == nil then
			self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
		end
		self.config.textItemName.text = LanguageUtils.GetStringResourceName(itemIconData.type, itemIconData.itemId, itemIconData)
		self.config.textItemType.text = LanguageUtils.GetStringResourceType(itemIconData.type, itemIconData.itemId)
		self.iconView:SetIconData(itemIconData)
	else
		XDebug.Error("UIPopupReward1ItemView")
	end
end

--- @return void
function UIPopupReward1ItemView:PlayAnimShow()
	self.config.itemRewardPannelEffect.localScale = U_Vector3(0, 1, 0)
	self:OnFinishAnimation()
	DOTweenUtils.DOScale(self.config.itemRewardPannelEffect, U_Vector3(1, 1, 1), 0.2)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIPopupReward1ItemView:ShowTutorial(tutorial, step)
	if step == TutorialStep.CLOSE_POPUP_REWARD then
		tutorial:ViewFocusCurrentTutorial(self.config.backGroundDark,0.6)
	end
end

--- @return void
function UIPopupReward1ItemView:CheckTutorial()
	if UIBaseView.IsActiveTutorial() and UIBaseView.tutorial.isWaitingFocusPosition == true then
		local step = UIBaseView.tutorial.currentTutorial.tutorialStepData.step
		self:ShowTutorial(UIBaseView.tutorial, step)
	end
end

--- @return void
function UIPopupReward1ItemView:ReturnPool()
	local hide = function ()
		IconView.ReturnPool(self)
		if self.iconView ~= nil then
			self.iconView:ReturnPool()
			self.iconView = nil
		end
		self:RemoveListenerTutorial()
	end
	DOTweenUtils.DOMove(self.config.transform , self.config.pos.position, 0.2, U_Ease.Linear, hide)
end

return UIPopupReward1ItemView