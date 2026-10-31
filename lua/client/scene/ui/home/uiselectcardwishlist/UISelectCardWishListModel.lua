
--- @class UISelectCardWishListModel : UIBaseModel
UISelectCardWishListModel = Class(UISelectCardWishListModel, UIBaseModel)

--- @return void
function UISelectCardWishListModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectCardWishList, "select_card_wish_list")
end

