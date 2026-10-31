--- @class ClientHero40008002RangeAttack : ClientHero40008RangeAttack
ClientHero40008002RangeAttack = Class(ClientHero40008002RangeAttack, ClientHero40008RangeAttack)

function ClientHero40008002RangeAttack:DeliverCtor()
    ClientHero40008RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end
