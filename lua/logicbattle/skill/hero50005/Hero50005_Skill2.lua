--- @class Hero50005_Skill2 GuardianOfLight
Hero50005_Skill2 = Class(Hero50005_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50005_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type List<BaseHero>
    self.targetList = nil

    --- @type StatChangerAuraSkillHelper
    self.auraSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50005_Skill2:CreateInstance(id, hero)
    return Hero50005_Skill2(id, hero)
end

--- @return void
function Hero50005_Skill2:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.targetList = targetSelector:SelectTarget(self.myHero.battle)

    local aura = Hero50005_Skill2_Aura(self.myHero, self)
    aura:SetTarget(self.targetList, TargetTeamType.ALLY)

    self.auraSkillHelper = StatChangerAuraSkillHelper(self, aura, self.data.bonuses)
    self.auraSkillHelper:AddEffectToAura()
    self.auraSkillHelper:StartAura()
end

return Hero50005_Skill2