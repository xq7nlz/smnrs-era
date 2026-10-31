require "lua.client.hero.ClientHero60017.ClientHero60017ActiveSkill"
require "lua.client.hero.ClientHero60017.ClientHero60017RangeAttack"

--- Halda
--- @class ClientHero60017 : ClientHero
ClientHero60017 = Class(ClientHero60017, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60017:CreateInstance(heroModelType)
    return ClientHero60017(heroModelType)
end

function ClientHero60017:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60017RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(60, 61, 27, 22)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60017ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(105, 106, 66, 61)
    end
end

return ClientHero60017