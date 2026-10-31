--- @class ClientHero60006003MeleeAttack : CastOnMovingSkill
ClientHero60006003MeleeAttack = Class(ClientHero60006003MeleeAttack, CastOnMovingSkill)

--- @param clientHero ClientHero
function ClientHero60006003MeleeAttack:Ctor(clientHero)
    CastOnMovingSkill.Ctor(self, clientHero, true, 23, 2)
end
