--- @class Summoner4_Initializer : SummonerInitializer
Summoner4_Initializer = Class(Summoner4_Initializer, SummonerInitializer)

--- @return void
function Summoner4_Initializer:CreateListeners()
    SummonerInitializer.CreateListeners(self)
    self.myHero.battleListener = Summoner4_BattleListener(self.myHero)
end

--- @return void
function Summoner4_Initializer:CreateHeroStats()
    SummonerInitializer.CreateHeroStats(self)
    self.myHero.power = Summoner4_PowerStat(self.myHero)
end