--- @class Hero30010_Skill3 Erde
Hero30010_Skill3 = Class(Hero30010_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30010_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type BaseSkill
    self.skill_2 = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30010_Skill3:CreateInstance(id, hero)
    return Hero30010_Skill3(id, hero)
end

--- @return void
function Hero30010_Skill3:Init()
    self.myHero.battleHelper:SetBasicAttackMultiplier(self.data.basicAttackDamageMultiplier)

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param skill BaseSkill
function Hero30010_Skill3:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30010_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local healAmount = self.myHero.attack:GetValue() * self.data.healAmount
        HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)

        if self.skill_2 ~= nil then
            self.skill_2:OnHeal(target)
        end
        i = i + 1
    end
end

return Hero30010_Skill3