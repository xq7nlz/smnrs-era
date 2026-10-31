--- @class ClientHero60006003BaseAttack : CastOnMovingSkill
ClientHero60006003BaseAttack = Class(ClientHero60006003BaseAttack, CastOnMovingSkill)

--- @param clientHero ClientHero
function ClientHero60006003BaseAttack:Ctor(clientHero)
    CastOnMovingSkill.Ctor(self, clientHero, true, 21, 2)
end
