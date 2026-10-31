--- @class Summoner2_Initializer : SummonerInitializer
Summoner2_Initializer = Class(Summoner2_Initializer, SummonerInitializer)

--- @return void
function Summoner2_Initializer:CreateListeners()
    SummonerInitializer.CreateListeners(self)
    self.myHero.battleListener = Summoner2_BattleListener(self.myHero)
end