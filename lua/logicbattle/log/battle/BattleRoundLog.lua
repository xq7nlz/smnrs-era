--- @class BattleRoundLog
BattleRoundLog = Class(BattleRoundLog)

--- @return void
--- @param round number
function BattleRoundLog:Ctor(round)
    --- @type number
    self.roundNumber = round

    --- @type List<BattleTurnLog>
    --- turns of this round
    self.battleTurnLogs = List()

    --- @type List<BaseActionResult>
    self.beforeRoundResults = List()
    --- @type List<BaseActionResult>
    self.afterRoundResults = List()

    --- @type BattleTeamLog
    self.attackerTeamLog = BattleTeamLog(BattleConstants.ATTACKER_TEAM_ID)
    --- @type BattleTeamLog
    self.defenderTeamLog = BattleTeamLog(BattleConstants.DEFENDER_TEAM_ID)
end

--- @return void
--- @param battleTurnLog BattleTurnLog
function BattleRoundLog:AddBattleTurnLog(battleTurnLog)
    self.battleTurnLogs:Add(battleTurnLog)
end

---------------------------------------- Before round ----------------------------------------
--- @return void
--- @param result BaseActionResult
function BattleRoundLog:AddBeforeRoundResult(result)
    self.beforeRoundResults:Add(result)
end

---------------------------------------- After round ----------------------------------------
--- @return void
--- @param result BaseActionResult
function BattleRoundLog:AddAfterRoundResult(result)
    self.afterRoundResults:Add(result)
end

--- @return List<BaseActionResult>
function BattleRoundLog:GetAfterRoundResultData()
    local data = {}
    for i = 1, self.afterRoundResults:Count() do
        --- @type BaseActionResult
        local resultLog = self.afterRoundResults:Get(i)
        data[i] = resultLog:GetData()
    end

    return data
end

--- @return BattleRoundLog
function BattleRoundLog:GetData()
    local data = {}
    data.roundNumber = self.roundNumber
    data.battleTurnLogs = self.battleTurnLogs:GetData()
    data.beforeRoundResults = self.beforeRoundResults:GetData()
    data.afterRoundResults = self.afterRoundResults:GetData()

    return data
end

---------------------------------------- ToString ----------------------------------------
--- @return string
--- @param runMode RunMode
function BattleRoundLog:ToString(runMode)
    local result = string.format("\nROUND %s\n", self.roundNumber)
    result = result .. "****************************************************************************************************************************************************************\n"

    if self.beforeRoundResults:Count() > 0 then
        result = result .. string.format("\n---------- BEFORE ROUND %s ----------\n", self.roundNumber)
        for i = 1, self.beforeRoundResults:Count() do
            local log = self.beforeRoundResults:Get(i)
            result = result .. log:ToString() .. "\n"
        end
    end

    for i = 1, self.battleTurnLogs:Count() do
        local log = self.battleTurnLogs:Get(i)
        result = result .. log:ToString(runMode)
    end

    if self.afterRoundResults:Count() > 0 then
        result = result .. string.format("\n---------- AFTER ROUND %s ----------\n", self.roundNumber)
        for i = 1, self.afterRoundResults:Count() do
            local log = self.afterRoundResults:Get(i)
            result = result .. log:ToString() .. "\n"
        end
    end

    return result
end