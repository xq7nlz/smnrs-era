--- @class Hero50009_Skill4 Aris
Hero50009_Skill4 = Class(Hero50009_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50009_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.effectChance = nil

    --- @type EffectType
    self.effectType = nil

    --- @type number
    self.effectDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50009_Skill4:CreateInstance(id, hero)
    return Hero50009_Skill4(id, hero)
end

--- @return void
function Hero50009_Skill4:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ALLY, self.data.targetNumber)
    self.myHero.attackListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50009_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        self:BuffBless(targetList:Get(i))
        i = i + 1
    end
end

--- @return void
function Hero50009_Skill4:BuffBless(target)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        EffectUtils.CreateBlessEffect(self.myHero, target, self.effectType, self.effectDuration)
    end
end

return Hero50009_Skill4