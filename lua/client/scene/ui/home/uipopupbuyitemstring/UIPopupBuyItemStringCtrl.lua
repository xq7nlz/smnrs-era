
--- @class UIPopupBuyItemStringCtrl : UIBaseCtrl
UIPopupBuyItemStringCtrl = Class(UIPopupBuyItemStringCtrl, UIBaseCtrl)

--- @return void
--- @param model UIPopupBuyItemStringModel
function UIPopupBuyItemStringCtrl:Ctor(model)
	UIBaseCtrl.Ctor(self, model)
end

--- @return void
function UIPopupBuyItemStringCtrl:UpdateData()
	self.model.priceTotal = math.floor(self.model.data.number * self.model.data.price)
end