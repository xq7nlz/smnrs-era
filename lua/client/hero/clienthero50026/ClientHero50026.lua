require "lua.client.hero.ClientHero50026.ClientHero50026RangeAttack"
require "lua.client.hero.ClientHero50026.ClientHero50026ActiveSkill"

--- Fioneth
--- @class ClientHero50026 : ClientHero
ClientHero50026 = Class(ClientHero50026, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50026:CreateInstance(heroModelType)
    return ClientHero50026(heroModelType)
end

function ClientHero50026:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50026RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(60, 61, 46, 41)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50026ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(94, 95, 72, 68)
    end
end

return ClientHero50026