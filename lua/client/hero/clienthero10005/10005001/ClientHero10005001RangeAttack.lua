--- @class ClientHero10005001RangeAttack : ClientHero10005RangeAttack
ClientHero10005001RangeAttack = Class(ClientHero10005001RangeAttack, ClientHero10005RangeAttack)

function ClientHero10005001RangeAttack:DeliverCtor()
    ClientHero10005RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end