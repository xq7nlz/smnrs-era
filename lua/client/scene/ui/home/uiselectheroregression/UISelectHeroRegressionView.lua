
--- @class UISelectHeroRegressionView : UIBaseView
UISelectHeroRegressionView = Class(UISelectHeroRegressionView, UIBaseView)

--- @param model UISelectHeroRegressionModel
function UISelectHeroRegressionView:Ctor(model)
	---@type HeroListView
	self.heroList = nil
	--- @type UISelectHeroRegressionConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UISelectHeroRegressionModel
	self.model = model
end

function UISelectHeroRegressionView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	---@type RegressionConfig
	self.regressionConfig = ResourceMgr.GetRegressionConfig()
	self:InitScroll()
	self:InitButtons()
end

function UISelectHeroRegressionView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("hero_list")
	self.config.textGreen.text = LanguageUtils.LocalizeCommon("select")
end

function UISelectHeroRegressionView:OnReadyShow(result)
	if result ~= nil then
		self.dataList = result.dataList
		self.selectCallback = result.selectCallback
		self.selectedId = result.heroInventoryId
	end

	self:ShowHeroList()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	--self.uiScroll:PlayMotion()
end

function UISelectHeroRegressionView:InitButtons()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSelect.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickSelect()
	end)
end

function UISelectHeroRegressionView:OnClickBackOrClose()
	if NotificationCheckUtils.IsCanShowSoftTutRegression() then
		---@param heroResource HeroResource
		for index, heroResource in ipairs(InventoryUtils.Get(ResourceType.Hero):GetItems()) do
			if ClientConfigUtils.CheckLockHero(heroResource) == false and heroResource.heroStar >= self.regressionConfig:GetMinStar() then
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("you_need_select_hero"))
				return
			end
		end
	end
	UIBaseView.OnClickBackOrClose(self)
end

function UISelectHeroRegressionView:InitScroll()
	self.heroList = HeroListView(self.config.heroList)

	---- Scroll Hero
	--- @param buttonHero HeroIconView
	local onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
		if heroResource.inventoryId == self.selectedId then
			buttonHero:ActiveMaskSelect(true)
		else
			buttonHero:ActiveMaskSelect(false)
		end
		if ClientConfigUtils.CheckLockHero(heroResource) then
			buttonHero:ActiveMaskLock(true, UIUtils.sizeItem)
		else
			buttonHero:ActiveMaskLock(false)
		end
	end

	--- @return void
	--- @param heroIndex number
	--- @param buttonHero HeroIconView
	--- @param heroResource HeroResource
	local buttonListener = function(heroIndex, buttonHero, heroResource)
		local noti = ClientConfigUtils.GetNotiLockHero(heroResource)
		if noti ~= nil then
			SmartPoolUtils.ShowShortNotification(noti)
		else
			self:SelectHero(heroResource.inventoryId, buttonHero)
		end
	end

	--- @return boolean
	--- @param heroIndex number
	---@param heroResource HeroResource
	local filterConditionAnd = function(heroIndex, heroResource)
		return heroResource.heroStar >= self.regressionConfig:GetMinStar()
	end

	self.heroList:Init(buttonListener, nil, filterConditionAnd, nil, nil, onUpdateIconHero, onUpdateIconHero)
end

--- @return void
function UISelectHeroRegressionView:OnFinishAnimation()
	UIBaseView.OnFinishAnimation(self)
	if NotificationCheckUtils.IsCanShowSoftTutRegression() then
		local canSelectHero = false
		---@param heroResource HeroResource
		for index, heroResource in ipairs(InventoryUtils.Get(ResourceType.Hero):GetItems()) do
			if ClientConfigUtils.CheckLockHero(heroResource) == false and heroResource.heroStar >= self.regressionConfig:GetMinStar() then
				canSelectHero = true
				break
			end
		end
		if canSelectHero == false then
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_in_other_feature"))
		end
	end
end

function UISelectHeroRegressionView:ShowHeroList()
	self.listHero = InventoryUtils.Get(ResourceType.Hero)
	self.heroList:SetData(self.listHero)
end

--- @param obj HeroRaisePickIconView
--- @return void
function UISelectHeroRegressionView:SelectHero(inventoryId, obj)
	if self.selectedId == nil or self.selectedId ~= inventoryId then
		self.selectedId = inventoryId
		--self.uiScroll:RefreshCells()
		self.heroList.uiScroll:RefreshCells()
		obj:ActiveMaskSelect(true)
	end
end

--- @return void
function UISelectHeroRegressionView:OnClickSelect()
	if self.selectedId ~= nil then
		self.selectCallback(self.selectedId)
		PopupMgr.HidePopup(UIPopupName.UISelectHeroRegression)
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_to_select"))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	end
end

--- @return void
function UISelectHeroRegressionView:Hide()
	UIBaseView.Hide(self)
	--self.uiScroll:Hide()
	self.selectedId = nil
	self.heroList:ReturnPool()
end
