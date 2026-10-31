require "lua.client.hero.ClientHero20010.ClientHero20010ActiveSkill"
require "lua.client.hero.ClientHero20010.ClientHero20010MeleeAttack"

--- Ungoliant
--- @class ClientHero20010 : ClientHero
ClientHero20010 = Class(ClientHero20010, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20010:CreateInstance(heroModelType)
    return ClientHero20010(heroModelType)
end

function ClientHero20010:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20010MeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 20, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20010ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(75, 76, 30, -1)
    end
end

return ClientHero20010