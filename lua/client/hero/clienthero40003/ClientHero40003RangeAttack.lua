--- @class ClientHero40003RangeAttack : BaseRangeAttack
ClientHero40003RangeAttack = Class(ClientHero40003RangeAttack, BaseRangeAttack)

function ClientHero40003RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/bone_attack/launch_position")
end

function ClientHero40003RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.projectileLaunchPos.position)
end