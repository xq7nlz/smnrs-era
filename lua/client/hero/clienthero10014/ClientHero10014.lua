require "lua.client.hero.ClientHero10014.ClientHero10014ActiveSkill"
require "lua.client.hero.ClientHero10014.ClientHero10014RangeAttack"

--- Ice Master
--- @class ClientHero10014 : ClientHero
ClientHero10014 = Class(ClientHero10014, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10014:CreateInstance(heroModelType)
    return ClientHero10014(heroModelType)
end

function ClientHero10014:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10014RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 29, 24)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10014ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 49, 44)
    end
end

return ClientHero10014