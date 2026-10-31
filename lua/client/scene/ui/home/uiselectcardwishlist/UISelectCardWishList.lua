require "lua.client.scene.ui.home.uiSelectCardWishList.UISelectCardWishListModel"
require "lua.client.scene.ui.home.uiSelectCardWishList.UISelectCardWishListView"

--- @class UISelectCardWishList : UIBase
UISelectCardWishList = Class(UISelectCardWishList, UIBase)

--- @return void
function UISelectCardWishList:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectCardWishList:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectCardWishListModel()
	self.view = UISelectCardWishListView(self.model)
end

return UISelectCardWishList
