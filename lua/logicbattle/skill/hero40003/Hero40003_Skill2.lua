--- @class Hero40003_Skill2 Arryl
Hero40003_Skill2 = Class(Hero40003_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40003_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.effectChance = 0

    --- @type EffectType
    self.effectType = 0

    --- @type number
    self.effectDuration = 0

    --- @type number
    self.effectAmount = 0

    --- @type number
    self.effectDryadDuration = 0

    --- @type number
    self.effectDryadAmount = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40003_Skill2:CreateInstance(id, hero)
    return Hero40003_Skill2(id, hero)
end

--- @return void
function Hero40003_Skill2:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectAmount = self.data.effectAmount
    self.effectDuration = self.data.effectDuration

    self.effectDryadDuration = self.data.effectDryadDuration
    self.effectDryadAmount = self.data.effectDryadAmount

    self.myHero.attackListener:BindingWithSkill_2(self)
end

----------------------------------- Battle ---------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40003_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS and self.myHero.randomHelper:RandomRate(self.effectChance) then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration, self.effectAmount)
        enemyDefender.effectController:AddEffect(dotEffect)

        self:MarkDryadToTarget(enemyDefender)
    end
end

--- @return void
--- @param enemyDefender BaseHero
function Hero40003_Skill2:MarkDryadToTarget(enemyDefender)
    local markEffect = DryadMark(self.myHero, enemyDefender)
    markEffect:SetDuration(self.effectDryadDuration)
    markEffect:SetReduceHeal(self.effectDryadAmount)
    enemyDefender.effectController:AddEffect(markEffect)
end

return Hero40003_Skill2