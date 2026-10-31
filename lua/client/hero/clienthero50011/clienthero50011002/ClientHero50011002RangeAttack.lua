--- @class ClientHero50011002RangeAttack : ClientHero50011RangeAttack
ClientHero50011002RangeAttack = Class(ClientHero50011002RangeAttack, ClientHero50011RangeAttack)

function ClientHero50011002RangeAttack:DeliverCtor()
    ClientHero50011RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end