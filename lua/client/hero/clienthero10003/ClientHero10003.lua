require "lua.client.hero.ClientHero10003.ClientHero10003RangeAttack"
require "lua.client.hero.ClientHero10003.ClientHero10003ActiveSkill"

--- Raina
--- @class ClientHero10003 : ClientHero
ClientHero10003 = Class(ClientHero10003, ClientHero)

--- @return ClientHero10003
--- @param heroModelType HeroModelType
function ClientHero10003:CreateInstance(heroModelType)
    return ClientHero10003(heroModelType)
end

function ClientHero10003:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10003RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(51, 52, 33, 26)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10003ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(90, 100, 73, 53)
    end
end

return ClientHero10003