require "lua.client.hero.ClientHero10011.ClientHero10011ActiveSkill"
require "lua.client.hero.ClientHero10011.ClientHero10011RangeAttack"

--- Jeronim
--- @class ClientHero10011 : ClientHero
ClientHero10011 = Class(ClientHero10011, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10011:CreateInstance(heroModelType)
    return ClientHero10011(heroModelType)
end

function ClientHero10011:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10011RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 39, 34)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10011ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(93, 94, 59, 54)
    end
end

return ClientHero10011