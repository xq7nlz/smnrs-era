--- @class Summoner5_Initializer : SummonerInitializer
Summoner5_Initializer = Class(Summoner5_Initializer, SummonerInitializer)

--- @return void
function Summoner5_Initializer:CreateListeners()
    SummonerInitializer.CreateListeners(self)
    self.myHero.battleListener = Summoner5_BattleListener(self.myHero)
end