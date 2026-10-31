--- @class Hero30005_Utils
Hero30005_Utils = {}

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param venomDamage number
--- @param venomDuration number
--- @param numberStack number
function Hero30005_Utils.InflictVenomStack(initiator, target, venomDamage, venomDuration, numberStack)
    for _ = 1, numberStack do
        local venomStack = VenomStack(initiator, target)
        venomStack:SetDotAmount(venomDamage)
        venomStack:SetDuration(venomDuration)

        target.effectController:AddEffect(venomStack)
    end
end

return Hero30005_Utils