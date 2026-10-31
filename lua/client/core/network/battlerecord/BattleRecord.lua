--- @class BattleRecord
BattleRecord = Class(BattleRecord)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BattleRecord:Ctor(buffer)
    ---@type OtherPlayerInfoInBound
    self.teamRecordAttack = OtherPlayerInfoInBound.CreateByBuffer(buffer)
    ---@type OtherPlayerInfoInBound
    self.teamRecordDefend = OtherPlayerInfoInBound.CreateByBuffer(buffer)
    ---@type SeedInBound
    self.seedInBound = SeedInBound.CreateByBuffer(buffer)
    --- @type string
    self.battleLog = buffer:GetString(false)
end