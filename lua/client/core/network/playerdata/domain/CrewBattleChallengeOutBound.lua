require "lua.client.core.network.playerData.domain.CrewBattleTeamOutBound"
require "lua.client.core.network.playerData.domain.CrewBattleHeroOutBound"

--- @class CrewBattleChallengeOutBound : OutBound
CrewBattleChallengeOutBound = Class(CrewBattleChallengeOutBound, OutBound)

function CrewBattleChallengeOutBound:Ctor()
    --- @type number
    self.stage = nil
    --- @type CrewBattleTeamOutBound
    self.crewBattleTeamOutBound = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function CrewBattleChallengeOutBound:Serialize(buffer)
    self.crewBattleTeamOutBound:Serialize(buffer)
    buffer:PutInt(self.stage)
end

--- @param uiFormationTeamData UIFormationTeamData
function CrewBattleChallengeOutBound:SetFormationTeamData(stage, uiFormationTeamData)
    self.stage = stage
    self.crewBattleTeamOutBound = CrewBattleTeamOutBound()
    self.crewBattleTeamOutBound:SetFormationTeamData(uiFormationTeamData)
end