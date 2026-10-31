--- @class ClientHero30007002RangeAttack : ClientHero30007RangeAttack
ClientHero30007002RangeAttack = Class(ClientHero30007002RangeAttack, ClientHero30007RangeAttack)

function ClientHero30007002RangeAttack:DeliverCtor()
    ClientHero30007RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end