--- @class HeroState
HeroState = Class(HeroState)

--- @return void
function HeroState:Ctor()
    --- @type boolean
    self.isFrontLine = 1

    --- @type number
    self.position = 1

    --- @type number
    self.hpPercent = 1

    --- @type Number
    self.hpValue = 0

    --- @type number
    self.powerValue = HeroConstants.DEFAULT_HERO_POWER
end

---@return void
---@param hpPercent number
---@param powerValue number
---@param hpValue number
function HeroState:SetState(hpPercent, powerValue, hpValue)
    self.hpPercent = hpPercent
    self.powerValue = powerValue
    self.hpValue = hpValue
end

---@return void
---@param isFrontLine boolean
---@param position number
function HeroState:SetPosition(isFrontLine, position)
    self.isFrontLine = isFrontLine
    self.position = position
end

---@return number
function HeroState:GetHpPercent()
    return self.hpPercent
end

---@return number
function HeroState:GetHpValue()
    return self.hpValue
end

---@return number
function HeroState:GetPowerValue()
    return self.powerValue
end

---@return number
function HeroState:GetPosition()
    return self.position
end

---@return boolean
function HeroState:IsFrontLine()
    return self.isFrontLine
end