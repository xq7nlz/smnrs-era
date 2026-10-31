--- @class UIEventNewVipQuestItem : UIEventQuestItem
UIEventNewVipQuestItem = Class(UIEventNewVipQuestItem, UIEventQuestItem)

function UIEventNewVipQuestItem:Ctor()
    UIEventQuestItem.Ctor(self)
end

function UIEventNewVipQuestItem:SetPrefabName()
    self.prefabName = 'event_new_vip_quest_item'
    self.uiPoolType = UIPoolType.UIEventNewVipQuestItem
end

return UIEventNewVipQuestItem