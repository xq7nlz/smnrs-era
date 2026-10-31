
--- @class UIIapShopModel : UIBaseModel
UIIapShopModel = Class(UIIapShopModel, UIBaseModel)

--- @return void
function UIIapShopModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIIapShop, "iap_shop")
end

