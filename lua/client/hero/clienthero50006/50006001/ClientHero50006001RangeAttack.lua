--- @class ClientHero50006001RangeAttack : ClientHero50006RangeAttack
ClientHero50006001RangeAttack = Class(ClientHero50006001RangeAttack, ClientHero50006RangeAttack)

function ClientHero50006001RangeAttack:DeliverCtor()
    ClientHero50006RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end
