require "lua.client.scene.ui.home.uiWiki.UIWikiModel"
require "lua.client.scene.ui.home.uiWiki.UIWikiView"

--- @class UIWiki : UIBase
UIWiki = Class(UIWiki, UIBase)

--- @return void
function UIWiki:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIWiki:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIWikiModel()
	self.view = UIWikiView(self.model, self.ctrl)
end

return UIWiki
