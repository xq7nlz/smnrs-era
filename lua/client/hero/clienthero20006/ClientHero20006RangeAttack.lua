--- @class ClientHero20006RangeAttack : BaseRangeAttack
ClientHero20006RangeAttack = Class(ClientHero20006RangeAttack, BaseRangeAttack)

function ClientHero20006RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
end

function ClientHero20006RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 15 / ClientConfigUtils.FPS, nil, self.projectileLaunchPos.position)

end
