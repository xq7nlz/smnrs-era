--- @class ClientHero40008001RangeAttack : ClientHero40008RangeAttack
ClientHero40008001RangeAttack = Class(ClientHero40008001RangeAttack, ClientHero40008RangeAttack)

function ClientHero40008001RangeAttack:DeliverCtor()
    ClientHero40008RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end
