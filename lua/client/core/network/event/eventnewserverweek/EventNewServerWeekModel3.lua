--- @class EventNewServerWeekModel3 : EventPopupModel
EventNewServerWeekModel3 = Class(EventNewServerWeekModel3, EventPopupModel)
--- @param buffer UnifiedNetwork_ByteBuf
function EventNewServerWeekModel3:ReadInnerData(buffer)
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

function EventNewServerWeekModel3:HasPackNotChosen()
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

function EventNewServerWeekModel3:AddNumberBuy(packId,count)
    ---@type NumberBuyData
    local numberBuyData = self:GetNumberBuy(packId)
    self.numberBuyDataDict:Add(packId, numberBuyData + count)
end

---@return number
function EventNewServerWeekModel3:GetNumberBuy(packId)
    if (self.numberBuyDataDict:IsContainKey(packId)) then
        return tonumber(self.numberBuyDataDict:Get(packId))
    else
        return 0
    end
end

function EventNewServerWeekModel3:AddSelectItem(packId,listItemSelect)
    self.packSelectedItemDict:Add(packId, listItemSelect)
end

---@param id number
function EventNewServerWeekModel3:GetDictQuest()
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
function EventNewServerWeekModel3:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventNewServerWeekModel3:IsClaim()
    if self.eventLoginData.lastClaimLoginTime ~= nil then
        return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.eventLoginData.lastClaimLoginTime
                or self.eventLoginData.lastClaimDay >= 7
    end
    return nil
end

function EventNewServerWeekModel3:HasQuestDoneNotClaimed()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

function EventNewServerWeekModel3:HasDailyDoneNotClaimed()
    return not self.eventLoginData:IsFreeClaim()
end

function EventNewServerWeekModel3:OnClaimQuestSuccess(questId)
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        if v.questId == questId then
            v.questState = QuestState.COMPLETED
            break
        end
    end
    self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end



function EventNewServerWeekModel3:QuestNewServerWeekTabHasNotClaimed(tabId)
    local listQuestByWeek = self:GetListQuestDataByTabId(tabId)
    --- @param v QuestUnitInBound
    for _, v in pairs(listQuestByWeek:GetItems()) do
        if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

function EventNewServerWeekModel3:QuestNewServerWeekTabHasNotClaimed(tabId)
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
function EventNewServerWeekModel3:GetListQuestDataByTabId(tabId)
    ---@type List
    local lstResult = List()
    ---@type Dictionary < number,QuestElementConfig>>
    local weeklyQuestRewardDict = self:GetConfig():GetDictQuestByTabId(tabId)
    for tabId, questElementConfig in pairs(weeklyQuestRewardDict:GetItems()) do
        lstResult:Add(self.dicQuest:Get(tonumber(tabId)))
    end
    if tabId == NewServerWeekTab3.GROW_UP then
        return  QuestDataInBound.SortQuestByQuestId(lstResult)
    end
    return  QuestDataInBound.SortQuestByData(QuestDataInBound.SortQuestByQuestId(lstResult))
end


function EventNewServerWeekModel3:HasNotification()
    --- thêm điều kiện nếu cần
    local hasQuesNoti =self:HasQuestDoneNotClaimed()
    local hasBundleNoti = false
    return hasQuesNoti  or hasBundleNoti
end

function EventNewServerWeekModel3:IsTabNotified(newServerWeek)
    if newServerWeek == NewServerWeekTab3.CAMPAIGN_BOOT or newServerWeek == NewServerWeekTab3.FORTRESS
            or newServerWeek == NewServerWeekTab3.GROW_UP then
        return self:QuestNewServerWeekTabHasNotClaimed(newServerWeek)
    elseif newServerWeek == NewServerWeekTab3.BUNDLE then
        return false
    else
        --- do some thing if it's arena
    end
    return false
end
NewServerWeekTab3 = {
    GROW_UP = 1,
    CAMPAIGN_BOOT = 2,
    FORTRESS = 4,
    BUNDLE = 5,
}