--- @class UIEventPuzzleQuestItem : UIEventQuestItem
UIEventPuzzleQuestItem = Class(UIEventPuzzleQuestItem, UIEventQuestItem)

function UIEventPuzzleQuestItem:Ctor()
    UIEventQuestItem.Ctor(self)
end

function UIEventPuzzleQuestItem:SetPrefabName()
    self.prefabName = 'event_puzzle_quest_item'
    self.uiPoolType = UIPoolType.UIEventPuzzleQuestItem
end

return UIEventPuzzleQuestItem