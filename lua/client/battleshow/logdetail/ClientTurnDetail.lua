require "lua.client.battleShow.LogDetail.ClientExtraTurnInfo"

--- @class ClientTurnDetail
ClientTurnDetail = Class(ClientTurnDetail)

--- @return void
--- @param clientLogDetail ClientLogDetail
--- @param clientTurn number
--- @param serverRound number
--- @param serverTurn number
function ClientTurnDetail:Ctor(clientLogDetail, clientTurn, serverRound, serverTurn)
    --- @type ClientLogDetail
    self.clientLogDetail = clientLogDetail
    --- @type number
    self.clientTurn = clientTurn
    --- @type number
    self.serverRound = serverRound
    --- @type number
    self.serverTurn = serverTurn
    --- @type ClientExtraTurnInfo
    self.extraTurnInfo = nil

    --- @type BaseHero
    self.initiator = nil
    --- @type ClientActionType
    self.actionType = nil
    --- @type List<BaseActionResult>
    self.actionList = nil
    --- @type Dictionary<BaseHero, number>
    self.hpPercentDict = Dictionary()
    --- @type Dictionary<BaseHero, number>
    self.powerPercentDict = Dictionary()
    --- @type Dictionary<BaseHero, ClientEffectLogDetail>
    self.effectIconDict = Dictionary()
    --- @type List<BaseActionResult>
    self.effectCCList = List()
end

--- @return void
--- @param actionType ActionType
--- @param actionList List<BaseActionResult>
function ClientTurnDetail:SetData(actionType, actionList)
    self.actionList = actionList

    self:SetEffect(self.actionList)

    self:SortActionList()

    self:SetActionType(actionType, self.actionList)

    self:SetHpPercent(self.actionList)
    self:SetPowerPercent(self.actionList)
end

--- @return void
--- @param actionType ClientActionType
--- @param actionList List<BaseActionResult>
function ClientTurnDetail:SetActionType(actionType, actionList)
    if actionList:Count() > 0 then
        local firstAction = actionList:Get(1)

        if actionType == ActionType.NOTHING then
            if ClientActionResultUtils.IsRegenerate(firstAction.type) then
                if firstAction.isTransform then
                    self.actionType = ClientActionType.REBORN
                else
                    self.actionType = ClientActionType.NOTHING
                end
            elseif ClientActionResultUtils.IsKeepAliveAnim(firstAction.type) then
                self.actionType = ClientActionType.REBORN
            else
                self.actionType = ClientActionType.NOTHING
            end
        else
            if ClientActionResultUtils.IsRegenerate(firstAction.type) then
                self.actionType = ClientActionType.NOTHING
            elseif ClientActionResultUtils.IsKeepAliveAnim(firstAction.type) then
                self.actionType = ClientActionType.NOTHING
            else
                if firstAction.type == ActionResultType.COUNTER_ATTACK then
                    self.actionType = ClientActionType.COUNTER_ATTACK
                elseif firstAction.type == ActionResultType.BONUS_ATTACK then
                    self.actionType = ClientActionType.BONUS_ATTACK
                elseif firstAction.type == ActionResultType.BOUNCING_DAMAGE then
                    self.actionType = ClientActionType.BOUNCING_DAMAGE
                elseif firstAction.type == ActionResultType.DEAD then
                    self.actionType = ClientActionType.NOTHING
                else
                    self.actionType = actionType
                end
                self.initiator = firstAction.initiator
            end
        end
    else
        self.actionType = ClientActionType.NOTHING
    end
end

--- {index, value}
--- @return void
--- @param actionList List<BaseActionResult>
function ClientTurnDetail:SetHpPercent(actionList)
    local tempDict = Dictionary()

    for i = 1, actionList:Count() do
        local action = actionList:Get(i)
        if ClientActionResultUtils.IsChangeEffect(action.type) == false then
            if tempDict:IsContainKey(action.target) then
                local tempAction = tempDict:Get(action.target)
                if tempAction.index < action.index then
                    tempDict:Add(action.target, action)
                end
            else
                tempDict:Add(action.target, action)
            end
        end
    end

    for key, value in pairs(tempDict:GetItems()) do
        self.hpPercentDict:Add(key, value.targetHpPercent)
    end
end

