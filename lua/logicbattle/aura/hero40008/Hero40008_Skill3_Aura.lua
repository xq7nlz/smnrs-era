--- @class Hero40008_Skill3_Aura : BaseAura
Hero40008_Skill3_Aura = Class(Hero40008_Skill3_Aura, BaseAura)

--- @return void
--- @param initiator BaseHero
--- @param skill BaseSkill
function Hero40008_Skill3_Aura:Ctor(initiator, skill)
    BaseAura.Ctor(self, initiator, skill, true)
end