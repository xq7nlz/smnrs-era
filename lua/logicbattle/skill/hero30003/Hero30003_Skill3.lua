--- @class Hero30003_Skill3 Nero
Hero30003_Skill3 = Class(Hero30003_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30003_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healResistanceChance = nil

    --- @type number
    self.healResistanceDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30003_Skill3:CreateInstance(id, hero)
    return Hero30003_Skill3(id, hero)
end

--- @return void
function Hero30003_Skill3:Init()
    self.healResistanceChance = self.data.healResistanceChance
    self.healResistanceDuration = self.data.healResistanceDuration

    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.myHero.attackController:SetSelector(targetSelector)

    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30003_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.healResistanceChance) then
            local effect = HealResistanceEffect(self.myHero, enemyDefender)
            effect:SetDuration(self.healResistanceDuration)
            enemyDefender.effectController:AddEffect(effect)
        end
    end
end

return Hero30003_Skill3