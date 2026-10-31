
--- @class UITempleReplaceCtrl : UIBaseCtrl
UITempleReplaceCtrl = Class(UITempleReplaceCtrl, UIBaseCtrl)

--- @return void
--- @param model UITempleReplaceModel
function UITempleReplaceCtrl:Ctor(model)
	UIBaseCtrl.Ctor(self, model)
	--- @type UITempleReplaceModel
	self.model = self.model
end

--- @return void
function UITempleReplaceCtrl:Show()
	self.model.money = InventoryUtils.Get(ResourceType.Money)
	self:_SetHeroDataBase()
end

--- @return void
function UITempleReplaceCtrl:Hide()
	self:_ClearData()
end

--- @return void
function UITempleReplaceCtrl:_SetHeroDataBase()
	self.model.heroResourceList = InventoryUtils.Get(ResourceType.Hero)
	self.model.selectedHero = nil
	self.model.convertedHero = nil
end

--- @return void
function UITempleReplaceCtrl:_ClearData()
	self.model.heroResourceList = nil
	self.model.selectedHero = nil
	self.model.convertedHero = nil
end

--- @return HeroResource
function UITempleReplaceCtrl:GetHeroSelected()
	if self.model.selectedHero == nil then
		return nil
	end
	return self.model.heroResourceList:Get(self.model.selectedHero)
end


