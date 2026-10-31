--- @class ClientHero30012RangeAttack : BaseRangeAttack
ClientHero30012RangeAttack = Class(ClientHero30012RangeAttack, BaseRangeAttack)

function ClientHero30012RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

function ClientHero30012RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 7.0 / ClientConfigUtils.FPS)
end