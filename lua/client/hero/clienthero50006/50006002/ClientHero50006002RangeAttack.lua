--- @class ClientHero50006002RangeAttack : ClientHero50006RangeAttack
ClientHero50006002RangeAttack = Class(ClientHero50006002RangeAttack, ClientHero50006RangeAttack)

function ClientHero50006002RangeAttack:DeliverCtor()
    ClientHero50006RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end
