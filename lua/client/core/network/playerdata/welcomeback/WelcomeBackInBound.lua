--- @class WelcomeBackInBound
WelcomeBackInBound = Class(WelcomeBackInBound)

function WelcomeBackInBound:Ctor()
    --- @type number
    self.dataId = nil
    --- @type number
    self.startTime = nil
    --- @type number
    self.endTime = nil

    --- @type number
    self.lastClaimDay = nil
    --- @type number
    self.lastClaimLoginTime = nil

    --- @type Dictionary
    self.questConfig = nil

    --- @type number
    self.lastTimeRequest = nil

    --- @type Dictionary
    self.purchaseNumberDict = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function WelcomeBackInBound:ReadBuffer(buffer)
    self.isInComingBackEvent = buffer:GetBool()
    if self.isInComingBackEvent == true then
        self.purchaseNumberDict = Dictionary()

        self:ReadInnerBuffer(buffer)
    end
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

--- @param buffer UnifiedNetwork_ByteBuf
function WelcomeBackInBound:ReadInnerBuffer(buffer)
    self.dataId = buffer:GetInt()
    self.startTime = buffer:GetLong()
    self.endTime = self.startTime + ResourceMgr.GetWelcomeBackData().duration
    self.questConfig = self:GetQuestDataConfig()

    self.lastClaimDay = buffer:GetInt()
    self.lastClaimLoginTime = buffer:GetLong()

    local size = buffer:GetByte()
    for _ = 1, size do
        self.purchaseNumberDict:Add(buffer:GetInt(), buffer:GetInt())
    end

    self.listDailyQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.questConfig)
    self:_FilterDailyQuest()
end

function WelcomeBackInBound:HasNotification()
    return self:IsTabNotified(WelcomeBackTab.LOGIN)
            or self:IsTabNotified(WelcomeBackTab.QUEST)
            or self:IsTabNotified(WelcomeBackTab.BUNDLE)
end

--- @param welcomeBackTab WelcomeBackTab
function WelcomeBackInBound:IsTabNotified(welcomeBackTab)
    if welcomeBackTab == WelcomeBackTab.LOGIN then
        return TimeUtils.GetTimeStartDayFromSec(self.lastClaimLoginTime) < TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime())
                and self.lastClaimDay < 7
    elseif welcomeBackTab == WelcomeBackTab.QUEST then
        return QuestDataInBound.HasDoneNotClaimQuest(self.listDailyQuest)
    end
    return false
end

function WelcomeBackInBound:IsClaimed()
    local startTimeOfDay = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime())
    return TimeUtils.GetTimeStartDayFromSec(self.lastClaimLoginTime) >= startTimeOfDay
end

function WelcomeBackInBound:IsFreeClaim()
    return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.lastClaimLoginTime
            or self.lastClaimDay >= 14
end

--- @return WelcomeBackData
function WelcomeBackInBound:GetLoginDataConfig()
    return ResourceMgr.GetWelcomeBackData():GetLoginData(self.dataId)
end

--- @return Dictionary
function WelcomeBackInBound:GetQuestDataConfig()
    return ResourceMgr.GetWelcomeBackData():GetQuestData(self.dataId).dailyQuestDict
end

--- @return WelcomeBackLoginConfig
function WelcomeBackInBound:GetLoginDataConfig()
    return ResourceMgr.GetWelcomeBackData():GetLoginData(self.dataId)
end

function WelcomeBackInBound:_FilterDailyQuest()
    local totalHidden = 0
    --- @type QuestUnitInBound
    local questData
    local questCount = self.listDailyQuest:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listDailyQuest:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listDailyQuest:RemoveByIndex(i)
            totalHidden = totalHidden + 1
        elseif questData == nil then
            --- @type QuestElementConfig
            local questElementConfig = self.questConfig:Get(questUnitData.questId)
            if questElementConfig:GetQuestType() == QuestType.DAILY_QUEST_COMPLETE then
                questData = questUnitData
            end
        end
    end
    if questData ~= nil then
        questData.number = questData.number - totalHidden
    end
    self:SortQuestByData()
end

function WelcomeBackInBound:OnClaimQuestSuccess(questId)
    for i = 1, self.listDailyQuest:Count() do
        --- @type QuestUnitInBound
        local questData = self.listDailyQuest:Get(i)
        if questData.questId == questId then
            questData.questState = QuestState.COMPLETED
            break
        end
    end
    self:SortQuestByData()
end

function WelcomeBackInBound:SortQuestByData()
    self.listDailyQuest = QuestDataInBound.SortQuestByData(self.listDailyQuest)
end

function WelcomeBackInBound.Validate(callback, forceUpdate)
    --- @type WelcomeBackInBound
    local welcomeBackInBound = zg.playerData:GetMethod(PlayerDataMethod.COMEBACK)
    if welcomeBackInBound == nil or welcomeBackInBound.lastTimeRequest == nil or forceUpdate == true then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.COMEBACK }, callback)
    else
        if callback then
            callback()
        end
    end
end

--- @return number
function WelcomeBackInBound:GetNumberBuyPack(packId)
    local numberBuy = self.purchaseNumberDict:Get(packId)
    if numberBuy == nil then
        numberBuy = 0
        self.purchaseNumberDict:Add(packId, numberBuy)
    end
    return numberBuy
end

function WelcomeBackInBound:IncreaseBoughtPack(packId)
    local numberBuy = self:GetNumberBuyPack(packId)
    self.purchaseNumberDict:Add(packId, numberBuy + 1)
end

--- @class WelcomeBackTab
WelcomeBackTab = {
    LOGIN = 1,
    QUEST = 2,
    BUNDLE = 3,
}