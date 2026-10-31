--- @class Hero20001_RegenerateActionResult : RegenerateActionResult
Hero20001_RegenerateActionResult = Class(Hero20001_RegenerateActionResult, RegenerateActionResult)

--- @param initiator BaseHero
--- @param target BaseHero
--- @param remainingRound number
--- @param isTransform boolean
function Hero20001_RegenerateActionResult:Ctor(initiator, target, remainingRound, isTransform)
    RegenerateActionResult.Ctor(self, initiator, target)

    --- @type number
    if isTransform == nil then
        self.isTransform = false
    else
        self.isTransform = isTransform
    end
    --- @type number
    self.remainingRound = remainingRound
end

--- @return Hero20001_RegenerateActionResult
function Hero20001_RegenerateActionResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.isTransform = self.isTransform

    data.remainingRound = self.remainingRound

    return data
end

--- @return string
function Hero20001_RegenerateActionResult:ToString()
    local result = string.format("%s, remainingRound = %s, isTransform = %s\n",
            BaseActionResult.GetPrefix(self, "REGENERATION"), self.remainingRound, tostring(self.isTransform))
    return result
end