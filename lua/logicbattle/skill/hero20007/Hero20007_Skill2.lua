--- @class Hero20007_Skill2 Ninetales
Hero20007_Skill2 = Class(Hero20007_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20007_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil

    --- @type number
    self.effectChance = nil

    --- @type number
    self.effectDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20007_Skill2:CreateInstance(id, hero)
    return Hero20007_Skill2(id, hero)
end

--- @return void
function Hero20007_Skill2:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    self.myHero.attackController:SetSelector(targetSelector)

    self.myHero.attackListener:BindingWithSkill_2(self)

    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration
end

---------------------------------------- Parse Csv ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20007_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration)
            enemyDefender.effectController:AddEffect(ccEffect)
        end
    end
end

return Hero20007_Skill2