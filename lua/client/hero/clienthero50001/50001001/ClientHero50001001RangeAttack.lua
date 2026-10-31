--- @class ClientHero50001001RangeAttack : ClientHero50001RangeAttack
ClientHero50001001RangeAttack = Class(ClientHero50001001RangeAttack, ClientHero50001RangeAttack)

function ClientHero50001001RangeAttack:DeliverCtor()
    ClientHero50001RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end