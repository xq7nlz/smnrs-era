--- @class BattleRound
BattleRound = Class(BattleRound)

--- @return void
--- @param round number
--- @param battle Battle
function BattleRound:Ctor(round, battle)
    --- @type number
    self.round = round

    --- @type BattleTeam
    self.attackerTeam = battle:GetAttackerTeam()
    --- @type BattleTeam
    self.defenderTeam = battle:GetDefenderTeam()

    --- @type number
    self.numberTurn = 1
    --- @type BattleTurn
    self.battleTurn = nil

    --- @type List<BaseHero>
    self._activeHeroes = List()
    self:AddTeam(self.attackerTeam)
    self:AddTeam(self.defenderTeam)

    --- @type BattleRoundLog
    self.battleRoundLog = BattleRoundLog(round)

    --- @type boolean each round, if speed is equal, always prioritize attacker team
    self._isPreferAttackerTeam = true

    --- @type BaseHero
    self._activeHero = nil
end

--- @return void
--- @param team BattleTeam
function BattleRound:AddTeam(team)
    for i = 1, team.heroList:Count() do
        local hero = team.heroList:Get(i)
        self._activeHeroes:Add(hero)
    end

    local attackerSummoner = self.attackerTeam:GetSummoner()
    attackerSummoner.canPlay = true

    local defenderSummoner = self.defenderTeam:GetSummoner()
    defenderSummoner.canPlay = true
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param battle Battle
function BattleRound:OnStartBattleRound(battle)
    battle:SetBattlePhase(BattlePhase.BEFORE_ROUND)

    self.attackerTeam:OnStartBattleRound(self)
    self.defenderTeam:OnStartBattleRound(self)
    battle.eventManager:TriggerQueuedEvent()

    self.attackerTeam:UpdateBeforeRound(self)
    self.defenderTeam:UpdateBeforeRound(self)
    battle.eventManager:TriggerQueuedEvent()

    self.battleRoundLog.attackerTeamLog:SetTeamBefore(self.attackerTeam)
    self.battleRoundLog.defenderTeamLog:SetTeamBefore(self.defenderTeam)
end

--- @return void
--- @param battle Battle
function BattleRound:OnEndBattleRound(battle)
    battle:SetBattlePhase(BattlePhase.AFTER_ROUND)

    self.attackerTeam:OnEndBattleRound(self)
    self.defenderTeam:OnEndBattleRound(self)
    battle.eventManager:TriggerQueuedEvent()

    self.attackerTeam:UpdateAfterRound(self)
    self.defenderTeam:UpdateAfterRound(self)
    battle.eventManager:TriggerQueuedEvent()

    self.battleRoundLog.attackerTeamLog:SetTeamAfter(self.attackerTeam)
    self.battleRoundLog.defenderTeamLog:SetTeamAfter(self.defenderTeam)
end

--- @return boolean battle should be ended or not
--- @param battle Battle
function BattleRound:Resolve(battle)
    --local startRound = os.clock()
    --print(string.format("[ROUND %s]", self.round))

    battle:SetBattlePhase(BattlePhase.RESOLVE_ROUND)
    local attacker = self.attackerTeam
    local defender = self.defenderTeam

    while self._activeHeroes:Count() > 0 do
        --local startTurn = os.clock()

        --print(string.format("TURN: %s (Round %s)", self.numberTurn, self.round))
        if attacker:IsAllDead() or defender:IsAllDead() then
            return true
        end

        if self._activeHero == nil or self._activeHero:CanPlay() == false then
            self._activeHero = self:_GetActiveHeroForThisTurn(battle, self._activeHeroes)
            if self._activeHero == nil then
                break
            end
        end
        --print("Hero " .. self._activeHero:ToString())

        local isEndTurn = self:_UpdateTurnWithHero(battle, self._activeHero)
        if isEndTurn == true then
            self._activeHeroes:RemoveOneByReference(self._activeHero)
            self._activeHero = nil
        end
        --print(string.format("\t[TURN %s] Elapsed time: %.0fms", self.numberTurn, (os.clock() - startTurn) * 1000))
        self.numberTurn = self.numberTurn + 1
    end

    if attacker:IsAllDead() or defender:IsAllDead() then
        --print(string.format("[ROUND %s] Elapsed time: %.0fms", self.round, (os.clock() - startRound) * 1000))
        return true
    end

    --print(string.format("[ROUND %s] Elapsed time: %.0fms\n", self.round, (os.clock() - startRound) * 1000))
    return false
end

---------------------------------------- Helpers ----------------------------------------
--- @return boolean
--- @param battle Battle
--- @param hero BaseHero
function BattleRound:_UpdateTurnWithHero(battle, hero)
    battle.numberTurn = battle.numberTurn + 1

    battle.bondManager:UpdatePerTurn()
    local turn = BattleTurn(self.round, self.numberTurn, hero)
    self.battleTurn = turn

    turn:OnStartBattleTurn(battle, hero)

    local battleTurnLog, isEndTurn = turn:Resolve(hero)
    self.battleRoundLog:AddBattleTurnLog(battleTurnLog)

    turn:OnEndBattleTurn(battle, hero)
    return isEndTurn
end

--- @return BaseHero
--- @param battle Battle
--- @param heroes List<BaseHero>
function BattleRound:_GetActiveHeroForThisTurn(battle, heroes)
    ---@type BaseSummoner
    local attackerSummoner = self.attackerTeam:GetSummoner()
    if attackerSummoner:IsDummy() == false and attackerSummoner.power:IsMax() and attackerSummoner.canPlay == true then
        attackerSummoner.canPlay = false
        return attackerSummoner
    end
    ---@type BaseSummoner
    local defenderSummoner = self.defenderTeam:GetSummoner()
    if defenderSummoner:IsDummy() == false and defenderSummoner.power:IsMax() and defenderSummoner.canPlay == true then
        defenderSummoner.canPlay = false
        return defenderSummoner
    end

    local highestSpeedHeroes = List()
    local tempHero

    local i = 1
    while i <= heroes:Count() do
        ---@type BaseHero
        local hero = heroes:Get(i)
        if hero:CanPlay() then
            if tempHero == nil then
                highestSpeedHeroes:Add(hero)
                tempHero = hero
            else
                if hero.speed:GetValue() > tempHero.speed:GetValue() then
                    highestSpeedHeroes:Clear()
                    highestSpeedHeroes:Add(hero)

                    tempHero = hero
                elseif hero.speed:GetValue() == tempHero.speed:GetValue() then
                    highestSpeedHeroes:Add(hero)
                end
            end
        end
        i = i + 1
    end

    local result
    if highestSpeedHeroes:Count() > 1 then
        --- Prefer attacker team (for first time per round)
        if self._isPreferAttackerTeam == true then
            i = 1
            while i <= highestSpeedHeroes:Count() do
                ---@type BaseHero
                local hero = highestSpeedHeroes:Get(i)
                if hero:IsSameTeam(BattleConstants.ATTACKER_TEAM_ID) then
                    self._isPreferAttackerTeam = false
                    return hero
                end
                i = i + 1
            end
        end

        local randomIndex = battle._randomHelper:RandomMax(highestSpeedHeroes:Count())
        result = highestSpeedHeroes:Get(randomIndex)
    elseif highestSpeedHeroes:Count() == 1 then
        result = highestSpeedHeroes:Get(1)
    end

    return result
end