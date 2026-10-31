require "lua.client.hero.ClientHero20004.ClientHero20004ActiveSkill"

--- Defronowe
--- @class ClientHero20004 : ClientHero
ClientHero20004 = Class(ClientHero20004, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20004:CreateInstance(heroModelType)
    return ClientHero20004(heroModelType)
end

function ClientHero20004:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(37, 38, 18, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20004ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(88, 91, 44, -1)
    end
end

return ClientHero20004