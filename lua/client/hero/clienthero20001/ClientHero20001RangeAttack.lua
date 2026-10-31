--- @class ClientHero20001RangeAttack : BaseRangeAttack
ClientHero20001RangeAttack = Class(ClientHero20001RangeAttack, BaseRangeAttack)

function ClientHero20001RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
end

function ClientHero20001RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 15 / ClientConfigUtils.FPS, nil, self.projectileLaunchPos.position)
end