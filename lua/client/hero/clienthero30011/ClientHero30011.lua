require "lua.client.hero.ClientHero30011.ClientHero30011ActiveSkill"
require "lua.client.hero.ClientHero30011.ClientHero30011RangeAttack"

--- Skaven
--- @class ClientHero30011 : ClientHero
ClientHero30011 = Class(ClientHero30011, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30011:CreateInstance(heroModelType)
    return ClientHero30011(heroModelType)
end

function ClientHero30011:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30011RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(60, 61, -1, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30011ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(90, 91, 73, -1)
    end
end

return ClientHero30011