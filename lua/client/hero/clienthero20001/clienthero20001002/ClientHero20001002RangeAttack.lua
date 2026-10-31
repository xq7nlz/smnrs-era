--- @class ClientHero20001002RangeAttack : ClientHero20001RangeAttack
ClientHero20001002RangeAttack = Class(ClientHero20001002RangeAttack, ClientHero20001RangeAttack)

function ClientHero20001002RangeAttack:DeliverCtor()
    ClientHero20001RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end

function ClientHero20001002RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 20 / ClientConfigUtils.FPS, nil, self.projectileLaunchPos.position)
end