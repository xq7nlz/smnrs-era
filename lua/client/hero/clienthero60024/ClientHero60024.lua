require "lua.client.hero.ClientHero60024.ClientHero60024RangeAttack"
require "lua.client.hero.ClientHero60024.ClientHero60024ActiveSkill"

--- DarkPriest
--- @class ClientHero60024 : ClientHero
ClientHero60024 = Class(ClientHero60024, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60024:CreateInstance(heroModelType)
    return ClientHero60024(heroModelType)
end

function ClientHero60024:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60024RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(20, 21, 12, 7)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60024ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(45, 46, 32, 27)
    end
end

return ClientHero60024