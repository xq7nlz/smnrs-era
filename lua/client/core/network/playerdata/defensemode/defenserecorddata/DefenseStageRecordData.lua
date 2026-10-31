--- @class DefenseStageRecordData
DefenseStageRecordData = Class(DefenseStageRecordData)

function DefenseStageRecordData:Ctor()
    self.listRecordItem = nil
    self.listPlayerRecordItem = nil
    self.lastTimeRequest = nil
end

function DefenseStageRecordData:IsAvailableToRequest(isPlayerRecord)
    local time = self.lastTimeRequest == nil
            or zg.timeMgr:GetServerTime() - self.lastTimeRequest > TimeUtils.SecondAMin
    if time then
        return true
    end
    if isPlayerRecord then
        return self.listPlayerRecordItem == nil
    else
        return self.listRecordItem == nil
    end
end

function DefenseStageRecordData:GetListStageRecord(isPlayerRecord, land, stage, callback)
    local returnCallback = function()
        if isPlayerRecord then
            callback(self.listPlayerRecordItem)
        else
            callback(self.listRecordItem)
        end
    end
    if self:IsAvailableToRequest(isPlayerRecord) then
        local requestDone = function()
            self.lastTimeRequest = zg.timeMgr:GetServerTime()
            returnCallback()
        end
        self:RequestRecordData(isPlayerRecord, land, stage, requestDone)
    else
        returnCallback()
    end
end

function DefenseStageRecordData:RequestRecordData(isPlayerRecord, land, stage, callback)
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            if isPlayerRecord then
                self.listPlayerRecordItem = NetworkUtils.GetListDataInBound(buffer, DefenseBasicRecordInBound)
            else
                self.listRecordItem = NetworkUtils.GetListDataInBound(buffer, DefenseBasicRecordInBound)
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, callback, onFailed)
    end
    NetworkUtils.Request(OpCode.DEFENSE_OTHER_RECORD_LIST_GET,
            UnknownOutBound.CreateInstance(
                    --PutMethod.Bool, isPlayerRecord,
                    PutMethod.Short, land, PutMethod.Int, stage), onReceived)
end