require "lua.client.hero.ClientHero20013.ClientHero20013ActiveSkill"

--- Zeres
--- @class ClientHero20013 : ClientHero
ClientHero20013 = Class(ClientHero20013, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20013:CreateInstance(heroModelType)
    return ClientHero20013(heroModelType)
end

function ClientHero20013:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(45, 46, 17, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20013ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(70, 71, 27, 20)
    end
end

return ClientHero20013