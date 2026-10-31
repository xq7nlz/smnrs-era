require "lua.client.scene.ui.home.uiPopupBuyItemRaid.UIPopupBuyItemRaidModel"
require "lua.client.scene.ui.home.uiPopupBuyItemRaid.UIPopupBuyItemRaidView"

--- @class UIPopupBuyItemRaid : UIBase
UIPopupBuyItemRaid = Class(UIPopupBuyItemRaid, UIBase)

--- @return void
function UIPopupBuyItemRaid:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupBuyItemRaid:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupBuyItemRaidModel()
	self.view = UIPopupBuyItemRaidView(self.model)
end

return UIPopupBuyItemRaid
