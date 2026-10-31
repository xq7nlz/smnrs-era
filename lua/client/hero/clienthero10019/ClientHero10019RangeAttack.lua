--- @class ClientHero10019RangeAttack : BaseRangeAttack
ClientHero10019RangeAttack = Class(ClientHero10019RangeAttack, BaseRangeAttack)

function ClientHero10019RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

function ClientHero10019RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end