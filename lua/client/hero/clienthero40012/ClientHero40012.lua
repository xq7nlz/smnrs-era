require "lua.client.hero.ClientHero40012.ClientHero40012ActiveSkill"
require "lua.client.hero.ClientHero40012.ClientHero40012RangeAttack"

--- Lithiriel
--- @class ClientHero40012 : ClientHero
ClientHero40012 = Class(ClientHero40012, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40012:CreateInstance(heroModelType)
    return ClientHero40012(heroModelType)
end

function ClientHero40012:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40012RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(44, 45, 20, 15)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40012ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(85, 86, 58, -1)
    end
end

return ClientHero40012