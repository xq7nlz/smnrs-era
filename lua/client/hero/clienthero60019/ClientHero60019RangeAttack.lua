--- @class ClientHero60019RangeAttack : BaseRangeAttack
ClientHero60019RangeAttack = Class(ClientHero60019RangeAttack, BaseRangeAttack)

function ClientHero60019RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.projectileName = string.format("hero_%d_%s_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_ATTACK_PROJECTILE,self.clientHero.skinName)
end