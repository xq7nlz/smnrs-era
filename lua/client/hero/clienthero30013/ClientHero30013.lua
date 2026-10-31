require "lua.client.hero.ClientHero30013.ClientHero30013ActiveSkill"
require "lua.client.hero.ClientHero30013.ClientHero30013MeleeAttack"

--- Minimanser
--- @class ClientHero30013 : ClientHero
ClientHero30013 = Class(ClientHero30013, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30013:CreateInstance(heroModelType)
    return ClientHero30013(heroModelType)
end

function ClientHero30013:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30013MeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 45, 13, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30013ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(45, 50, 29, 23)
    end
end

return ClientHero30013