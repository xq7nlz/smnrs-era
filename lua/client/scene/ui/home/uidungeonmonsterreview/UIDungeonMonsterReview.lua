require "lua.client.scene.ui.home.uiDungeonMonsterReview.UIDungeonMonsterReviewModel"
require "lua.client.scene.ui.home.uiDungeonMonsterReview.UIDungeonMonsterReviewView"

--- @class UIDungeonMonsterReview : UIBase
UIDungeonMonsterReview = Class(UIDungeonMonsterReview, UIBase)

--- @return void
function UIDungeonMonsterReview:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDungeonMonsterReview:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDungeonMonsterReviewModel()
	self.view = UIDungeonMonsterReviewView(self.model, self.ctrl)
end

return UIDungeonMonsterReview
