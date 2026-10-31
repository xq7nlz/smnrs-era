require "lua.client.scene.ui.home.uiShowItemInRandomPoolSplit.UIShowItemInRandomPoolSplitModel"
require "lua.client.scene.ui.home.uiShowItemInRandomPoolSplit.UIShowItemInRandomPoolSplitView"

--- @class UIShowItemInRandomPoolSplit : UIBase
UIShowItemInRandomPoolSplit = Class(UIShowItemInRandomPoolSplit, UIBase)

--- @return void
function UIShowItemInRandomPoolSplit:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIShowItemInRandomPoolSplit:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIShowItemInRandomPoolSplitModel()
	self.view = UIShowItemInRandomPoolSplitView(self.model)
end

return UIShowItemInRandomPoolSplit
