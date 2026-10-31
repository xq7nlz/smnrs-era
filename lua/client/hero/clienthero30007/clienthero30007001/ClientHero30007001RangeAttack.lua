--- @class ClientHero30007001RangeAttack : ClientHero30007RangeAttack
ClientHero30007001RangeAttack = Class(ClientHero30007001RangeAttack, ClientHero30007RangeAttack)

function ClientHero30007001RangeAttack:DeliverCtor()
    ClientHero30007RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end