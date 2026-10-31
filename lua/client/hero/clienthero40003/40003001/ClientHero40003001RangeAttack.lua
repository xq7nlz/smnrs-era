--- @class ClientHero40003001RangeAttack : ClientHero40003RangeAttack
ClientHero40003001RangeAttack = Class(ClientHero40003001RangeAttack, ClientHero40003RangeAttack)

function ClientHero40003001RangeAttack:DeliverCtor()
    ClientHero40003RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end