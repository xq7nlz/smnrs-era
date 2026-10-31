--- @class TowerInBound
TowerInBound = Class(TowerInBound)

function TowerInBound:Ctor()
    --- @type number
    self.selectedLevel = nil
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TowerInBound:ReadBuffer(buffer)
    self.levelCurrent = buffer:GetShort()
    self.lastFreeStamina = buffer:GetLong()
    self.timeReachHighestStage = buffer:GetLong()
    self.isWinLastLevel = false
end

--- @return TowerRecordInBound
--- @param level number
function TowerInBound:GetCacheRecord(level)
    if self.recordDict == nil then
        self.recordDict = Dictionary()
    end
    return self.recordDict:Get(level)
end

--- @param level number
--- @param record TowerRecordInBound
function TowerInBound:AddRecord(level, record)
    if level == nil or record == nil then
        XDebug.Error("data level is invalid: %s, %s", tostring(level), tostring(record))
        return
    end
    self.recordDict:Add(level, record)
end

--- @return void
function TowerInBound:ToString()
    return LogUtils.ToDetail(self)
end

function TowerInBound.GetRecord(level, onSuccess)
    --- @type TowerInBound
    local towerInBound = zg.playerData:GetMethod(PlayerDataMethod.TOWER)
    --- @type TowerRecordInBound
    local record = towerInBound:GetCacheRecord(level)
    if record == nil or record:IsAvailableToRequest() then
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                require "lua.client.core.network.towerRecord.TowerRecordInBound"
                towerInBound:AddRecord(level, TowerRecordInBound(buffer, level))
                onSuccess()
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, nil, SmartPoolUtils.LogicCodeNotification)
        end
        NetworkUtils.Request(OpCode.RECORD_TOWER_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Short, level), onReceived)
    else
        onSuccess()
    end
end

function TowerInBound:SetDataTowerAfterWin()
    self.levelCurrent = self.levelCurrent + 1
    self.selectedLevel = self.selectedLevel + 1
    self:SetLastLevelWin(true)
    self.timeReachHighestStage = zg.timeMgr:GetServerTime()
end

function TowerInBound:SetLastLevelWin(isWin)
    self.isWinLastLevel = isWin
end

function TowerInBound:SetLastFreeStamina(time)
    self.lastFreeStamina = time
end