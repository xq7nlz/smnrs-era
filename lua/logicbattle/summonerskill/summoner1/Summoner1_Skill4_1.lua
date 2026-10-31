--- @class Summoner1_Skill4_1 : BaseSkill Mage
Summoner1_Skill4_1 = Class(Summoner1_Skill4_1, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill4_1:CreateInstance(id, hero)
    return Summoner1_Skill4_1(id, hero)
end

--- @return void
function Summoner1_Skill4_1:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.targetList = targetSelector:SelectTarget(self.myHero.battle)

    local aura = Summoner1_Skill4_1_Aura(self.myHero, self)
    aura:SetTarget(self.targetList, self.targetTeam)

    self.auraSkillHelper = MagicShieldAuraSkillHelper(self, aura, self.data.blockChance, self.data.blockRate)
    self.auraSkillHelper:Init()
    self.auraSkillHelper:StartAura()
end

return Summoner1_Skill4_1