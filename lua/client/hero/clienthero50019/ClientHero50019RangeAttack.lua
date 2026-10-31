--- @class ClientHero50019RangeAttack : BaseRangeAttack
ClientHero50019RangeAttack = Class(ClientHero50019RangeAttack, BaseRangeAttack)

function ClientHero50019RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

function ClientHero50019RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end