require "lua.client.core.network.playerData.domain.CrewBattleTeamOutBound"
--- @class EventAiryuuTrialOutBound : OutBound
EventAiryuuTrialOutBound = Class(EventAiryuuTrialOutBound, OutBound)

--- @return void
--- @param difficulty number
--- @param uiFormationTeamData CrewBattleTeamOutBound
function EventAiryuuTrialOutBound:Ctor(difficulty, uiFormationTeamData)
    self.difficulty = difficulty
    self.team = BattleFormationOutBound(uiFormationTeamData)
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function EventAiryuuTrialOutBound:Serialize(buffer)
    buffer:PutInt(self.difficulty)
    self.team:Serialize(buffer)
end