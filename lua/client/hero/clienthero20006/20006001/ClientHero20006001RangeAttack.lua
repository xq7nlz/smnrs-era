--- @class ClientHero20006001RangeAttack : BaseRangeAttack
ClientHero20006001RangeAttack = Class(ClientHero20006001RangeAttack, BaseRangeAttack)

function ClientHero20006001RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end

function ClientHero20006001RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 15 / ClientConfigUtils.FPS, nil, self.projectileLaunchPos.position)

end
