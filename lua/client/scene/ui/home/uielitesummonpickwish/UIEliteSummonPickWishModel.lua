
--- @class UIEliteSummonPickWishModel : UIBaseModel
UIEliteSummonPickWishModel = Class(UIEliteSummonPickWishModel, UIBaseModel)

--- @return void
function UIEliteSummonPickWishModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEliteSummonPickWish, "ui_elite_summon_pick_wish")
	self.bgDark = true
end

