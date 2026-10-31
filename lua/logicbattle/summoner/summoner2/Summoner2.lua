--- @class Summoner2 : BaseSummoner Warrior
Summoner2 = Class(Summoner2, BaseSummoner)

--- @return BaseSummoner
function Summoner2:CreateInstance()
    return Summoner2()
end

--- @return HeroInitializer
function Summoner2:CreateInitializer()
    return Summoner2_Initializer(self)
end


return Summoner2