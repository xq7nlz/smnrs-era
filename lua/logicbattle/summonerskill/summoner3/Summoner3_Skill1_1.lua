--- @class Summoner3_Skill1_1 : BaseSkill Priest
Summoner3_Skill1_1 = Class(Summoner3_Skill1_1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill1_1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill1_1:CreateInstance(id, hero)
    return Summoner3_Skill1_1(id, hero)
end

--- @return void
function Summoner3_Skill1_1:Init()
    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.healPercent = self.data.healPercent

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Summoner3_Skill1_1:UseActiveSkill()
    local enemyTargetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    self:HealAllies()

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
function Summoner3_Skill1_1:HealAllies()
    local healAmount = self.healPercent * self.myHero.attack:GetValue()

    local allyTargetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= allyTargetList:Count() do
        local target = allyTargetList:Get(i)
        HealUtils.Heal(self.myHero, target, healAmount, HealReason.SUMMONER_HEAL)
        i = i + 1
    end
end

return Summoner3_Skill1_1
