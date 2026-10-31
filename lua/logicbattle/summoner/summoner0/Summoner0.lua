--- @class SummonerNovice Novice : BaseSummoner
SummonerNovice = Class(SummonerNovice, BaseSummoner)

--- @return BaseSummoner
function SummonerNovice:CreateInstance()
    return SummonerNovice()
end

--- @return SummonerInitializer
function SummonerNovice:CreateInitializer()
    return SummonerNovice_Initializer(self)
end

return SummonerNovice