require "lua.client.hero.ClientHero10002.ClientHero10002RangeAttack"
require "lua.client.hero.ClientHero10002.ClientHero10002ActiveSkill"

--- Silene
--- @class ClientHero10002 : ClientHero
ClientHero10002 = Class(ClientHero10002, ClientHero)

--- @return ClientHero10002
--- @param heroModelType HeroModelType
function ClientHero10002:CreateInstance(heroModelType)
    return ClientHero10002(heroModelType)
end

function ClientHero10002:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10002RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 30, 25)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10002ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(85, 86, 75, 45)
    end
end

return ClientHero10002