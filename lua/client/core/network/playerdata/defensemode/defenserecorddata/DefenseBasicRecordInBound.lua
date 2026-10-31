require "lua.client.core.network.playerData.defenseMode.defenseRecordData.DefenseRecordFormationInBound"

--- @class DefenseBasicRecordInBound
DefenseBasicRecordInBound = Class(DefenseBasicRecordInBound)

function DefenseBasicRecordInBound:Ctor(buffer)
    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function DefenseBasicRecordInBound:ReadBuffer(buffer)
    self.recordId = buffer:GetString()

    self.avatar = buffer:GetInt()
    self.playerLevel = buffer:GetInt()
    self.playerName = buffer:GetString()

    ---@type DefenseRecordFormationInBound
    self.defenseRecordFormationInBound = DefenseRecordFormationInBound(buffer)
end

function DefenseBasicRecordInBound:GetBattleTeamInfo()
    return self.defenseRecordFormationInBound:GetBattleTeamInfo(self.playerLevel)
end