require "lua.client.hero.ClientHero20021.ClientHero20021RangeAttack"
require "lua.client.hero.ClientHero20021.ClientHero20021ActiveSkill"

--- Cain
--- @class ClientHero20021 : ClientHero
ClientHero20021 = Class(ClientHero20021, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20021:CreateInstance(heroModelType)
    return ClientHero20021(heroModelType)
end

function ClientHero20021:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20021RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 26, 21)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20021ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 46, 41)
    end
end

return ClientHero20021