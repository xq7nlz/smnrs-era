--- @class BaseActionResult
BaseActionResult = Class(BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param type ActionResultType
function BaseActionResult:Ctor(initiator, target, type)
    --- @type number
    self.index = nil

    --- @type BaseHero
    self.initiator = initiator

    --- @type BaseHero
    self.target = target

    --- @type ActionResultType
    self.type = type

    --- @type number
    self.targetHpPercent = target.hp:GetStatPercent()
end

--- @return void
function BaseActionResult:RefreshHeroStatus()
    self.targetHpPercent = self.target.hp:GetStatPercent()
end

--- @return string
--- @param actionName string
function BaseActionResult:GetPrefix(actionName)
    return string.format("\n[%s] %s => %s (hp = %s)", actionName,
            self.initiator:ToString(), self.target:ToString(), self.targetHpPercent)
end

--- @return BaseActionResult
function BaseActionResult:GetData()
    local data = {}

    data.index = self.index

    if self.initiator then
        data._i = self.initiator:GetHeroUnique()
    end

    if self.target then
        data._t = self.target:GetHeroUnique()
    end

    data.type = self.type

    data._thp = self.targetHpPercent

    return data
end

--- @return string
function BaseActionResult:ToString()
    assert(false, "this method should be overridden by child class")
end

