--- @class Hero30010_Skill4_Aura : BaseAura
Hero30010_Skill4_Aura = Class(Hero30010_Skill4_Aura, BaseAura)

--- @return void
--- @param initiator BaseHero
--- @param skill BaseSkill
function Hero30010_Skill4_Aura:Ctor(initiator, skill)
    BaseAura.Ctor(self, initiator, skill, true)
end