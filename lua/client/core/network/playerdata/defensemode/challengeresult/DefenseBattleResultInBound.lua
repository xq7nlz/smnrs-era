
--- @class DefenseBattleResultInBound
DefenseBattleResultInBound = Class(DefenseBattleResultInBound)

function DefenseBattleResultInBound:Ctor()

end

--- @param buffer UnifiedNetwork_ByteBuf
function DefenseBattleResultInBound:ReadBuffer(buffer)
    self.battleResultInBound = BattleResultInBound.CreateByBuffer(buffer)
    self.damageDeal = buffer:GetInt()
    self.road = buffer:GetByte()
    self.wave = buffer:GetByte()
end

--- @return DefenseBattleResultInBound
function DefenseBattleResultInBound.CreateByBuffer(buffer)
    local defenseBattleResultInBound = DefenseBattleResultInBound()
    defenseBattleResultInBound:ReadBuffer(buffer)
    return defenseBattleResultInBound
end