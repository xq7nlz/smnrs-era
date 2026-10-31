require "lua.client.scene.ui.home.uiCompanionCollection.UICompanionBuffView"

--- @class UICompanionCollectionView : UIBaseView
UICompanionCollectionView = Class(UICompanionCollectionView, UIBaseView)

--- @return void
--- @param model UICompanionCollectionModel
function UICompanionCollectionView:Ctor(model)
	---@type UICompanionCollectionConfig
	self.config = nil
	---@type List
	self.listCompanionBuffView = List()
	---@type List
	self.companionList = nil
	---@type number
	self.companionId = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UICompanionCollectionModel
	self.model = model
end

--- @return void
function UICompanionCollectionView:OnReadyCreate()
	---@type UICompanionCollectionConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)

	for i = 0, self.config.companion.childCount - 1 do
		self.listCompanionBuffView:Add(UICompanionBuffView(self.config.companion:GetChild(i)))
	end
end

--- @return void
function UICompanionCollectionView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("companion_buff")
end

--- @return void
function UICompanionCollectionView:OnReadyShow(result)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	if result ~= nil then
		self.companionId = result.companionId
	else
		self.companionId = nil
	end

	if self.companionList == nil then
		self.companionList = List()
		for i, v in pairs(ResourceMgr.GetServiceConfig():GetHeroes().heroCompanionBuffEntries:GetItems()) do
			self.companionList:Add(v)
		end
		self.companionList:SortWithMethod(SortUtils.SortCompanionBuff)
	end

	---@param v UICompanionBuffView
	for i, v in ipairs(self.listCompanionBuffView:GetItems()) do
		local chose
		---@type HeroCompanionBuffData
		local companionData = self.companionList:Get(i)
		if companionData.id == self.companionId then
			chose = true
		end
		v:SetData(companionData, chose)
	end
end

--- @return void
function UICompanionCollectionView:CheckCallbackAnimation()
	if self.animationCallback == nil then
		self:OnFinishAnimation()
	end
end