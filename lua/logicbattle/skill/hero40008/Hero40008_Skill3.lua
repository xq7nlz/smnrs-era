--- @class Hero40008_Skill3 Lass
Hero40008_Skill3 = Class(Hero40008_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40008_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type List<BaseHero>
    self.targetList = nil

    --- @type BaseAuraSkillHelper
    self.auraSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40008_Skill3:CreateInstance(id, hero)
    return Hero40008_Skill3(id, hero)
end

--- @return void
function Hero40008_Skill3:Init()
    self:CreateTargetList()
    self:CreateAura()
end

---------------------------------------- Parse Csv ----------------------------------------
--- @return void
function Hero40008_Skill3:CreateTargetList()
    local attackerTeam, defenderTeam = self.myHero.battle:GetTeam()
    local targetTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, self.myHero.teamId)

    local heroList = targetTeam:GetHeroList()

    self.targetList = List()
    local i = 1
    while i <= heroList:Count() do
        local target = heroList:Get(i)
        if target.originInfo.faction == HeroFactionType.NATURE or
                target.originInfo.faction == HeroFactionType.WATER or
                target.originInfo.faction == HeroFactionType.LIGHT then
            self.targetList:Add(target)
        end
        i = i + 1
    end
end

---------------------------------------- BATTLE -----------------------------------.
--- @return void
function Hero40008_Skill3:CreateAura()
    local aura = Hero40008_Skill3_Aura(self.myHero, self)
    aura:SetTarget(self.targetList, TargetTeamType.ALLY)

    self.auraSkillHelper = StatChangerAuraSkillHelper(self, aura, self.data.bonuses)
    self.auraSkillHelper:AddEffectToAura()
    self.auraSkillHelper:StartAura()
end

return Hero40008_Skill3