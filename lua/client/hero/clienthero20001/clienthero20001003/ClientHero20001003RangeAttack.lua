--- @class ClientHero20001003RangeAttack : ClientHero20001RangeAttack
ClientHero20001003RangeAttack = Class(ClientHero20001003RangeAttack, ClientHero20001RangeAttack)

function ClientHero20001003RangeAttack:DeliverCtor()
    ClientHero20001RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end

function ClientHero20001003RangeAttack:CastOnTarget(actionResults)
    self.clientHero:EnableSmokeEffectFx(false)
    ClientHero20001RangeAttack.CastOnTarget(self, actionResults)
end


function ClientHero20001003RangeAttack:OnCompleteActionTurn()
    self.clientHero:EnableSmokeEffectFx(true)
    ClientHero20001RangeAttack.OnCompleteActionTurn(self)
end