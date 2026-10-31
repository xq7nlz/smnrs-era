--- @class ClientHero60007RangeAttack : BaseRangeAttack
ClientHero60007RangeAttack = Class(ClientHero60007RangeAttack, BaseRangeAttack)

function ClientHero60007RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.projectileLaunchPos2 = self.clientHero.components:FindChildByPath("Model/launch_position_2")
end

function ClientHero60007RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.projectileLaunchPos.position)
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.projectileLaunchPos2.position)
end