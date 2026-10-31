--- @class Hero30021_Skill1 EarthMaster
Hero30021_Skill1 = Class(Hero30021_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30021_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil
    --- @type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
    --- @type HealPercentMaxSkillHelper
    self.healSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30021_Skill1:CreateInstance(id, hero)
    return Hero30021_Skill1(id, hero)
end

--- @return void
function Hero30021_Skill1:Init()
    self.damageTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.healSkillHelper = HealPercentMaxSkillHelper(self)
    self.healSkillHelper:SetHealData(self.data.healPercent, self.data.healDuration)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero30021_Skill1:UseActiveSkill()
    local enemyTargetList = self.damageTargetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    local allyTargetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
    self.healSkillHelper:UseHealSkill(allyTargetList)

    local isEndTurn = true

    return results, isEndTurn
end

return Hero30021_Skill1