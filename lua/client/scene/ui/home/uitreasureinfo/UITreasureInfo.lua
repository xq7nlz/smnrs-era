require "lua.client.scene.ui.home.uiTreasureInfo.UITreasureInfoModel"
require "lua.client.scene.ui.home.uiTreasureInfo.UITreasureInfoView"

--- @class UITreasureInfo : UIBase
UITreasureInfo = Class(UITreasureInfo, UIBase)

--- @return void
function UITreasureInfo:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UITreasureInfo:OnCreate()
	UIBase.OnCreate(self)
	self.model = UITreasureInfoModel()
	self.view = UITreasureInfoView(self.model)
end

return UITreasureInfo
