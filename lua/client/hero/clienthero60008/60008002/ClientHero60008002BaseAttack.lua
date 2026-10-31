--- @class ClientHero60008002BaseAttack : CastOnMovingSkill
ClientHero60008002BaseAttack = Class(ClientHero60008002BaseAttack, CastOnMovingSkill)

--- @param clientHero ClientHero
function ClientHero60008002BaseAttack:Ctor(clientHero)
    CastOnMovingSkill.Ctor(self, clientHero, true, 5, 13)
end
