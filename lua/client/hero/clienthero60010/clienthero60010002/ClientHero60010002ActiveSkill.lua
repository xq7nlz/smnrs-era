--- @class ClientHero60010002ActiveSkill : ClientHero60010ActiveSkill
ClientHero60010002ActiveSkill = Class(ClientHero60010002ActiveSkill, ClientHero60010ActiveSkill)

function ClientHero60010002ActiveSkill:CastImpactFromConfig()
    if self.fxImpactConfig ~= nil then
        self.fxImpactConfig.skill_impact_name = "hero_60010_skin_id_60010002_skill_impact"
        self:CastNewClientImpactOnTargets(self.fxImpactConfig.skill_impact_type, self.fxImpactConfig.skill_impact_name)
    end
end