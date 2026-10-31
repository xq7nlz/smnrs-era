--- @class DomainRecordData
DomainRecordData = Class(DomainRecordData)

function DomainRecordData:Ctor()
    self.recordDict = Dictionary()
end

--- @param buffer UnifiedNetwork_ByteBuf
function DomainRecordData:ReadBuffer(buffer)
    self.recordDict:Clear()
    local size = buffer:GetByte()

    for i = 1, size do
        self.recordDict:Add(buffer:GetInt(), DomainStageRecordData(buffer))
    end

    self.lastTimeUpdated = zg.timeMgr:GetServerTime()
end

--- @return DomainStageRecordData
function DomainRecordData:GetStageRecordData(stage)
    return self.recordDict:Get(stage)
end

function DomainRecordData.Validate(callback, forceUpdate)
    local domainInBound = zg.playerData:GetDomainInBound()
    local domainRecordData = domainInBound.domainRecordData
    if forceUpdate == true or domainRecordData.lastTimeUpdated == nil
            or (zg.timeMgr:GetServerTime() - domainRecordData.lastTimeUpdated) > TimeUtils.SecondAMin then
        local onBufferReading = function(buffer)
            domainInBound.domainRecordData:ReadBuffer(buffer)
        end
        NetworkUtils.RequestAndCallback(OpCode.RECORD_DOMAINS_GET,
                UnknownOutBound.CreateInstance(PutMethod.Int, domainInBound.domainCrewInBound.crewId,
                        PutMethod.Long, domainInBound.domainCrewInBound.leaderId),
                callback, SmartPoolUtils.LogicCodeNotification, onBufferReading)
    else
        if callback then
            callback()
        end
    end
end

--- @class DomainStageRecordData
DomainStageRecordData = Class(DomainStageRecordData)

function DomainStageRecordData:Ctor(buffer)
    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function DomainStageRecordData:ReadBuffer(buffer)
    --- @type OtherPlayerInfoInBound
    self.compactPlayerInfo = OtherPlayerInfoInBound.CreateByBuffer(buffer)

    --- @type boolean
    self.isAttackerWin = buffer:GetBool()

    --- @type SeedInBound
    self.seedInBound = SeedInBound.CreateByBuffer(buffer)

    --- @type string
    self.battleLog = nil
    --- @type string
    self.getStringBattle = buffer:GetString(false)
    if self.getStringBattle ~= "" then
        --- @type string
        self.battleLog = self.getStringBattle
    end
end