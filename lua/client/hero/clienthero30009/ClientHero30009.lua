require "lua.client.hero.ClientHero30009.ClientHero30009RangeAttack"
require "lua.client.hero.ClientHero30009.ClientHero30009ActiveSkill"

--- Gorzodin
--- @class ClientHero30009 : ClientHero
ClientHero30009 = Class(ClientHero30009, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30009:CreateInstance(heroModelType)
    return ClientHero30009(heroModelType)
end

function ClientHero30009:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30009RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(55, 56, 37, 32)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30009ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(90, 115, 100, 55)
    end
end

return ClientHero30009