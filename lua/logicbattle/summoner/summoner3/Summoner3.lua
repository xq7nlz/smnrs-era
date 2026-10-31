--- @class Summoner3 : BaseSummoner Priest
Summoner3 = Class(Summoner3, BaseSummoner)

--- @return BaseSummoner
function Summoner3:CreateInstance()
    return Summoner3()
end

--- @return HeroInitializer
function Summoner3:CreateInitializer()
    return Summoner3_Initializer(self)
end

return Summoner3