--- @class UIEventKazetsuQuestItem : UIEventQuestItem
UIEventKazetsuQuestItem = Class(UIEventKazetsuQuestItem, UIEventQuestItem)

function UIEventKazetsuQuestItem:Ctor()
    UIEventQuestItem.Ctor(self)
end

function UIEventKazetsuQuestItem:SetPrefabName()
    self.prefabName = 'event_kazetsu_gift_quest_item'
    self.uiPoolType = UIPoolType.UIEventKazetsuQuestItem
end

return UIEventKazetsuQuestItem