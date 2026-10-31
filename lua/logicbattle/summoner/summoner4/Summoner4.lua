--- @class Summoner4 : BaseSummoner Assassin
Summoner4 = Class(Summoner4, BaseSummoner)

--- @return BaseSummoner
function Summoner4:CreateInstance()
    return Summoner4()
end

--- @return SummonerInitializer
function Summoner4:CreateInitializer()
    return Summoner4_Initializer(self)
end

return Summoner4