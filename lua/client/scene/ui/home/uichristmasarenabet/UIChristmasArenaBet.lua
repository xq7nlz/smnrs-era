require "lua.client.scene.ui.home.uiChristmasArenaBet.UIChristmasArenaBetModel"
require "lua.client.scene.ui.home.uiChristmasArenaBet.UIChristmasArenaBetView"

--- @class UIChristmasArenaBet : UIBase
UIChristmasArenaBet = Class(UIChristmasArenaBet, UIBase)

--- @return void
function UIChristmasArenaBet:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIChristmasArenaBet:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIChristmasArenaBetModel()
	self.view = UIChristmasArenaBetView(self.model)
end

return UIChristmasArenaBet
