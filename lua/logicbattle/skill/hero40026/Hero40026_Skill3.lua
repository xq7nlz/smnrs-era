--- @class Hero40026_Skill3 Arason
Hero40026_Skill3 = Class(Hero40026_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40026_Skill3:CreateInstance(id, hero)
    return Hero40026_Skill3(id, hero)
end

--- @return void
function Hero40026_Skill3:Init()
    self.myHero.attackListener:BindingWithSkill_3(self)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40026_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    self.statChanger = StatChanger(true)
    self.statChanger:SetInfo(self.data.buffType, StatChangerCalculationType.PERCENT_ADD, self.data.buffAmount)

    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
    self.statChangerEffect:AddStatChanger(self.statChanger)

    self.myHero.effectController:AddEffect(self.statChangerEffect)
end

return Hero40026_Skill3