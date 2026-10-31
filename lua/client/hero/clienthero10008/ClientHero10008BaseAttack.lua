--- @class ClientHero10008BaseAttack : BaseMeleeAttack
ClientHero10008BaseAttack = Class(ClientHero10008BaseAttack, BaseMeleeAttack)

--- @param clientHero ClientHero
function ClientHero10008BaseAttack:Ctor(clientHero)
    BaseMeleeAttack.Ctor(self, clientHero)
end