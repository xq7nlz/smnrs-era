--- @class UIUnlockFeatureView : UIBaseView
UIUnlockFeatureView = Class(UIUnlockFeatureView, UIBaseView)

--- @return void
--- @param model UIUnlockFeatureModel
function UIUnlockFeatureView:Ctor(model)
    ---@type UIUnlockFeatureConfig
    self.config = nil
    ---@type UnityEngine_GameObject
    self.currentFunction = nil
    --- @type boolean
    self.isAllowClose = false

    UIBaseView.Ctor(self, model)
    --- @type UIUnlockFeatureModel
    self.model = model
end

--- @return void
function UIUnlockFeatureView:OnReadyCreate()
    ---@type UIUnlockFeatureConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonBg.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIUnlockFeatureView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("unlock_new_function")
    self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIUnlockFeatureView:OnReadyShow(data)
    self.isAllowClose = false
	if data ~= nil then
		---@type FeatureType
		local feature = data.feature

		self.config.textNewFunctionContent.text = LanguageUtils.LocalizeFeatureContent(feature)
		if self.currentFunction ~= nil then
			self.currentFunction:SetActive(false)
			self.currentFunction = nil
		end
		local showFeatureType1 = function(isType1)
			local localizeFeature = LanguageUtils.LocalizeFeature(feature)
			if isType1 then
				self.config.textFeature1.text = localizeFeature
				if feature == FeatureType.EVOLVE_STAR_13 then
					self.config.iconNewFunction.gameObject:SetActive(false)
				else
					self.config.iconNewFunction.gameObject:SetActive(true)
					self.config.iconNewFunction.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFeature, feature)
					self.config.iconNewFunction:SetNativeSize()
				end
			else
				self.config.textFeature2.text = localizeFeature
			end
			self.config.feature1:SetActive(isType1)
			self.config.textFeature2.gameObject:SetActive(not isType1)
		end

		showFeatureType1(true)
		if feature == FeatureType.ARENA then
			self.currentFunction = self.config.iconArenaNewFunction
			showFeatureType1(true)
		elseif feature == FeatureType.PROPHET_TREE then
			self.currentFunction = self.config.iconAncientTreeNewFunction
			showFeatureType1(true)
		elseif feature == FeatureType.DUNGEON then
			self.currentFunction = self.config.iconDungeonNewFunction
			showFeatureType1(true)
		elseif feature == FeatureType.GUILD then
			self.currentFunction = self.config.iconGuildNewFunction
			showFeatureType1(true)
		elseif feature == FeatureType.RAID then
			self.currentFunction = self.config.iconRaidNewFunction
			showFeatureType1(true)
		elseif feature == FeatureType.SUMMON then
			self.currentFunction = self.config.iconSummonNewFunction
			showFeatureType1(true)
		elseif feature == FeatureType.TAVERN then
			self.currentFunction = self.config.iconTavernNewFunction
			showFeatureType1(true)
		elseif feature == FeatureType.TOWER then
			self.currentFunction = self.config.iconTowerNewFunction
			showFeatureType1(true)
		elseif feature == FeatureType.CASINO then
			self.currentFunction = self.config.iconWheelOfFateNewFunction
			showFeatureType1(true)
		elseif feature == FeatureType.MASTERY then
			self.currentFunction = self.config.iconMasteryMainMenu
			showFeatureType1(false)
		elseif feature == FeatureType.RAISE_LEVEL then
			self.currentFunction = self.config.iconRaiseMainMenu
			showFeatureType1(false)
		elseif feature == FeatureType.SUMMONER then
			self.currentFunction = self.config.iconSummonerMainMenu
			showFeatureType1(false)
		elseif feature == FeatureType.HAND_OF_MIDAS then
			self.currentFunction = self.config.iconHandOfMidas
		elseif feature == FeatureType.ARENA_TEAM then
			self.currentFunction = self.config.iconArenaNewFunction
		elseif feature == FeatureType.REGRESSION then
			self.currentFunction = self.config.iconRegression
			showFeatureType1(false)
		elseif feature == FeatureType.RECYCLE then
			self.currentFunction = self.config.iconRecycle
			showFeatureType1(false)
		elseif feature == FeatureType.DEFENSE then
			self.currentFunction = self.config.iconDefense
		elseif feature == FeatureType.DOMAINS then
			self.currentFunction = self.config.iconDomains
		else
			print("Missing feature icon ", feature)
		end
		if self.currentFunction ~= nil then
			self.currentFunction:SetActive(true)
		end
	end

    Coroutine.start(function()
        coroutine.waitforseconds(1)
        self.isAllowClose = true
    end)
end

function UIUnlockFeatureView:OnClickBackOrClose()
    if self.isAllowClose ~= true then
        return
    end
    UIBaseView.OnClickBackOrClose(self)
end