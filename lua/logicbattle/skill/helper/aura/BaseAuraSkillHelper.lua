--- @class BaseAuraSkillHelper
BaseAuraSkillHelper = Class(BaseAuraSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
--- @param aura BaseAura
function BaseAuraSkillHelper:Ctor(skill, aura)
    BaseSkillHelper.Ctor(self, skill)

    --- @type BaseAura
    self.aura = aura
end

---------------------------------------- Getters ----------------------------------------
--- @return AuraState
function BaseAuraSkillHelper:GetAuraState()
    return self.aura:GetState()
end

--- @return AuraState
function BaseAuraSkillHelper:GetTargetList()
    return self.aura.targetList
end

---------------------------------------- Manager ----------------------------------------
--- @return void
function BaseAuraSkillHelper:Init()
    assert(false, "this method should be overridden by child class")
end

--- @return void
function BaseAuraSkillHelper:StartAura()
    self.myHero.battle.auraManager:AddAura(self.aura)
    self.myHero.battle.auraManager:StartAura(self.aura)
end

--- @return void
function BaseAuraSkillHelper:RecalculateAura()
    self.myHero.battle.auraManager:RecalculateAura(self.aura)
end