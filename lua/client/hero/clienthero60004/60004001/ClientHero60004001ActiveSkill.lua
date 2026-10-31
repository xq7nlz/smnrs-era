require "lua.client.hero.ClientHero60004.ClientHero60004ActiveSkill"
--- @class ClientHero60004001ActiveSkill : ClientHero60004ActiveSkill
ClientHero60004001ActiveSkill = Class(ClientHero60004001ActiveSkill, ClientHero60004ActiveSkill)

function ClientHero60004001ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_SKILL_PROJECTILE)
    self.fxImpactConfig.skill_impact_name = "hero_60004_skin_id_60004001_skill_impact"
end