--- @class ClientHero50016RangeAttack : BaseRangeAttack
ClientHero50016RangeAttack = Class(ClientHero50016RangeAttack, BaseRangeAttack)

function ClientHero50016RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

function ClientHero50016RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 7 / ClientConfigUtils.FPS)
end