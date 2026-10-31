--- @class ClientHero60006002BaseAttack : CastOnMovingSkill
ClientHero60006002BaseAttack = Class(ClientHero60006002BaseAttack, CastOnMovingSkill)

--- @param clientHero ClientHero
function ClientHero60006002BaseAttack:Ctor(clientHero)
    CastOnMovingSkill.Ctor(self, clientHero, true, 21, 2)
end
