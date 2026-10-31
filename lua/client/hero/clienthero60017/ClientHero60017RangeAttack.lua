--- @class ClientHero60017RangeAttack : BaseRangeAttack
ClientHero60017RangeAttack = Class(ClientHero60017RangeAttack, BaseRangeAttack)

function ClientHero60017RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.projectileName = string.format("hero_%d_%s_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_ATTACK_PROJECTILE, self.clientHero.skinName)
end