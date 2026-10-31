require "lua.client.hero.ClientHero60014.ClientHero60014RangeAttack"
require "lua.client.hero.ClientHero60014.ClientHero60014ActiveSkill"

--- Skishil
--- @class ClientHero60014 : ClientHero
ClientHero60014 = Class(ClientHero60014, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60014:CreateInstance(heroModelType)
    return ClientHero60014(heroModelType)
end

function ClientHero60014:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60014RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 17, 12)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60014ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 48, 43)
    end
end

return ClientHero60014