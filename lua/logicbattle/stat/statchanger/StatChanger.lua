--- @class StatChanger
StatChanger = Class(StatChanger)

--- @return void
--- @param isBuff boolean
function StatChanger:Ctor(isBuff)
    --- @type boolean
    self.isBuff = isBuff

    --- @type StatType
    self.statAffectedType = nil

    --- @type StatChangerCalculationType
    self.calculationType = nil

    --- @type number amount to change stat
    self.amount = nil

    --- @type number
    self.amountMultiplier = 1

    --- @type StatChangerType
    self.type = StatChangerType.BONUS_IN_GAME
end

---------------------------------------- Getters ----------------------------------------
--- @return number
function StatChanger:GetAmount()
    return MathUtils.Truncate(self.amount * self.amountMultiplier)
end

--- @return number
--- @param value number
--- @param statValueType StatValueType
function StatChanger:CalculateAmount(value, statValueType)
    if self.calculationType == StatChangerCalculationType.RAW_ADD_BASE or
            self.calculationType == StatChangerCalculationType.RAW_ADD_IN_GAME or
            self.calculationType == StatChangerCalculationType.PERCENT_ADD then
        if self.isBuff then
            value = value + self:GetAmount()
        else
            value = value - self:GetAmount()
        end
    elseif self.calculationType == StatChangerCalculationType.PERCENT_MULTIPLY then
        if statValueType == StatValueType.RAW then
            if value == 0 then
                if self.isBuff then
                    value = 1 + self:GetAmount()
                else
                    value = 1 - self:GetAmount()
                end
            else
                if self.isBuff then
                    value = value * (1 + self:GetAmount())
                else
                    value = value * (1 - self:GetAmount())
                end
            end
        else
            if self.isBuff then
                value = value + self:GetAmount()
            else
                value = value - self:GetAmount()
            end
        end
    end

    return MathUtils.Truncate(value)
end

--- @return string
function StatChanger:ToString()
    local effectString = string.format("id = %s, type = %s, isBuff = %s, calculationType = %s, amount = %s",
            tostring(self), self.statAffectedType, tostring(self.isBuff), self.calculationType, self.amount)
    --local effectString = string.format("type = %s, isBuff = %s, calculationType = %s, amount = %s",
    --        self.statAffectedType, tostring(self.isBuff), self.calculationType, self.amount)
    return effectString
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param statAffectedType StatType
--- @param calculationType StatChangerCalculationType
--- @param amount number amount to change stat
function StatChanger:SetInfo(statAffectedType, calculationType, amount)
    self.statAffectedType = statAffectedType
    self.calculationType = calculationType
    self.amount = amount
end

--- @return void
--- @param type StatChangerType
function StatChanger:SetType(type)
    self.type = type
end

--- need call Recalculate in StatChangerEffect after set amount
--- @return void
--- @param amount number
function StatChanger:SetAmount(amount)
    self.amount = amount
end

--- @return void
--- @param multiplier number
function StatChanger:SetMultiplier(multiplier)
    self.amountMultiplier = multiplier
end