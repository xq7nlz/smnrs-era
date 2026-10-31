--- @class UIEventNewServerWeekQuestItem : UIEventQuestItem
UIEventNewServerWeekQuestItem = Class(UIEventNewServerWeekQuestItem, UIEventQuestItem)

function UIEventNewServerWeekQuestItem:Ctor()
    UIEventQuestItem.Ctor(self)
end

function UIEventNewServerWeekQuestItem:SetPrefabName()
    self.prefabName = 'event_quest_new_server_week'
    self.uiPoolType = UIPoolType.UIEventNewServerWeekQuestItem
end

return UIEventNewServerWeekQuestItem