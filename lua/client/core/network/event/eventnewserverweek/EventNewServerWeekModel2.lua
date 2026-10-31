--- @class EventNewServerWeekModel2 : EventPopupModel
EventNewServerWeekModel2 = Class(EventNewServerWeekModel2, EventPopupModel)
--- @param buffer UnifiedNetwork_ByteBuf
function EventNewServerWeekModel2:ReadInnerData(buffer)
    local size = buffer:GetByte()
    ---@type List
    self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetQuestConfigDict(),size)
    ---@type Dictionary
    self.dicQuest = self:GetDictQuest()
    self.numberBuyDataDict = Dictionary()
    ---@type Dictionary
    self.packSelectedItemDict = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        local packId = buffer:GetShort()
        local numberOfBought = buffer:GetShort()
        self.numberBuyDataDict:Add(packId, numberOfBought)
    end
    local size2 = buffer:GetByte()
    for i = 1, size2 do
        local packId = buffer:GetInt()
        local size3 = buffer:GetByte()
        local listItemSelect = List()
        for i = 1, size3 do
            listItemSelect:Add(buffer:GetInt())
        end
        self.packSelectedItemDict:Add(packId,listItemSelect)
    end
end

function EventNewServerWeekModel2:HasPackNotChosen()
    --- @type List
    local listPack = ResourceMgr.GetPurchaseConfig():GetServerWeekBundle2():GetPack(self.timeData.dataId).packList
    for i = 1, listPack:Count() do
        ---@type EventServerWeekProduct
        local pack = listPack:Get(i)
        if (pack.numberSelect > 0) then
            local selected = self.packSelectedItemDict:IsContainKey(pack.id)
            if (not selected) then
                return true
            end
        end
    end
    return false
end

function EventNewServerWeekModel2:AddNumberBuy(packId,count)
    ---@type NumberBuyData
    local numberBuyData = self:GetNumberBuy(packId)
    self.numberBuyDataDict:Add(packId, numberBuyData + count)
end

---@return number
function EventNewServerWeekModel2:GetNumberBuy(packId)
    if (self.numberBuyDataDict:IsContainKey(packId)) then
        return tonumber(self.numberBuyDataDict:Get(packId))
        else
        return 0
    end
end

function EventNewServerWeekModel2:AddSelectItem(packId,listItemSelect)
    self.packSelectedItemDict:Add(packId, listItemSelect)
end

---@param id number
function EventNewServerWeekModel2:GetDictQuest()
    ---@type Dictionary
    local dicQuest = Dictionary()

    for k = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(k)
        dicQuest:Add(questUnitInBound.questId, questUnitInBound)
    end
    return dicQuest
end

--- @return EventNewServerWeekConfig
function EventNewServerWeekModel2:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventNewServerWeekModel2:IsClaim()
    if self.eventLoginData.lastClaimLoginTime ~= nil then
        return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.eventLoginData.lastClaimLoginTime
                or self.eventLoginData.lastClaimDay >= 7
    end
    return nil
end

function EventNewServerWeekModel2:HasQuestDoneNotClaimed()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

function EventNewServerWeekModel2:HasDailyDoneNotClaimed()
    return not self.eventLoginData:IsFreeClaim()
end

function EventNewServerWeekModel2:HasNotification()
    --- thêm điều kiện nếu cần
    local hasQuesNoti =self:HasQuestDoneNotClaimed()
    local hasArenaNoti = false --- sửa điều kiện
    local hasBundleNoti = false
    return hasQuesNoti  or hasArenaNoti  or hasBundleNoti
end


function EventNewServerWeekModel2:IsTabNotified(newServerWeek)
    if newServerWeek == NewServerWeekTab2.DUNGEON or newServerWeek == NewServerWeekTab2.TOWER_BOOTCAMP or newServerWeek == NewServerWeekTab2.GROW_UP then
        return self:QuestNewServerWeekTabHasNotClaimed(newServerWeek)
    elseif newServerWeek == NewServerWeekTab2.ARENA_3V3_BOOT then
        return false
    elseif newServerWeek == NewServerWeekTab.BUNDLE then
        return false
    end
    return false
end


function EventNewServerWeekModel2:OnClaimQuestSuccess(questId)
--- @param v QuestUnitInBound
for _, v in pairs(self.listQuestData:GetItems()) do
    if v.questId == questId then
        v.questState = QuestState.COMPLETED
        break
    end
end
self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end



function EventNewServerWeekModel2:QuestNewServerWeekTabHasNotClaimed(tabId)
    local listQuestByWeek = self:GetListQuestDataByTabId(tabId)
    --- @param v QuestUnitInBound
    for _, v in pairs(listQuestByWeek:GetItems()) do
        if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

function EventNewServerWeekModel2:QuestNewServerWeekTabHasNotClaimed(tabId)
    local listQuestByWeek = self:GetListQuestDataByTabId(tabId)
    --- @param v QuestUnitInBound
    for _, v in pairs(listQuestByWeek:GetItems()) do
        if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

---@return List --QuestDataInBound
---@param tabId number
function EventNewServerWeekModel2:GetListQuestDataByTabId(tabId)
    ---@type List
    local lstResult = List()
    ---@type Dictionary < number,QuestElementConfig>>
    local weeklyQuestRewardDict = self:GetConfig():GetDictQuestByTabId(tabId)
    for tabId, questElementConfig in pairs(weeklyQuestRewardDict:GetItems()) do
        lstResult:Add(self.dicQuest:Get(tonumber(tabId)))
    end
    if tabId == NewServerWeekTab2.GROW_UP then
        return  QuestDataInBound.SortQuestByQuestId(lstResult)
    end
    return  QuestDataInBound.SortQuestByData(QuestDataInBound.SortQuestByQuestId(lstResult))
end



NewServerWeekTab2 = {
    GROW_UP = 1,
    TOWER_BOOTCAMP = 2,
    ARENA_3V3_BOOT = 3,
    DUNGEON = 4,
    BUNDLE = 5,
}