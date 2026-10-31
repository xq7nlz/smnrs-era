--- @class Hero50014_Initializer
Hero50014_Initializer = Class(Hero50014_Initializer, HeroInitializer)

--- @return void
function Hero50014_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero50014_HpStat(self.myHero)
end

--- @return void
function Hero50014_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50014_AttackListener(self.myHero)
end
