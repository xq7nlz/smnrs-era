--- @class ClientHero50003002RangeAttack : BaseRangeAttack
ClientHero50003002RangeAttack = Class(ClientHero50003002RangeAttack, BaseRangeAttack)

function ClientHero50003002RangeAttack:DeliverCtor()
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end