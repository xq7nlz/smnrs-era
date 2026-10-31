require "lua.client.hero.ClientHero10015.ClientHero10015RangeAttack"
require "lua.client.hero.ClientHero10015.ClientHero10015ActiveSkill"

--- Aesa
--- @class ClientHero10015 : ClientHero
ClientHero10015 = Class(ClientHero10015, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10015:CreateInstance(heroModelType)
    return ClientHero10015(heroModelType)
end

function ClientHero10015:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10015RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(55, 56, 32, 27)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10015ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(67, 68, 38, 28)
    end
end

return ClientHero10015