--- @class ClientHero60006004MeleeAttack : CastOnMovingSkill
ClientHero60006004MeleeAttack = Class(ClientHero60006004MeleeAttack, CastOnMovingSkill)

--- @param clientHero ClientHero
function ClientHero60006004MeleeAttack:Ctor(clientHero)
    CastOnMovingSkill.Ctor(self, clientHero, true, 23, 2)
end
