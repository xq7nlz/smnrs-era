--- @class ClientHero20002001ActiveSkill : ClientHero20002ActiveSkill
ClientHero20002001ActiveSkill = Class(ClientHero20002001ActiveSkill, ClientHero20002ActiveSkill)

function ClientHero20002001ActiveSkill:DeliverCtor()
    ClientHero20002ActiveSkill.DeliverCtor(self)
    self.fxImpactConfig.skill_impact_name = "hero_20002_skin_id_20002001_skill_impact"
    self.projectileName = "hero_20002_skin_id_20002001_skill_projectile"
end