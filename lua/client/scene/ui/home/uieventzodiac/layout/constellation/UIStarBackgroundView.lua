--- @class UIStarBackgroundView : MotionIconView
UIStarBackgroundView = Class(UIStarBackgroundView, MotionIconView)

function UIStarBackgroundView:Ctor()
	--- @type ItemsTableView
	self.itemsTableView = nil
	---@type UIEventQuestItemConfig
	self.config = nil
	MotionIconView.Ctor(self)
end

function UIStarBackgroundView:SetPrefabName()
	self.prefabName = 'zodiac_constellation_bg'
	self.uiPoolType = UIPoolType.UIStarBackgroundView
end
