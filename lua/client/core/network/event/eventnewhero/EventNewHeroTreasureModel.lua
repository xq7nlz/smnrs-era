--- @class EventNewHeroTreasureModel : EventPopupModel
EventNewHeroTreasureModel = Class(EventNewHeroTreasureModel, EventPopupModel)

function EventNewHeroTreasureModel:Ctor()
    ---@type List
    self.listUnlockLand = List()
    ---@type Dictionary
    self.dictUnlockLand = Dictionary()
    ---@type number
    self.numberCompletedLine = nil
    ---@type number
    self.currentPosition = -1
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroTreasureModel:ReadInnerData(buffer)
    local size = buffer:GetByte()
    self.listUnlockLand:Clear()
    self.dictUnlockLand:Clear()
    for i = 1, size do
        local id = buffer:GetInt()
        self.listUnlockLand:Add(id)
        self.dictUnlockLand:Add(math.floor(id / 1000), id % 1000)
    end
    self.numberCompletedLine = buffer:GetInt()
    self.currentPosition = buffer:GetInt()
end

--- @return number
function EventNewHeroTreasureModel:GetTimeFreeSummon()
    local serverTime = zg.timeMgr:GetServerTime()
    return self:GetConfig():GetFreeInterval() - (serverTime - self.lastFreeSummon) + 1
end

function EventNewHeroTreasureModel:HasNotification()
    ---@type EventNewHeroTreasureConfig
    self.eventConfig = self:GetConfig()
    local finalTreasure = self:GetTreasureFinalCanOpen()
    if finalTreasure ~= nil then
        ---@type FinalTreasureRewardConfig
        local finalTreasureRewardConfig = self.eventConfig:GetFinalTreasureRewardConfig(finalTreasure)
        if InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(
                ResourceType.Money, finalTreasureRewardConfig.moneyType , finalTreasureRewardConfig.moneyValue), false) then
            return true
        end
    end
    for line = 1, self.eventConfig:GetTreasureLine() do
        ---@param v TreasureRewardConfig
        for i, v in ipairs(self.eventConfig:GetListTreasureRewardConfig(line):GetItems()) do
            if (self:GetIndexUnlockLine(line) == v.index - 1) then
                if InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(
                        ResourceType.Money, v.moneyType , v.moneyValue), false) then
                    return true
                end
            end
        end
    end
    return false
end

--- @return EventNewHeroTreasureConfig
function EventNewHeroTreasureModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventNewHeroTreasureModel:GetIndexUnlockLine(line)
    return self.dictUnlockLand:Get(line) or 0
end

function EventNewHeroTreasureModel:SetIndexUnlockLand(id)
    self.dictUnlockLand:Add(math.floor(id / 1000), id % 1000)
end

function EventNewHeroTreasureModel:GetTreasureFinalCanOpen()
    if self:GetCountLineComplete() > self.numberCompletedLine then
        return self.numberCompletedLine + 1
    end
    return nil
end

function EventNewHeroTreasureModel:GetCountLineComplete()
    ---@type EventBirthdayConfig
    self.eventConfig = self:GetConfig()
    local count = 0
    for line = 1, self.eventConfig:GetTreasureLine() do
        local list = self.eventConfig:GetListTreasureRewardConfig(line)
        ---@type TreasureRewardConfig
        local treasureRewardConfig = list:Get(list:Count())
        if self:GetIndexUnlockLine(treasureRewardConfig.line) >= treasureRewardConfig.index then
            count = count + 1
        end
    end
    return count
end