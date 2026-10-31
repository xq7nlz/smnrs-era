--- @class Summoner3_Initializer : SummonerInitializer
Summoner3_Initializer = Class(Summoner3_Initializer, SummonerInitializer)

--- @return void
function Summoner3_Initializer:CreateListeners()
    SummonerInitializer.CreateListeners(self)
    self.myHero.battleListener = Summoner3_BattleListener(self.myHero)
end