require "lua.client.hero.ClientHero50010.ClientHero50010RangeAttack"
require "lua.client.hero.ClientHero50010.ClientHero50010ActiveSkill"

--- Sephion
--- @class ClientHero50010 : ClientHero
ClientHero50010 = Class(ClientHero50010, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50010:CreateInstance(heroModelType)
    return ClientHero50010(heroModelType)
end

function ClientHero50010:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50010RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 17, 12)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50010ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 80, 65, 44)
    end
end

return ClientHero50010