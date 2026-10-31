--- @class ClientHero60006004BaseAttack : CastOnMovingSkill
ClientHero60006004BaseAttack = Class(ClientHero60006004BaseAttack, CastOnMovingSkill)

--- @param clientHero ClientHero
function ClientHero60006004BaseAttack:Ctor(clientHero)
    CastOnMovingSkill.Ctor(self, clientHero, true, 21, 2)
end
