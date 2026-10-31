require "lua.client.scene.ui.home.uiLeaderBoard.UILeaderBoardModel"
require "lua.client.scene.ui.home.uiLeaderBoard.UILeaderBoardView"

--- @class UILeaderBoard : UIBase
UILeaderBoard = Class(UILeaderBoard, UIBase)

--- @return void
function UILeaderBoard:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UILeaderBoard:OnCreate()
	UIBase.OnCreate(self)
	self.model = UILeaderBoardModel()
	self.view = UILeaderBoardView(self.model, self.ctrl)
end

return UILeaderBoard
