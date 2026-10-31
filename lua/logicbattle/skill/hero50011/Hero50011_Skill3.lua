--- @class Hero50011_Skill3 Ignatius
Hero50011_Skill3 = Class(Hero50011_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50011_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.bonusBasicAttack = nil

    --- @type EffectType
    self.effectType = nil

    --- @type number
    self.effectChance = nil

    --- @type number
    self.effectDuration = nil

    --- @type HeroClassType
    self.heroClassType = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50011_Skill3:CreateInstance(id, hero)
    return Hero50011_Skill3(id, hero)
end

--- @return void
function Hero50011_Skill3:Init()
    self.bonusBasicAttack = self.data.bonusBasicAttack

    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration
    --self.heroClassType = self.data.heroClassType
    self.myHero.battleHelper:BindingWithSkill_3(self)
    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param multiplier number
function Hero50011_Skill3:GetDamageBonusBasicAttack(target, multiplier)
    --if target.originInfo.class == self.heroClassType then
        return multiplier * (1 + self.bonusBasicAttack)
    --end

    --return multiplier
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50011_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    --if dodgeType ~= DodgeType.MISS and enemyDefender.originInfo.class == self.heroClassType then
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration)
            enemyDefender.effectController:AddEffect(ccEffect)
        end
    end
end

return Hero50011_Skill3