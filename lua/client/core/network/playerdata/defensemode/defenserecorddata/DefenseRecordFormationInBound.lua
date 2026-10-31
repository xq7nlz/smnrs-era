--- @class DefenseRecordFormationInBound
DefenseRecordFormationInBound = Class(DefenseRecordFormationInBound)

function DefenseRecordFormationInBound:Ctor(buffer)
    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function DefenseRecordFormationInBound:ReadBuffer(buffer)
    self.summonerStar = buffer:GetByte()
    self.summonerClass = buffer:GetByte()
    ---@type DetailTeamFormation
    self.detailTeamFormation = DetailTeamFormation.CreateByBuffer(buffer)
    self.isDummySummoner = buffer:GetBool()
    self.power = buffer:GetLong()
end

--- @return BattleTeamInfo
function DefenseRecordFormationInBound:GetBattleTeamInfo(level)
    --- @type BattleTeamInfo
    local battleTeamInfo = ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationSummoner(
            self.detailTeamFormation,
            self.summonerClass,
            self.summonerStar,
            level,
            Dictionary(),
            BattleConstants.ATTACKER_TEAM_ID,
            Dictionary(),
            List(),
            self.isDummySummoner)
    return battleTeamInfo
end