--- {index, value}
--- @return void
--- @param actionList List<BaseActionResult>
function ClientTurnDetail:SetPowerPercent(actionList)
    local tempDict = Dictionary()
    local changePowerList = List()

    for i = 1, actionList:Count() do
        local action = actionList:Get(i)
        if ClientActionResultUtils.IsChangePower(action.type) then
            if tempDict:IsContainKey(action.target) then
                local tempAction = tempDict:Get(action.target)
                if tempAction.index < action.index then
                    tempDict:Add(action.target, action)
                    tempDict:Add(action.initiator, action)
                end
            else
                tempDict:Add(action.target, action)
                tempDict:Add(action.initiator, action)
            end

            if action.type == ActionResultType.CHANGE_POWER then
                changePowerList:Add(action)
            end
        end
    end

    for key, value in pairs(tempDict:GetItems()) do
        if key == value.target then
            self.powerPercentDict:Add(key, value.targetPowerPercent)
        elseif key == value.initiator then
            self.powerPercentDict:Add(key, value.initiatorPowerPercent)
        else
            XDebug.Error("SOMETHING WAS WRONG HERE")
        end
    end

    for key, value in pairs(changePowerList:GetItems()) do
        actionList:RemoveByReference(value)
    end
end

--- {index, value}
--- @return void
--- @param actionList List<BaseActionResult>
function ClientTurnDetail:SetEffect(actionList)
    for i = 1, actionList:Count() do
        --- @type BaseActionResult
        local action = actionList:Get(i)
        if action.type == ActionResultType.CHANGE_EFFECT then
            if action.effectLogType == nil then
                if self.effectIconDict:IsContainKey(action.target) then
                    assert(false, "SOMETHING IS WRONG HERE")
                else
                    --- @type BaseHero
                    local target = action.target
                    if target.teamId == BattleConstants.ATTACKER_TEAM_ID then
                        self.clientLogDetail.attackerTeam:SetEffectAndGetDifferent(action)
                    else
                        self.clientLogDetail.defenderTeam:SetEffectAndGetDifferent(action)
                    end
                    self.effectIconDict:Add(target, action)
                end
            elseif ClientActionResultUtils.IsEffectCC(action.effectLogType) then
                self.effectCCList:Add(action)
            end
        end
    end
    for _, value in pairs(self.effectIconDict:GetItems()) do
        actionList:RemoveByReference(value)
    end
    for _, value in pairs(self.effectCCList:GetItems()) do
        actionList:RemoveByReference(value)
    end
end

--- @return void
--- @param clientActionType ClientActionType
function ClientTurnDetail:SetExtraTurnInfo(clientActionType, numberBonusAttack)
    self.extraTurnInfo = ClientExtraTurnInfo(clientActionType, numberBonusAttack)
end

--- @return void
function ClientTurnDetail:SortActionList()
    self.actionList:Sort(self, self.ActionComparator)
    self.effectCCList:Sort(self, self.ActionComparator)
end

--- @return void
--- @param action1 BaseActionResult
--- @param action2 BaseActionResult
function ClientTurnDetail:ActionComparator(action1, action2)
    if action1.index > action2.index then
        return 1
    else
        return -1
    end
end

--- @return string
function ClientTurnDetail:ToString()
    local hero = "nil"
    if self.initiator ~= nil then
        hero = self.initiator:ToString()
    end

    local extraInfo = ""
    if self.extraTurnInfo ~= nil then
        extraInfo = self.extraTurnInfo:ToString()
    end

    local content = string.format("\n\n------------------------------------ TURN %s ------------------------------------\n", self.clientTurn) ..
            string.format("[ACTION_TYPE: %s, SERVER_ROUND: %s, SERVER_TURN: %s%s] %s\n",
                    self.actionType, self.serverRound, self.serverTurn, extraInfo, hero)

    if self.actionList:Count() > 0 then
        content = content .. "1. [ACTION]\n       "
        for i = 1, self.actionList:Count() do
            content = content .. self.actionList:Get(i):ToString() .. "       "
        end
    end

    if self.hpPercentDict:Count() > 0 then
        content = content .. "\n2. [HP]\n       "
        for key, value in pairs(self.hpPercentDict:GetItems()) do
            content = content .. key:ToString() .. " => " .. MathUtils.RoundDecimal(value) .. "\n       "
        end
    end

    if self.powerPercentDict:Count() > 0 then
        content = content .. "\n3. [POWER]\n       "
        for key, value in pairs(self.powerPercentDict:GetItems()) do
            content = content .. key:ToString() .. " => " .. value .. "\n       "
        end
    end

    if self.effectIconDict:Count() > 0 then
        content = content .. "\n4. [EFFECT - ICON]\n       "
        for key, value in pairs(self.effectIconDict:GetItems()) do
            content = content .. value:ToString() .. "       "
        end
    end

    if self.effectCCList:Count() > 0 then
        content = content .. "\n5. [EFFECT - CC]\n       "
        for key, value in pairs(self.effectCCList:GetItems()) do
            content = content .. value:ToString() .. "       "
        end
    end

    return content
end