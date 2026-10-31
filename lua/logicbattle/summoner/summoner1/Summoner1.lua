--- @class Summoner1 : BaseSummoner --  Mage
Summoner1 = Class(Summoner1, BaseSummoner)

--- @return BaseSummoner
function Summoner1:CreateInstance()
    return Summoner1()
end

--- @return HeroInitializer
function Summoner1:CreateInitializer()
    return Summoner1_Initializer(self)
end

return Summoner1