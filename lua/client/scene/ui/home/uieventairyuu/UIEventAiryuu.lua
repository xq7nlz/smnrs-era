require "lua.client.scene.ui.home.uiEventAiryuu.UIEventAiryuuModel"
require "lua.client.scene.ui.home.uiEventAiryuu.UIEventAiryuuView"

--- @class UIEventAiryuu : UIBase
UIEventAiryuu = Class(UIEventAiryuu, UIBase)

--- @return void
function UIEventAiryuu:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventAiryuu:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventAiryuuModel()
	self.view = UIEventAiryuuView(self.model)
end

return UIEventAiryuu
