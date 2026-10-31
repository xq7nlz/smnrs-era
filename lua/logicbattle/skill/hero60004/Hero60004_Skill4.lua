--- @class Hero60004_Skill4 Karos
Hero60004_Skill4 = Class(Hero60004_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60004_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectChance = 0
    --- @type number
    self.effectAmount = 0

    --- @type List<BaseHero>
    self.targetList = nil

    --- @type ReflectAuraSkillHelper
    self.auraSkillHelper = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60004_Skill4:CreateInstance(id, hero)
    return Hero60004_Skill4(id, hero)
end

--- @return void
function Hero60004_Skill4:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)
    self.targetList = targetSelector:SelectTarget(self.myHero.battle)

    self.reflectDamageHelper = ReflectDamageHelper(self)
    self.reflectDamageHelper:SetInfo(self.data.effectChance, self.data.effectAmount)

    self:CreateAura()
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
function Hero60004_Skill4:CreateAura()
    local aura = Hero60004_Skill4_Aura(self.myHero, self)
    aura:SetTarget(self.targetList, TargetTeamType.ALLY)

    self.auraSkillHelper = ReflectAuraSkillHelper(self, aura)
    self.auraSkillHelper:Init()
    self.auraSkillHelper:StartAura()

    aura:SetReflectDamageHelper(self.reflectDamageHelper)
end

return Hero60004_Skill4