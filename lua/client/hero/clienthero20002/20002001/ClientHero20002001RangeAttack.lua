--- @class ClientHero20002001RangeAttack : BaseRangeAttack
ClientHero20002001RangeAttack = Class(ClientHero20002001RangeAttack, BaseRangeAttack)

function ClientHero20002001RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.projectileName = "hero_20002_skin_id_20002001_attack_projectile"
    self.fxImpactConfig.skill_impact_name = "hero_20002_skin_id_20002001_attack_impact"
end