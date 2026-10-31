--- @class Hero20015_Skill1 Rufus
Hero20015_Skill1 = Class(Hero20015_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20015_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil
    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.healTargetSelector = nil
    --- @type number
    self.healPercent = nil
end

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20015_Skill1:CreateInstance(id, hero)
    return Hero20015_Skill1(id, hero)
end

--- @return void
function Hero20015_Skill1:Init()
    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.healPercent = self.data.healPercent

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero20015_Skill1:UseActiveSkill()
    local enemyTargetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    local healAmount = self.healPercent * self.myHero.attack:GetValue()
    local allyTargetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= allyTargetList:Count() do
        local target = allyTargetList:Get(i)
        HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
        i = i + 1
    end

    local isEndTurn = true

    return results, isEndTurn
end

return Hero20015_Skill1