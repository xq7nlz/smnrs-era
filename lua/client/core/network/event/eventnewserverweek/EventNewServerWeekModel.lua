--- @class EventNewServerWeekModel : EventPopupModel
EventNewServerWeekModel = Class(EventNewServerWeekModel, EventPopupModel)
--- @param buffer UnifiedNetwork_ByteBuf
function EventNewServerWeekModel:ReadInnerData(buffer)
    local size = buffer:GetByte()
    ---@type List
    self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetQuestConfigDict(), size)
    ---@type Dictionary
    self.dicQuest = self:GetDictQuest()
    self.numberBuyDataDict = Dictionary()
    ---@type Dictionary
    self.packSelectedItemDict = Dictionary()
    local size = buffer:GetByte()
    --print(" size " , size)
    for i = 1, size do
        local packId = buffer:GetShort()
        local numberOfBought = buffer:GetShort()
        self.numberBuyDataDict:Add(packId, numberOfBought)
        -- print("add pack " , packId , "numberOfBought", numberOfBought)
    end
    --- @type EventLoginData
    self.eventLoginData = EventLoginData(buffer)
    local size2 = buffer:GetByte()
    for i = 1, size2 do
        local packId = buffer:GetInt()
        local size3 = buffer:GetByte()
        local listItemSelect = List()
        for i = 1, size3 do
            listItemSelect:Add(buffer:GetInt())
        end
        self.packSelectedItemDict:Add(packId, listItemSelect)
    end
end

function EventNewServerWeekModel:GetSelectItemID(packId)
    local listSelectId = self.packSelectedItemDict:Get(self.packId)
    if (listSelectId == nil or listSelectId:Count() == 0) then
        return nil
    end
    return listSelectId:Get(1)
end

function EventNewServerWeekModel:HasPackNotChosen()
    --- @type List
    local listPack = ResourceMgr.GetPurchaseConfig():GetServerWeekBundle():GetPack(self.timeData.dataId).packList
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

function EventNewServerWeekModel:AddNumberBuy(packId, count)
    ---@type NumberBuyData
    local numberBuyData = self:GetNumberBuy(packId)
    self.numberBuyDataDict:Add(packId, numberBuyData + count)
end

---@return number
function EventNewServerWeekModel:GetNumberBuy(packId)
    if (self.numberBuyDataDict:IsContainKey(packId)) then
        return tonumber(self.numberBuyDataDict:Get(packId))
    else
        return 0
    end
end

function EventNewServerWeekModel:AddSelectItem(packId, listItemSelect)
    self.packSelectedItemDict:Add(packId, listItemSelect)
end

---@param id number
function EventNewServerWeekModel:GetDictQuest()
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
function EventNewServerWeekModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--function EventNewServerWeekModel:IsClaim()
--    if self.eventLoginData.lastClaimLoginTime ~= nil then
--        return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.eventLoginData.lastClaimLoginTime
--                or self.eventLoginData.lastClaimDay >= 7
--    end
--    return nil
--end


function EventNewServerWeekModel:IsClaim()
    return self.eventLoginData:IsClaimed()
end

function EventNewServerWeekModel:IsFreeClaim()
    if self.eventLoginData.lastClaimLoginTime ~= nil then
        return self.eventLoginData:IsFreeClaim()
    end
    return nil
end

function EventNewServerWeekModel:HasQuestDoneNotClaimed()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

function EventNewServerWeekModel:HasDailyDoneNotClaimed()
    return not self.eventLoginData:IsFreeClaim()
end

function EventNewServerWeekModel:HasNotification()
    --- thêm điều kiện nếu cần
    local hasQuesNoti = self:HasQuestDoneNotClaimed()
    --local hasDailyNoti =self:HasDailyDoneNotClaimed()
    local hasDailyNoti = false
    local hasSpinNoti = false --- sửa điều kiện
    local hasArenaNoti = false --- sửa điều kiện
    local hasBundleNoti = false
    return hasQuesNoti or hasSpinNoti or hasArenaNoti or hasDailyNoti or hasBundleNoti
end

function EventNewServerWeekModel:IsTabNotified(newServerWeek)
    if newServerWeek == NewServerWeekTab.CAMPAIGN_BOOT or newServerWeek == NewServerWeekTab.VIP_TREASURE or newServerWeek == NewServerWeekTab.GROW_UP then
        return self:QuestNewServerWeekTabHasNotClaimed(newServerWeek)
    elseif newServerWeek == NewServerWeekTab.SPIN then
        ---@type EventNewServerWeekSpinModel
        local eventModelSpin = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_SPIN)
        if (eventModelSpin ~= nil) then
            return eventModelSpin:HasNotification()
        else
            return false
        end
    elseif newServerWeek == NewServerWeekTab.ARENA_BOOT then
        return false
    elseif newServerWeek == NewServerWeekTab.DAILY then
        return self:HasDailyDoneNotClaimed()
    elseif newServerWeek == NewServerWeekTab.BUNDLE then
        return false;
    else
        --- do some thing if it's arena
    end

    return false
end

function EventNewServerWeekModel:OnClaimQuestSuccess(questId)
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        if v.questId == questId then
            v.questState = QuestState.COMPLETED
            break
        end
    end
    self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end

function EventNewServerWeekModel:QuestNewServerWeekTabHasNotClaimed(tabId)
    local listQuestByWeek = self:GetListQuestDataByTabId(tabId)
    --- @param v QuestUnitInBound
    for _, v in pairs(listQuestByWeek:GetItems()) do
        if (v.questState == QuestState.DONE_REWARD_NOT_CLAIM) then
            return true
        end
    end
    return false
end

function EventNewServerWeekModel:QuestNewServerWeekTabHasNotClaimed(tabId)
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
function EventNewServerWeekModel:GetListQuestDataByTabId(tabId)
    ---@type List
    local lstResult = List()
    ---@type Dictionary < number,QuestElementConfig>>
    local weeklyQuestRewardDict = self:GetConfig():GetDictQuestByTabId(tabId)
    for tabId, questElementConfig in pairs(weeklyQuestRewardDict:GetItems()) do
        lstResult:Add(self.dicQuest:Get(tonumber(tabId)))
    end
    if tabId == NewServerWeekTab.GROW_UP then
        return QuestDataInBound.SortQuestByQuestId(lstResult)
    end
    return QuestDataInBound.SortQuestByData(QuestDataInBound.SortQuestByQuestId(lstResult))
end

--- @class NewServerWeekTab
NewServerWeekTab = {
    GROW_UP = 1,
    CAMPAIGN_BOOT = 2,
    ARENA_BOOT = 3,
    VIP_TREASURE = 4,
    SPIN = 5,
    DAILY = 6,
    BUNDLE = 7
}