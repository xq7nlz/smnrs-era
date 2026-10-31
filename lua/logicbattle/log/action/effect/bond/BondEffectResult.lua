--- @class BondEffectResult : BaseActionResult
BondEffectResult = Class(BondEffectResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param bond BaseBond
--- @param remainingRound number
function BondEffectResult:Ctor(initiator, bond, remainingRound)
    BaseActionResult.Ctor(self, initiator, initiator, ActionResultType.BOND_EFFECT)

    --- @type BondType
    self.bondType = bond.type

    --- @type List<BaseHero>
    self.bondedHeroList = List()
    for i = 1, bond.bondedHeroList:Count() do
        local hero = bond.bondedHeroList:Get(i)
        self.bondedHeroList:Add(hero)
    end

    --- @type number
    self.remainingRound = remainingRound
end

--- @return BondEffectResult
function BondEffectResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.bondType = self.bondType

    data.bondedHeroList = {}
    for i = 1, self.bondedHeroList:Count() do
        --- @type BaseHero
        local hero = self.bondedHeroList:Get(i)
        data.bondedHeroList[i] = hero:GetHeroUnique()
    end

    data.remainingRound = self.remainingRound

    return data
end

--- @return string
function BondEffectResult:ToString()
    local heroList = ""
    for i = 1, self.bondedHeroList:Count() do
        local hero = self.bondedHeroList:Get(i)
        if i == self.bondedHeroList:Count() then
            heroList = heroList .. string.format("%s", hero:ToString())
        else
            heroList = heroList .. string.format("%s - ", hero:ToString())
        end
    end

    local result = string.format("\n[BOND_EFFECT] bondType = %s, remainingRound = %s, (%s)\n",
            self.bondType, self.remainingRound, heroList)

    return result
end