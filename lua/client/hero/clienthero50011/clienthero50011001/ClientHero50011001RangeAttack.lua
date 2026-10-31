--- @class ClientHero50011001RangeAttack : ClientHero50011RangeAttack
ClientHero50011001RangeAttack = Class(ClientHero50011001RangeAttack, ClientHero50011RangeAttack)

function ClientHero50011001RangeAttack:DeliverCtor()
    ClientHero50011RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end