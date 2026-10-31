--- @class BattleTurn
BattleTurn = Class(BattleTurn)

--- @return void
--- @param round number
--- @param turn number
--- @param hero BaseHero
function BattleTurn:Ctor(round, turn, hero)
    --- @type number
    self.turn = turn

    --- @type ActionType
    self.actionType = hero:GetActionType()

    --- @type BattleTurnLog
    self.battleTurnLog = BattleTurnLog(round, turn, hero, self.actionType)

    -- @type number
    self.myHero = hero
end

--- @return void
--- @param battle Battle
function BattleTurn:OnStartBattleTurn(battle)
    self.myHero.battleListener:OnStartBattleTurn(self)
    battle.eventManager:TriggerQueuedEvent()

    self.battleTurnLog.attackerTeamLog:SetTeamBefore(battle:GetAttackerTeam())
    self.battleTurnLog.defenderTeamLog:SetTeamBefore(battle:GetDefenderTeam())
end

--- @return void
--- @param battle Battle
function BattleTurn:OnEndBattleTurn(battle)
    self.myHero.battleListener:OnEndBattleTurn(self)
    battle.eventManager:TriggerQueuedEvent()

    self.battleTurnLog.attackerTeamLog:SetTeamAfter(battle:GetAttackerTeam())
    self.battleTurnLog.defenderTeamLog:SetTeamAfter(battle:GetDefenderTeam())
end

--- @return BattleTurnLog, boolean should end turn or not
function BattleTurn:Resolve()
    local actionResults, isEndTurn = self.myHero:DoAction(self.actionType)
    if actionResults:Count() == 0 then
        self.battleTurnLog:SetActionType(ActionType.NOTHING)
    end

    return self.battleTurnLog, isEndTurn
end