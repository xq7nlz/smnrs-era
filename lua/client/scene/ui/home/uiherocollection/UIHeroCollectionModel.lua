
--- @class UIHeroCollectionModel : UIBaseModel
UIHeroCollectionModel = Class(UIHeroCollectionModel, UIBaseModel)

--- @return void
function UIHeroCollectionModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIHeroCollection, "hero_collection")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP
	---@type HeroList
	self.heroList = nil
	---@type List --HeroResource[]
	self.heroCollection = List()
	--- @type List --<HeroResource>
	self.heroSort = List()
	--- @type List --<BaseLinking>
	self.linkingSort = List()

	self.bgDark = false
end

--- @return void
function UIHeroCollectionModel:InitData()
	self.heroList = InventoryUtils.Get(ResourceType.Hero)
	self.heroCollection = List()
	for i, v in pairs(ResourceMgr.GetHeroMenuConfig().listHeroCollection:GetItems()) do
		if v > 1000 then
			---@type number
			local heroStar = ResourceMgr.GetHeroMenuConfig():GetDictHeroBaseStar(v)


			---@type HeroLevelCapConfig
			local heroLevelCap1 = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(heroStar)
			if heroLevelCap1 ~= nil then
				self.heroCollection:Add(HeroResource.CreateInstance(nil, v, heroStar, heroLevelCap1.levelCap))
			else
				XDebug.Log(string.format("heroId: %s, heroStar: %s", v, heroStar))
				self.heroCollection:Add(HeroResource.CreateInstance(nil, v, 1, 1))
			end
		end
	end
end

