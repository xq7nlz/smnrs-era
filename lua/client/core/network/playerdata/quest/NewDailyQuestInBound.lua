--- @class NewDailyQuestInBound : DailyQuestInBound
NewDailyQuestInBound = Class(NewDailyQuestInBound,DailyQuestInBound)

function NewDailyQuestInBound:Ctor()
    --- @type boolean
    self.hasNotification = nil
    --- @type List
    self.listDailyQuest = nil
    --- @type Dictionary<number, QuestElementConfig>
    self.config = ResourceMgr.GetQuestConfig():GetNewDailyQuest()
end

--- @param buffer UnifiedNetwork_ByteBuf
function NewDailyQuestInBound:ReadBuffer(buffer)
    self.listDailyQuest = QuestDataInBound.ReadListDailyQuestFromBuffer(buffer, self.config)
    self:_FilterDailyQuest()
end