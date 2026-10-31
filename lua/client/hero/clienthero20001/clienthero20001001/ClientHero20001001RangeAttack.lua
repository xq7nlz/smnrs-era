--- @class ClientHero20001001RangeAttack : ClientHero20001RangeAttack
ClientHero20001001RangeAttack = Class(ClientHero20001001RangeAttack, ClientHero20001RangeAttack)

function ClientHero20001001RangeAttack:DeliverCtor()
    ClientHero20001RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end