--- @class ClientHero20015RangeAttack : BaseRangeAttack
ClientHero20015RangeAttack = Class(ClientHero20015RangeAttack, BaseRangeAttack)

function ClientHero20015RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

function ClientHero20015RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.projectileLaunchPos)
end