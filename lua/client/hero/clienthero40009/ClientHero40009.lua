require "lua.client.hero.ClientHero40009.ClientHero40009BaseAttack"
require "lua.client.hero.ClientHero40009.ClientHero40009ActiveSkill"

--- Sylph
--- @class ClientHero40009 : ClientHero
ClientHero40009 = Class(ClientHero40009, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40009:CreateInstance(heroModelType)
    return ClientHero40009(heroModelType)
end

function ClientHero40009:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40009BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(58, 61, -1, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40009ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(85, 86, 40, 0)
    end
end

return ClientHero40009