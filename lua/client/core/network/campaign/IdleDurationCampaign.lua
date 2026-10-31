--- @class IdleDurationCampaign
IdleDurationCampaign = Class(IdleDurationCampaign)

--- @return void
function IdleDurationCampaign:Ctor()
    ---@type Dictionary --<stageId, time>
    self.totalTime = Dictionary()
    ---@type number
    self.lastTimeIdle = nil
end

--- @return void
--- @param jsonDatabase table
function IdleDurationCampaign:InitDatabase(jsonDatabase)
    if jsonDatabase ~= nil then
        self.totalTime:Clear()
        for stageId, time in pairs(jsonDatabase['0']) do
            self.totalTime:Add(tonumber(stageId), tonumber(time))
        end
        self.lastTimeIdle = tonumber(jsonDatabase['1'])
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function IdleDurationCampaign.CreateByBuffer(buffer)
    ---@type IdleDurationCampaign
    local idleDurationCampaign = IdleDurationCampaign()
    local size = buffer:GetByte()
    if size > 0 then
        for i = 1, size do
            idleDurationCampaign.totalTime:Add(buffer:GetInt(), buffer:GetInt())
        end
    end
    idleDurationCampaign.lastTimeIdle = buffer:GetLong()
    return idleDurationCampaign
end

--- @return void
--- @param timeServer number
function IdleDurationCampaign:Clear(timeServer)
    self.totalTime:Clear()
    self.lastTimeIdle = timeServer
end