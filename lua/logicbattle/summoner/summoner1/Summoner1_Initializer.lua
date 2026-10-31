--- @class Summoner1_Initializer : SummonerInitializer
Summoner1_Initializer = Class(Summoner1_Initializer, SummonerInitializer)

--- @return void
function Summoner1_Initializer:CreateListeners()
    SummonerInitializer.CreateListeners(self)
    self.myHero.battleListener = Summoner1_BattleListener(self.myHero)
end