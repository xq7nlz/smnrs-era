--- @class Hero60016_Skill1 DarkMage
Hero60016_Skill1 = Class(Hero60016_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60016_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type StatChangerSkillHelper
    self.statChangerSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60016_Skill1:CreateInstance(id, hero)
    return Hero60016_Skill1(id, hero)
end

--- @return void
function Hero60016_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    self.statChangerSkillHelper:SetInfo(true, self.data.effectDuration)
    self.statChangerSkillHelper:SetPersistentType(EffectPersistentType.NON_PERSISTENT)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero60016_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    self.statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)

    return results, isEndTurn
end

return Hero60016_Skill1