--- @class Summoner1_Skill4_1_Aura : BaseAura
Summoner1_Skill4_1_Aura = Class(Summoner1_Skill4_1_Aura, BaseAura)

--- @return void
--- @param initiator BaseHero
--- @param skill BaseSkill
function Summoner1_Skill4_1_Aura:Ctor(initiator, skill)
    BaseAura.Ctor(self, initiator, skill, true)
end