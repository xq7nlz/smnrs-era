
--- @class UIPopupSummonItemModel : UIBaseModel
UIPopupSummonItemModel = Class(UIPopupSummonItemModel, UIBaseModel)

--- @return void
function UIPopupSummonItemModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupSummonItem, "popup_summon_item")
	---@type FragmentIconData
	self.fragmentData = nil
	---@type number
	self.number = nil
	---@type number
	self.numberFragment = nil
	---@type number
	self.maxSummon = nil

	self.bgDark = true
end

--- @return void
---@param fragmentData FragmentIconData
function UIPopupSummonItemModel:InitData(fragmentData)
	self.fragmentData = fragmentData
	self.maxSummon = math.floor(self.fragmentData.quantity / self.fragmentData.countFull)
	local heroCount = InventoryUtils.Get(ResourceType.Hero):Count()
	if fragmentData.type == ResourceType.HeroFragment then
		if heroCount < ClientConfigUtils.MAX_HERO then
			self.maxSummon = math.min(self.maxSummon, ClientConfigUtils.MAX_HERO - heroCount)
		else
			self.maxSummon = 0
		end
	end
end

--- @return void
function UIPopupSummonItemModel:UpdateData()
	self.numberFragment = self.fragmentData.countFull * self.number
end

