require "lua.client.scene.ui.home.uiItemPreview.UIItemPreviewChildView"

--- @class UIItemPreviewView : UIBaseView
UIItemPreviewView = Class(UIItemPreviewView, UIBaseView)

--- @return void
--- @param model UIItemPreviewModel
function UIItemPreviewView:Ctor(model)
	---@type UIItemPreviewConfig
	self.config = nil
	---@type UIItemPreviewChildView
	self.previewChild1 = nil
	---@type UIItemPreviewChildView
	self.previewChild2 = nil
	---@type UIItemPreviewChildView
	self.previewChild3 = nil
	---@type UnityEngine_Vector3
	self.position = nil

	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIItemPreviewModel
	self.model = self.model
end

--- @return void
function UIItemPreviewView:OnReadyCreate()
	---@type UIItemPreviewConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.position = self.config.parentFitter.transform.position
	self.config.parentFitter.transform.position = U_Vector3(10000, 10000, 0)
	self.previewChild1 = UIItemPreviewChildView(self.config.view1)
	self.previewChild2 = UIItemPreviewChildView(self.config.view2)
	self.previewChild3 = UIItemPreviewChildView(self.config.view3)

	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

function UIItemPreviewView:InitLocalization()
end

--- @return void
function UIItemPreviewView:Init(result)


	Coroutine.start(function()
		coroutine.waitforendofframe()
		coroutine.waitforendofframe()
		self.config.horizontal.enabled = false
		self.config.horizontal.enabled = true
		coroutine.waitforendofframe()
		self.config.horizontal.enabled = false
		self.config.horizontal.enabled = true
		coroutine.waitforendofframe()
		if result.position ~= nil then
			self.config.parentFitter.transform.position = result.position
		else
			self.config.parentFitter.transform.position = self.position
		end
	end)
	if result.data1 == nil then
		if self.previewChild1 ~= nil then
			self.previewChild1.config.gameObject:SetActive(false)
		end
	else
		self.previewChild1.config.gameObject:SetActive(true)
		self.previewChild1:Show(result.data1,self)
	end
	if result.data2 == nil then
		if self.previewChild2 ~= nil then
			self.previewChild2.config.gameObject:SetActive(false)
		end
	else
		self.previewChild2.config.gameObject:SetActive(true)
		self.previewChild2:Show(result.data2)
	end
	if result.data3 == nil then
		if self.previewChild3 ~= nil then
			self.previewChild3.config.gameObject:SetActive(false)
		end
	else
		self.previewChild3.config.gameObject:SetActive(true)
		self.previewChild3:Show(result.data3)
	end
	self.config.softTut:SetActive(result.softTut ~= nil)
end

--- @return void
function UIItemPreviewView:OnReadyShow(result)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	if result ~= nil then
		self:Init(result)
	end
end

--- @return void
function UIItemPreviewView:OnFinishAnimation()
	UIBaseView.OnFinishAnimation(self)
	self:CheckAndInitTutorial()
end

--- @return void
function UIItemPreviewView:Hide()
	UIBaseView.Hide(self)
	self.config.parentFitter.transform.position = U_Vector3(10000, 10000, 0)
	if self.previewChild1 ~= nil then
		self.previewChild1:Hide()
	end
	if self.previewChild2 ~= nil then
		self.previewChild2:Hide()
	end
	if self.previewChild3 ~= nil then
		self.previewChild3:Hide()
	end

	self:RemoveListenerTutorial()
	self.config.softTut:SetActive(false)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIItemPreviewView:ShowTutorial(tutorial, step)
	if step == TutorialStep.CLICK_SUMMON_HERO_FRAGMENT then
		tutorial:ViewFocusCurrentTutorial(self.previewChild1.config.button2, U_Vector2(400, 200), nil, nil, TutorialHandType.CLICK)
	elseif step == TutorialStep.CLICK_SUMMON_ITEM then
		tutorial:ViewFocusCurrentTutorial(self.previewChild1.config.button2, U_Vector2(400, 200), nil, nil, TutorialHandType.CLICK)
	end
end