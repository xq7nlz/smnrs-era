--- @class ArenaTeamBattleRecord
ArenaTeamBattleRecord = Class(ArenaTeamBattleRecord)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamBattleRecord:Ctor(buffer)
    ---@type OtherPlayerInfoInBound
    self.teamRecordAttack = OtherPlayerInfoInBound.CreateByBuffer(buffer)
    ---@type OtherPlayerInfoInBound
    self.teamRecordDefend = OtherPlayerInfoInBound.CreateByBuffer(buffer)
    ---@type boolean
    self.isAttackWin = buffer:GetBool()
    ---@type SeedInBound
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