--- @class ClientHero10005002RangeAttack : ClientHero10005RangeAttack
ClientHero10005002RangeAttack = Class(ClientHero10005002RangeAttack, ClientHero10005RangeAttack)

function ClientHero10005002RangeAttack:DeliverCtor()
    ClientHero10005RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end