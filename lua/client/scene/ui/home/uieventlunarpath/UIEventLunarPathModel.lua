
--- @class UIEventLunarPathModel : UIBaseModel
UIEventLunarPathModel = Class(UIEventLunarPathModel, UIBaseModel)

--- @return void
function UIEventLunarPathModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventLunarPath, "ui_event_lunar_path")

	self.listSubEvent = List()
end

function UIEventLunarPathModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(LunarPathTab.DICE)
	self.listSubEvent:Add(LunarPathTab.QUEST)
	self.listSubEvent:Add(LunarPathTab.BOSS)
	self.listSubEvent:Add(LunarPathTab.SHOP)
	self.listSubEvent:Add(LunarPathTab.BUNDLE)
end