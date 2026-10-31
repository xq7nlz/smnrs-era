require "lua.client.core.network.towerRecord.TowerRecord"

local MAX_RECORD = 3
local MIN_TIME_REQUEST = 10

--- @class TowerRecordInBound
TowerRecordInBound = Class(TowerRecordInBound)

--- @param buffer UnifiedNetwork_ByteBuf
--- @param stage number
function TowerRecordInBound:Ctor(buffer, stage)
    --- @type number
    self.stageRecord = stage
    ---@type List
    self.listBattleRecord = NetworkUtils.GetListDataInBound(buffer, TowerRecord)
    --- @type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function TowerRecordInBound:TotalRecord()
    return self.listBattleRecord:Count()
end

--- @param index number
function TowerRecordInBound:GetRecord(index)
    return self.listBattleRecord:Get(index)
end

--- @return boolean
function TowerRecordInBound:IsAvailableToRequest()
    if self.lastTimeRequest == nil then
        return true
    end
    local deltaTime = zg.timeMgr:GetServerTime() - self.lastTimeRequest
    return (self:TotalRecord() < MAX_RECORD and deltaTime > MIN_TIME_REQUEST) or (deltaTime > TimeUtils.SecondAMin)
end
