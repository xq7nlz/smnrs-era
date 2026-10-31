
--- @class UIHeroMenu2Model : UIBaseModel
UIHeroMenu2Model = Class(UIHeroMenu2Model, UIBaseModel)

--- @return void
function UIHeroMenu2Model:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIHeroMenu2, "hero_menu_2")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
	--- @type List --HeroResource[]
	self.heroSort = List()
	--- @type number
	self.index = 1
	---@type HeroResource
	self.heroResource = HeroResource.CreateInstance(nil, 30001, 4, 50)
	---@type function
	self.changeHero = nil
	---@type boolean
	self.canSortHero = false

	self.positionMouseDown = 0
	self.positionMouseUp = 0
end

