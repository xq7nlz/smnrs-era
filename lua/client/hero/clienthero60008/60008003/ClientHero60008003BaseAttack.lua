require "lua.client.hero.ClientHero60008.60008002.ClientHero60008002BaseAttack"
--- @class ClientHero60008003BaseAttack : ClientHero60008002BaseAttack
ClientHero60008003BaseAttack = Class(ClientHero60008003BaseAttack, ClientHero60008002BaseAttack)

--- @param clientHero ClientHero
function ClientHero60008003BaseAttack:Ctor(clientHero)
	CastOnMovingSkill.Ctor(self, clientHero, true, 5, 7)
end
