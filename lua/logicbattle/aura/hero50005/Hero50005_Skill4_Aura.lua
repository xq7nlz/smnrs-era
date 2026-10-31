--- @class Hero50005_Skill4_Aura : BaseAura
Hero50005_Skill4_Aura = Class(Hero50005_Skill4_Aura, BaseAura)

--- @return void
--- @param initiator BaseHero
--- @param skill BaseSkill
function Hero50005_Skill4_Aura:Ctor(initiator, skill)
    BaseAura.Ctor(self, initiator, skill, true)
end

--- @return string
function Hero50005_Skill4_Aura:GetAuraTag()
    return BaseAura.GetAuraTag(self) .. tostring(self.initiator.positionInfo.isFrontLine) .. "not_same_line"
end