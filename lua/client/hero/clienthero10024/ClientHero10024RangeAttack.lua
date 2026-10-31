--- @class ClientHero10024RangeAttack : BaseRangeAttack
ClientHero10024RangeAttack = Class(ClientHero10024RangeAttack, BaseRangeAttack)

function ClientHero10024RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.projectileName = string.format("hero_%d_projectile", self.baseHero.id)
end