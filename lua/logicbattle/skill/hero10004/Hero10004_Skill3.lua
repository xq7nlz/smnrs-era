--- @class Hero10004_Skill3 Frosthardy
Hero10004_Skill3 = Class(Hero10004_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10004_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type number
    self.damageBonusPercent = nil

    --- @type EffectType
    self.effectType = nil

    --- @type number
    self.effectChance = nil

    --- @type number
    self.effectDuration = nil

    --- @type boolean
    self.isTrigger = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10004_Skill3:CreateInstance(id, hero)
    return Hero10004_Skill3(id, hero)
end

--- @return void
function Hero10004_Skill3:Init()
    self.damageBonusPercent = self.data.damageBonusPercent
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration

    self.myHero.battleHelper:BindingWithSkill_3(self)
    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10004_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS and self.isTrigger == true then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration)
        enemyDefender.effectController:AddEffect(ccEffect)
    end
end

--- @return number damage
--- @param target BaseHero
function Hero10004_Skill3:CalculateAttackResult(target)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        self.isTrigger = true
        return self.damageBonusPercent
    else
        self.isTrigger = false
        return 0
    end
end

return Hero10004_Skill3