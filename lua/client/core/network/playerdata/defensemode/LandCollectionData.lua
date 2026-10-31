require "lua.client.core.network.playerData.defenseMode.WaveChallengeData"
require "lua.client.core.network.campaign.IdleDurationCampaign"
require "lua.client.core.network.playerData.defenseMode.DefenderConstructionData"

--- @class LandCollectionData
LandCollectionData = Class(LandCollectionData)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function LandCollectionData:Ctor(landId, buffer)
    self.land = landId
    ---@type Dictionary -- <road, IdleDurationCampaign>
    self.idleDurationMap = Dictionary()
    ---@type TeamFormationInBound
    self.teamFormation = nil
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function LandCollectionData:ReadBuffer(buffer)
    --- @type number
    self.stage = buffer:GetInt()

    local size = buffer:GetByte()
    if size > 0 then
        for i = 1, size do
            self.idleDurationMap:Add(buffer:GetString(), IdleDurationCampaign.CreateByBuffer(buffer))
        end
    end

    self.teamFormation = TeamFormationInBound.CreateByBuffer(buffer)
end

--- @return void
---@param timeServer number
function LandCollectionData:ClearIdle(timeServer)
    ---@param idleDuration IdleDurationCampaign
    for i, idleDuration in pairs(self.idleDurationMap:GetItems()) do
        idleDuration:Clear(timeServer)
    end
end