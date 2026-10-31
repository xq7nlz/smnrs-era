--- @class ClientHero60006002MeleeAttack : CastOnMovingSkill
ClientHero60006002MeleeAttack = Class(ClientHero60006002MeleeAttack, CastOnMovingSkill)

--- @param clientHero ClientHero
function ClientHero60006002MeleeAttack:Ctor(clientHero)
    CastOnMovingSkill.Ctor(self, clientHero, true, 23, 2)
end
