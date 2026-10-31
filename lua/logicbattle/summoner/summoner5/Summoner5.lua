--- @class Summoner5 : BaseSummoner Ranger
Summoner5 = Class(Summoner5, BaseSummoner)

--- @return BaseSummoner
function Summoner5:CreateInstance()
    return Summoner5()
end

--- @return SummonerInitializer
function Summoner5:CreateInitializer()
    return Summoner5_Initializer(self)
end

return Summoner5