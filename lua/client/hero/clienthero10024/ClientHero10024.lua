require "lua.client.hero.ClientHero10024.ClientHero10024RangeAttack"
require "lua.client.hero.ClientHero10024.ClientHero10024ActiveSkill"

--- Gurrgly
--- @class ClientHero10024 : ClientHero
ClientHero10024 = Class(ClientHero10024, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10024:CreateInstance(heroModelType)
    return ClientHero10024(heroModelType)
end

function ClientHero10024:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10024RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(35, 45, 33, 28)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10024ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(55, 56, 46, 41)
    end
end

return ClientHero10024