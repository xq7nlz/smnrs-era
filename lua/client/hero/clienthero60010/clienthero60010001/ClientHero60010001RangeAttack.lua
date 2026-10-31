--- @class ClientHero60010001RangeAttack : ClientHero60010RangeAttack
ClientHero60010001RangeAttack = Class(ClientHero60010001RangeAttack, ClientHero60010RangeAttack)

function ClientHero60010001RangeAttack:DeliverCtor()
    ClientHero60010RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end