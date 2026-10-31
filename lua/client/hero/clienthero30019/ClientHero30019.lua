require "lua.client.hero.ClientHero30019.ClientHero30019BaseAttack"
require "lua.client.hero.ClientHero30019.ClientHero30019ActiveSkill"

--- Elne
--- @class ClientHero30019 : ClientHero
ClientHero30019 = Class(ClientHero30019, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30019:CreateInstance(heroModelType)
    return ClientHero30019(heroModelType)
end

function ClientHero30019:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30019BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(45, 56, 33, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30019ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 47, 42)
    end
end

return ClientHero30019