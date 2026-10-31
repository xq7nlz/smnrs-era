--- @class Hero20002_Skill2 Arien
Hero20002_Skill2 = Class(Hero20002_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20002_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type EffectType
    self.effectType = nil

    --- @type number
    self.effectAmount = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20002_Skill2:CreateInstance(id, hero)
    return Hero20002_Skill2(id, hero)
end

--- @return void
function Hero20002_Skill2:Init()
    self.effectType = self.data.effectType
    self.effectAmount = self.data.effectAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber + 1)

    self.myHero.attackListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20002_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    --- @type List<BaseHero>
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local shouldAdd = false
    if targetList:IsContainValue(self.myHero) == false then
        targetList:RemoveByIndex(targetList:Count())
        shouldAdd = true
    end

    if shouldAdd and self.myHero:IsDead() == false then
        targetList:Add(self.myHero)
    end

    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local healAmount = target.hp:GetMax() * self.effectAmount
        HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
        i = i + 1
    end
end

return Hero20002_Skill2