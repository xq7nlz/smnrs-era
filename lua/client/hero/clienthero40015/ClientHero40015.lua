require "lua.client.hero.ClientHero40015.ClientHero40015ActiveSkill"
require "lua.client.hero.ClientHero40015.ClientHero40015BaseAttack"

--- Berko
--- @class ClientHero40015 : ClientHero
ClientHero40015 = Class(ClientHero40015, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40015:CreateInstance(heroModelType)
    return ClientHero40015(heroModelType)
end

function ClientHero40015:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 21, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40015ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(55, 56, 35, -1)
    end
end

return ClientHero40015