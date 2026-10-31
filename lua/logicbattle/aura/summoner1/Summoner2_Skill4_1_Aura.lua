--- @class Summoner2_Skill4_1_Aura : BaseAura
Summoner2_Skill4_1_Aura = Class(Summoner2_Skill4_1_Aura, BaseAura)

--- @return void
--- @param initiator BaseHero
--- @param skill BaseSkill
function Summoner2_Skill4_1_Aura:Ctor(initiator, skill)
    BaseAura.Ctor(self, initiator, skill, true)
end