
--- @class ClientExtraTurnInfo
ClientExtraTurnInfo = Class(ClientExtraTurnInfo)

--- @return void
--- @param clientActionType ClientActionType
function ClientExtraTurnInfo:Ctor(clientActionType, numberBonusTurn)
    if numberBonusTurn ~= nil then
        self.numberBonusTurn = numberBonusTurn
    else
        self.numberBonusTurn = 1
    end

    self.clientActionType = clientActionType
end

--- @return string
function ClientExtraTurnInfo:ToString()
    return string.format(", EXTRA: (turn: %s, type: %s)", self.numberBonusTurn, self.clientActionType)
end