require "lua.client.scene.ui.home.uiPopupQuestNodeInfo.UIPopupQuestNodeInfoModel"
require "lua.client.scene.ui.home.uiPopupQuestNodeInfo.UIPopupQuestNodeInfoView"

--- @class UIPopupQuestNodeInfo : UIBase
UIPopupQuestNodeInfo = Class(UIPopupQuestNodeInfo, UIBase)

--- @return void
function UIPopupQuestNodeInfo:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupQuestNodeInfo:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupQuestNodeInfoModel()
	self.view = UIPopupQuestNodeInfoView(self.model, self.ctrl)
end

return UIPopupQuestNodeInfo
