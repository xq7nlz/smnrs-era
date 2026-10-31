
--- @class UIMarketModel : UIBaseModel
UIMarketModel = Class(UIMarketModel, UIBaseModel)

--- @return void
function UIMarketModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIMarket, "market")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP

	self.SLOT_PER_PAGE = 8

	--- @type MarketType
	self.currentTab = -1
	self.currentPage = -1
	self.numberPage = 0
end

function UIMarketModel:OnHide()
	self.currentTab = -1
	self.currentPage = -1
end