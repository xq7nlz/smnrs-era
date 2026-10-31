--- @class ClientHero50010RangeAttack : BaseRangeAttack
ClientHero50010RangeAttack = Class(ClientHero50010RangeAttack, BaseRangeAttack)

function ClientHero50010RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

function ClientHero50010RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end