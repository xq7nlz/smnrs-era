--- @class ClientHero30001001BaseAttack : ClientHero30001BaseAttack
ClientHero30001001BaseAttack = Class(ClientHero30001001BaseAttack, ClientHero30001BaseAttack)

function ClientHero30001001BaseAttack:CastOnTarget(actionResults)
    self.clientHero:EnableSmokeEffectFx(false)
    ClientHero30001BaseAttack.CastOnTarget(self, actionResults)
end


function ClientHero30001001BaseAttack:OnCompleteActionTurn()
    self.clientHero:EnableSmokeEffectFx(true)
    ClientHero30001BaseAttack.OnCompleteActionTurn()
end

