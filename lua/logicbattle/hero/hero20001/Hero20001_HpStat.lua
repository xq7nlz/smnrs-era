--- @class Hero20001_HpStat
Hero20001_HpStat = Class(Hero20001_HpStat, HpStat)

--- @return void
function Hero20001_HpStat:RebornToEgg()
    self.isDead = false

    self:Calculate()
    self:SetToMax()
    self.myHero.power:SetToMin()
    self.myHero.effectController:OnRevive()
end

--- @return void
function Hero20001_HpStat:RebornToHero()
    self.isDead = false
    self.myHero.effectController:OnRevive()

    self:Calculate()
    self:SetToMax()
    self.myHero.power:SetToMin()
end
