--- @class Summoner2_Skill4_1 : BaseSkill Warrior
Summoner2_Skill4_1 = Class(Summoner2_Skill4_1, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner2_Skill4_1:CreateInstance(id, hero)
    return Summoner2_Skill4_1(id, hero)
end

--- @return void
function Summoner2_Skill4_1:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.targetList = targetSelector:SelectTarget(self.myHero.battle)

    local aura = Summoner2_Skill4_1_Aura(self.myHero, self)
    aura:SetTarget(self.targetList, self.targetTeam)

    self.auraSkillHelper = MagicShieldAuraSkillHelper(self, aura, self.data.blockChance, self.data.blockRate)
    self.auraSkillHelper:Init()
    self.auraSkillHelper:StartAura()
end

return Summoner2_Skill4_1