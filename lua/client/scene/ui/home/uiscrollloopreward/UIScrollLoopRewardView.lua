---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiScrollLoopReward.UIScrollLoopRewardConfig"

--- @class UIScrollLoopRewardView : UIBaseView
UIScrollLoopRewardView = Class(UIScrollLoopRewardView, UIBaseView)

--- @return void
--- @param model UIScrollLoopRewardModel
function UIScrollLoopRewardView:Ctor(model)
	---@type UIScrollLoopRewardConfig
	self.config = nil
	--- @type UILoopScroll
	self.uiScroll = nil
	--- @type function
	self.yesCallback = nil
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIScrollLoopRewardModel
	self.model = model
	self.defaultTitleText = "congratulation"
	self.curTitleText =  "congratulation"
end

--- @return void
function UIScrollLoopRewardView:OnReadyCreate()
	---@type UIScrollLoopRewardConfig
	self.config = UIBaseConfig(self.uiTransform)

	--- @param obj IconView
	--- @param index number
	local onCreateItem = function(obj, index)
		local data = self.model.resourceList:Get(index + 1)
		--XDebug.Log(LogUtils.ToDetail(data))
        obj:EnableButton(true)
        obj:RegisterShowInfo()
        obj:RemoveAllListeners()

		obj:SetIconData(data)
	end

	self.uiScroll = UILoopScroll(self.config.loopScrollRect, UIPoolType.RootIconView, onCreateItem)
	self.uiScroll:Resize(self.model.resourceList:Count())

    self:_InitButtonListener()
end

--- @return void
function UIScrollLoopRewardView:InitLocalization()
	XDebug.Log("SET LOCALIZE")
	self.config.titleText.text = LanguageUtils.LocalizeCommon(self.curTitleText)
	self.config.textButton.text = LanguageUtils.LocalizeCommon("claim")
	self.config.textNo.text = LanguageUtils.LocalizeCommon("no")
	self.config.textYes.text = LanguageUtils.LocalizeCommon("yes")
end

--- @return void
function UIScrollLoopRewardView:_InitButtonListener()
    self.config.buttonClaim.onClick:AddListener(function ()
        self:OnClickBackOrClose()
	end)
    self.config.buttonClose.onClick:AddListener(function ()
        self:OnClickBackOrClose()
	end)
    self.config.bgFog.onClick:AddListener(function ()
        self:OnClickBackOrClose()
	end)
	self.config.buttonNo.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonYes.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		if self.yesCallback ~= nil then
			self.yesCallback()
		end
	end)
end

function UIScrollLoopRewardView:OnClickBackOrClose()
	self:OnReadyHide()
	zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
end

--- @return void
function UIScrollLoopRewardView:OnReadyShow(result)
	if result ~= nil then
		self:_Init(result)
	end
end

--- @return void
function UIScrollLoopRewardView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

--- @return void
function UIScrollLoopRewardView:_Init(result)
	self.model.resourceList = result.resourceList
	self.model.textButton = result.textButton
	if (result.titleText ~= nil) then
		self.curTitleText = result.titleText
		else
		self.curTitleText = self.defaultTitleText
	end
	self:InitLocalization()
	if self.model.textButton == nil then
		self.model.textButton = LanguageUtils.LocalizeCommon("claim")
	end
	if result.yesCallback ~= nil then
		self.config.buttonClaim.gameObject:SetActive(false)
		self.config.yesNo:SetActive(true)
		self.yesCallback = result.yesCallback
	else
		self.config.buttonClaim.gameObject:SetActive(true)
		self.config.yesNo:SetActive(false)
	end

	self.uiScroll:Resize(self.model.resourceList:Count())
	self:_SetButton()
end

--- @return void
function UIScrollLoopRewardView:_SetButton()
	self.config.textButton.text = self.model.textButton
end