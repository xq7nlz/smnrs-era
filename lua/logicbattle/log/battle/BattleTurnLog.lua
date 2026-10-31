--- @class BattleTurnLog
BattleTurnLog = Class(BattleTurnLog)

--- @return void
--- @param round number
--- @param turn number
--- @param actionType ActionType
function BattleTurnLog:Ctor(round, turn, initiator, actionType)
    --- @type number
    self.round = round

    --- @type number
    self.turn = turn

    --- @type BaseHero
    self.initiator = initiator

    --- @type ActionType
    self.actionType = actionType

    --- @type List<BaseActionResult>
    self.actionResults = List()

    --- @type BattleTeamLog
    self.attackerTeamLog = BattleTeamLog(BattleConstants.ATTACKER_TEAM_ID)
    --- @type BattleTeamLog
    self.defenderTeamLog = BattleTeamLog(BattleConstants.DEFENDER_TEAM_ID)
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param actionType ActionType
function BattleTurnLog:SetActionType(actionType)
    self.actionType = actionType
end

---------------------------------------- Add Log ----------------------------------------
--- @return void
--- @param result BaseActionResult
function BattleTurnLog:AddResult(result)
    self.actionResults:Add(result)
end

--- @return BattleTurnLog
function BattleTurnLog:GetData()
    local data = {}

    data.round = self.round
    data.turn = self.turn
    data.initiator = self.initiator:GetHeroUnique()
    data.actionType = self.actionType
    data.actionResults = self.actionResults:GetData()
    return data
end

---------------------------------------- ToString ----------------------------------------
--- @return string
--- @param runMode RunMode
function BattleTurnLog:ToString(runMode)
    local result = string.format("\nTURN %s (ROUND %s)\n", self.turn, self.round)
    result = result .. "--------------------------------------------------------------------------------\n"

    result = result .. string.format("<> INITIATOR %s, actionType = %s\n",
            self.initiator:ToString(), tostring(self.actionType))

    for i = 1, self.actionResults:Count() do
        local log = self.actionResults:Get(i)
        result = result .. log:ToString().. "\n"
    end

    --- team status log
    result = result .. self.attackerTeamLog:ToStringBefore(runMode)
    result = result .. self.defenderTeamLog:ToStringBefore(runMode)
    result = result .. "--------------------------------------------------------------------------------\n"
    result = result .. self.attackerTeamLog:ToStringAfter(runMode)
    result = result .. self.defenderTeamLog:ToStringAfter(runMode)

    return result
end