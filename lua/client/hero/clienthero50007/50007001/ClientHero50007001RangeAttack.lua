--- @class ClientHero50007001RangeAttack : ClientHero50007RangeAttack
ClientHero50007001RangeAttack = Class(ClientHero50007001RangeAttack, ClientHero50007RangeAttack)

function ClientHero50007001RangeAttack:DeliverCtor()
    ClientHero50007RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end
