require "lua.client.utils.ClientActionResultUtils"
require "lua.client.battleShow.LogDetail.ClientTeamDetail"

require "lua.client.battleShow.LogDetail.ClientEffectLogDetailBuilder"

require "lua.client.battleShow.LogDetail.ClientTurnDetail"
require "lua.client.battleShow.LogDetail.ActionDetail.ClientActionDetailBuilder"

--- @class ClientLogDetail
ClientLogDetail = Class(ClientLogDetail)

--- @return void
--- @param battle Battle
--- @param battleResult BattleResult
function ClientLogDetail:Ctor(battle, battleResult)
    if battle == nil or battleResult == nil then
        assert(false, "data is not valid")
    end

    --- @type Battle
    self.battle = battle
    --- @type RunMode
    self.runMode = battle.runMode
    --- @type ClientTeamDetail
    self.attackerTeam = nil
    --- @type ClientTeamDetail
    self.defenderTeam = nil

    --- @type ClientTurnDetail[] List
    self.turnDetailList = List()

    --- @type number
    self.winnerTeam = nil

    --- @type number
    self.numberRounds = nil

    --- @type number
    self.currentRound = nil
    --- @type number`
    self.currentTurn = nil

    --- @type List<HeroStatusLog>
    self.beforeAttackerTeamLog = List()
    --- @type List<HeroStatusLog>
    self.beforeDefenderTeamLog = List()
    self:InitTeam(battle)
    self:CreateLog(battleResult)
    self:InitStartBattleLog(battleResult)
end

--- @return void
--- @param battleResult BattleResult
function ClientLogDetail:CreateLog(battleResult)
    self.numberRounds = battleResult.numberRounds
    self.winnerTeam = battleResult.winnerTeam
    local summonerActionResults = self:FilterSummonerActionResult(battleResult.startBattleLogs)
    self.currentRound = 0
    self:CreateLogFromBeforeRounds(summonerActionResults)

    --- @param roundLog BattleRoundLog
    for _, roundLog in ipairs(battleResult.battleRoundLogs) do
        self.currentRound = roundLog.roundNumber
        self:CreateLogFromBeforeRounds(roundLog.beforeRoundResults)
        self:CreateLogFromBattleLogTurns(roundLog.battleTurnLogs)
        self:CreateLogFromAfterRounds(roundLog.afterRoundResults)
    end
end

--- @return void
--- @param beforeRoundResults BaseActionResult[] List
function ClientLogDetail:CreateLogFromBeforeRounds(beforeRoundResults)
    self.currentTurn = 0
    self:CreateLogFromActions(ActionType.NOTHING, beforeRoundResults)
end

--- @return void
--- @param battleTurnLogs List<BattleTurnLog>
function ClientLogDetail:CreateLogFromBattleLogTurns(battleTurnLogs)
    if battleTurnLogs == nil then
        return
    end

    --- @param turnLog BattleTurnLog
    for _, turnLog in ipairs(battleTurnLogs) do
        --- @type BattleTurnLog
        self.currentTurn = turnLog.turn

        self:CreateLogFromActions(turnLog.actionType, turnLog.actionResults)
    end
end

--- @return void
--- @param afterRoundResults List<BaseActionResult>
function ClientLogDetail:CreateLogFromAfterRounds(afterRoundResults)
    self.currentTurn = 0
    self:CreateLogFromActions(ActionType.NOTHING, afterRoundResults)
end

--- @return void
--- @param actionType ActionType
--- @param actionResults List<BaseActionResult>
function ClientLogDetail:CreateLogFromActions(actionType, actionResults)
    if actionResults == nil then
        return
    end
    --- @param action BaseActionResult
    for _, action in ipairs(actionResults) do
        if action._i then
            action.initiator = ClientBattleData.battle:GetHeroByUniqueId(action._i)
        end

        if action._t then
            action.target = ClientBattleData.battle:GetHeroByUniqueId(action._t)
        end

        if action._thp then
            action.targetHpPercent = action._thp
        end

        if action._ipp then
            action.initiatorPowerPercent = action._ipp
        end

        if action._tpp then
            action.targetPowerPercent = action._tpp
        end

        if action._ect then
            action.effectChangeType = action._ect
        end

        if action._elt then
            action.effectLogType = action._elt
        end

        if action._pt then
            action.persistentType = action._pt
        end
    end

    local listOfListTurn = self:SeparateActions(actionResults)
    for i = 1, listOfListTurn:Count() do
        --- @type List
        local listActionResults = listOfListTurn:Get(i)
        local actionDict = Dictionary()
        for j = 1, listActionResults:Count() do
            --- @type BaseActionResult
            local action = listActionResults:Get(j)
            action.index = j
            self:SetClientActionDetail(action, actionDict)
        end

        --- @type List<BaseActionResult>
        local actionList = List()
        --- @param value ClientActionDetail
        for _, value in pairs(actionDict:GetItems()) do
            value:Execute()
            actionList:AddAll(value:GetItems())
            if value.type == ActionResultType.CHANGE_EFFECT then
                actionList:AddAll(value:GetCCItems())
            end
        end
        if actionList:Count() > 0 then
            self:AddTurn(actionType, actionList)
        end
    end
end

--- @return List<List<BaseActionResult>>
--- @param actionResults List<BaseActionResult>
function ClientLogDetail:SeparateActions(actionResults)
    local turnList = List()
    local actionTurnList = List()
    local rebornTurnList = List()
    local deadForDisplayList = List()

    --- @type number
    local numberBouncing
    --- @type List
    local listBouncingResult

    --- @param action BaseActionResult
    for _, action in ipairs(actionResults) do
        if action.target.id < 1000 and action.type ~= 92 then
            XDebug.Log("Action: " .. action.target.id .. " => " .. action.type)
        end
        --- @type ActionResultType
        local actionResultType = action.type

        --- @type BaseActionResult
        local firstAction
        if actionTurnList:Count() > 0 then
            firstAction = actionTurnList:Get(1)
        end

        if actionResultType == ActionResultType.DEAD_FOR_DISPLAY then
            deadForDisplayList:Add(action)
        end

        local AddBouncingToTurnList = function()
            if listBouncingResult ~= nil and listBouncingResult:Count() > 0 then
                turnList:Add(listBouncingResult)
                listBouncingResult = List()
            end
            numberBouncing = nil
        end

        if ClientActionResultUtils.IsRegenerate(actionResultType) then
            AddBouncingToTurnList()

            if action.isTransform then
                rebornTurnList:Add(action)
                if firstAction ~= nil and ClientActionResultUtils.IsKeepAliveAnim(firstAction.type) == false then

                    turnList:Add(actionTurnList)
                    actionTurnList = List()
                end
            end
            actionTurnList:Add(action)
        elseif ClientActionResultUtils.IsKeepAliveAnim(actionResultType) then
            rebornTurnList:Add(action)
            if firstAction ~= nil and ClientActionResultUtils.IsKeepAliveAnim(firstAction.type) == false then
                turnList:Add(actionTurnList)
                actionTurnList = List()
            end
            actionTurnList:Add(action)
        elseif ClientActionResultUtils.IsIndependentTurn(actionResultType) then
            AddBouncingToTurnList()

            if actionTurnList:Count() > 0 then
                turnList:Add(actionTurnList)
                actionTurnList = List()
            end
            actionTurnList:Add(action)
        elseif actionResultType == ActionResultType.BOUNCING_DAMAGE then
            local number = action.numberBouncing
            if numberBouncing == nil then
                if actionTurnList:Count() > 0 then
                    turnList:Add(actionTurnList)
                    actionTurnList = List()
                end
                listBouncingResult = List()
                numberBouncing = 1
                listBouncingResult:Add(action)
                --print("Create Bouncing")
            elseif numberBouncing ~= number then
                if listBouncingResult ~= nil and listBouncingResult:Count() > 0 then
                    turnList:Add(listBouncingResult)
                    listBouncingResult = List()
                end
                numberBouncing = number
                listBouncingResult:Add(action)
                --print("Create More Bouncing")
            else
                listBouncingResult:Add(action)
                --print("Add More Bouncing")
            end
        elseif ClientActionResultUtils.IsMergerTurn(actionResultType) then
            if firstAction ~= nil and firstAction.type ~= actionResultType then
                turnList:Add(actionTurnList)
                actionTurnList = List()
            end
            actionTurnList:Add(action)
        elseif numberBouncing ~= nil then
            listBouncingResult:Add(action)
        else
            actionTurnList:Add(action)
        end
    end

    if listBouncingResult ~= nil and listBouncingResult:Count() > 0 then
        turnList:Add(listBouncingResult)
    end
    if actionTurnList:Count() > 0 then
        turnList:Add(actionTurnList)
    end

    if rebornTurnList:Count() > 0 then
        for _, actionDeadForDisplay in ipairs(deadForDisplayList:GetItems()) do
            for _, actionReborn in ipairs(rebornTurnList:GetItems()) do
                if actionDeadForDisplay.target == actionReborn.target then
                    actionDeadForDisplay.isReviveSoon = true
                end
            end
            --- remove effect
            local hero = actionDeadForDisplay.target
            local team = self:GetTeam(hero.teamId)
            team.heroEffectDict:RemoveByKey(hero)
        end
    end

    return turnList
end

--- @return void
--- @param baseActionResult BaseActionResult
--- @param actionDict Dictionary -- ClientActionDetail
function ClientLogDetail:SetClientActionDetail(baseActionResult, actionDict)
    local actionResultType = baseActionResult.type
    --- @type ClientActionDetail
    local clientActionDetail = actionDict:Get(actionResultType)
    if clientActionDetail == nil then
        clientActionDetail = ClientActionDetailBuilder.Create(actionResultType)
        actionDict:Add(actionResultType, clientActionDetail)
        clientActionDetail:Add(baseActionResult)
    else
        local otherActionDetail = ClientActionDetailBuilder.Create(actionResultType)
        otherActionDetail:OverloadAction(clientActionDetail)
        otherActionDetail:Add(baseActionResult)
        actionDict:Add(actionResultType, otherActionDetail)
    end
end

--- @return void
--- @param actionType ActionType
--- @param actionList List<BaseActionResult>
function ClientLogDetail:AddTurn(actionType, actionList)
    local clientTurn = self.turnDetailList:Count() + 1
    --- @type ClientTurnDetail
    local clientTurnDetail = ClientTurnDetail(self, clientTurn, self.currentRound, self.currentTurn)
    clientTurnDetail:SetData(actionType, actionList)
    if self.turnDetailList:Count() > 0 then
        --- @type ClientTurnDetail
        local preTurnDetail = self.turnDetailList:Get(self.turnDetailList:Count())

        if ClientActionResultUtils.IsAttackMultiTimes(clientTurnDetail.actionType) then
            if preTurnDetail.actionType == ClientActionType.BASIC_ATTACK
                    or preTurnDetail.actionType == ClientActionType.USE_SKILL then
                preTurnDetail:SetExtraTurnInfo(preTurnDetail.actionType)
            end
            clientTurnDetail:SetExtraTurnInfo(preTurnDetail.extraTurnInfo.clientActionType,preTurnDetail.extraTurnInfo.numberBonusTurn)
        elseif ClientActionResultUtils.IsAttackMultiTimes(preTurnDetail.actionType) then
            local prepreTurnDetail = self.turnDetailList:Get(self.turnDetailList:Count() - 1)
            preTurnDetail:SetExtraTurnInfo(prepreTurnDetail.extraTurnInfo.clientActionType, 0)
        end
    end

    self.turnDetailList:Add(clientTurnDetail)
end

--- @return void
--- @param battle Battle
function ClientLogDetail:InitTeam(battle)
    self.attackerTeam = ClientTeamDetail(battle:GetAttackerTeam())
    self.defenderTeam = ClientTeamDetail(battle:GetDefenderTeam())
end

--- @return ClientTeamDetail
--- @param teamId number
function ClientLogDetail:GetTeam(teamId)
    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        return self.attackerTeam
    else
        return self.defenderTeam
    end
end

--- @param battleResult BattleResult
function ClientLogDetail:InitStartBattleLog(battleResult)
    self.beforeAttackerTeamLog = battleResult.attackerTeamLog.beforeLogs
    self.beforeDefenderTeamLog = battleResult.defenderTeamLog.beforeLogs
end

--- @return string
function ClientLogDetail:ToString()
    local content = "__________________ START LOG ___________________\n"
    content = content .. "[ATTACKER TEAM]\n" .. self.attackerTeam:ToString()
    content = content .. "[DEFENDER TEAM]\n" .. self.defenderTeam:ToString()

    --content = content .. "____ START TURN ____\n"
    for i = 1, self.turnDetailList:Count() do
        content = content .. self.turnDetailList:Get(i):ToString()
    end
    return content
end

--- @param actionResults List<BaseActionResult>
function ClientLogDetail:FilterSummonerActionResult(actionResults)
    local filteredList = List()
    if actionResults then
        --- @param v EffectChangeResult
        for _, v in pairs(actionResults) do
            if v.type == ActionResultType.CHANGE_EFFECT then
                if ClientActionResultUtils.IsEffectHasMark(v.effectLogType) then
                    filteredList:Add(v)
                end
            end
        end
    end
    
    return filteredList
end