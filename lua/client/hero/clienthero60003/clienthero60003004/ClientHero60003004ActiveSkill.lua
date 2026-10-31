require "lua.client.hero.ClientHero60003.ClientHero60003002.ClientHero60003002ActiveSkill"
--- @class ClientHero60003004ActiveSkill : ClientHero60003002ActiveSkill
ClientHero60003004ActiveSkill = Class(ClientHero60003004ActiveSkill, ClientHero60003002ActiveSkill)

function ClientHero60003004ActiveSkill:CastImpactFromConfig()
    if self.fxImpactConfig ~= nil then
        self:CastNewClientImpactOnTargets(self.fxImpactConfig.skill_impact_type, "hero_60003_skin_id_60003004_skill_impact")
    end
end