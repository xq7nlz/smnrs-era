--- @class Hero30008_Skill3_Aura
Hero30008_Skill3_Aura = Class(Hero30008_Skill3_Aura, BaseAura)

--- @return void
--- @param initiator BaseHero
--- @param skill BaseSkill
function Hero30008_Skill3_Aura:Ctor(initiator, skill)
    BaseAura.Ctor(self, initiator, skill, true)
end