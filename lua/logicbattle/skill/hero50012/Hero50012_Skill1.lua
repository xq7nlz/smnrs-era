--- @class Hero50012_Skill1 Alvar
Hero50012_Skill1 = Class(Hero50012_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50012_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type BaseTargetSelector
    self.damageTargetSelector = nil

    ---@type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type number
    self.healPercentOfDamage = 0

    --- @type number
    self.totalDamageSkill = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50012_Skill1:CreateInstance(id, hero)
    return Hero50012_Skill1(id, hero)
end

--- @return void
function Hero50012_Skill1:Init()
    self.healPercentOfDamage = self.data.healPercentOfDamage

    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)
    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.healTargetSelector:SetIncludeSelf(false)
    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.myHero.skillListener:BindingWithSkill_1(self)
    self.myHero.battleListener:BindingWithSkill_1(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50012_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)
    local result = self.damageSkillHelper:UseDamageSkill(targetList)

    local isEndTurn = true

    return result, isEndTurn
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero50012_Skill1:OnDealSkillDamageToEnemy(enemyDefender, totalDamage)
    self.totalDamageSkill = self.totalDamageSkill + totalDamage
end

--- @return void
function Hero50012_Skill1:OnEndBattleTurn()
    if self.totalDamageSkill > 0 then
        self:BuffHeal(self.totalDamageSkill * self.healPercentOfDamage)
    end
    self.totalDamageSkill = 0
end

--- @return void
--- @param healAmount number
function Hero50012_Skill1:BuffHeal(healAmount)
    local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
    if targetList:Count() > 0 then
        healAmount = healAmount / (targetList:Count() + 1)
    end

    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    local i = 1
    while i <= targetList:Count() do
        local ally = targetList:Get(i)
        HealUtils.Heal(self.myHero, ally, healAmount, HealReason.HEAL_SKILL)
        i = i + 1
    end
end

return Hero50012_Skill1