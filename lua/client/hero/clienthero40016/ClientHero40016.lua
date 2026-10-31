require "lua.client.hero.ClientHero40016.ClientHero40016RangeAttack"
require "lua.client.hero.ClientHero40016.ClientHero40016ActiveSkill"

--- Roo
--- @class ClientHero40016 : ClientHero
ClientHero40016 = Class(ClientHero40016, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40016:CreateInstance(heroModelType)
    return ClientHero40016(heroModelType)
end

function ClientHero40016:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40016RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(36, 37, 23, 18)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40016ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(53, 54, 26, 0)
    end
end

return ClientHero40016