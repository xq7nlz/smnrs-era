--- @class BondCreatedResult : BondEffectResult
BondCreatedResult = Class(BondCreatedResult, BondEffectResult)

--- @return string
function BondCreatedResult:ToString()
    local heroList = ""
    for i = 1, self.bondedHeroList:Count() do
        local hero = self.bondedHeroList:Get(i)
        if i == self.bondedHeroList:Count() then
            heroList = heroList .. string.format("%s", hero:ToString())
        else
            heroList = heroList .. string.format("%s - ", hero:ToString())
        end
    end

    local result = string.format("\n[BOND_CREATED] bondType = %s, remainingRound = %s, initiator = %s, (%s)\n",
            self.bondType, self.remainingRound, self.initiator:ToString(), heroList)

    return result
end