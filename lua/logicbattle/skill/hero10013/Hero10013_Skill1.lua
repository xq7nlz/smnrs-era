--- @class Hero10013_Skill1 Oceanee
Hero10013_Skill1 = Class(Hero10013_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10013_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type BaseTargetSelector
    self.damageTargetSelector = nil

    ---@type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type number
    self.healAmount = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10013_Skill1:CreateInstance(id, hero)
    return Hero10013_Skill1(id, hero)
end

--- @return void
function Hero10013_Skill1:Init()
    self.healAmount = self.data.healAmount

    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)
    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- BATTLE -----------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero10013_Skill1:UseActiveSkill()
    local targetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)
    local result = self.damageSkillHelper:UseDamageSkill(targetList)

    self:BuffHeal()

    local isEndTurn = true

    return result, isEndTurn
end

--- @return void
function Hero10013_Skill1:BuffHeal()
    local healAmount = self.healAmount * self.myHero.attack:GetValue()
    local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)

    local i = 1
    while i <= targetList:Count() do
        local ally = targetList:Get(i)
        HealUtils.Heal(self.myHero, ally, healAmount, HealReason.HEAL_SKILL)
        i = i + 1
    end
end

return Hero10013_Skill1