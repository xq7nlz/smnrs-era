require "lua.client.hero.ClientHero20003.ClientHero20003ActiveSkill"

--- Eitri
--- @class ClientHero20003 : ClientHero
ClientHero20003 = Class(ClientHero20003, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20003:CreateInstance(heroModelType)
    return ClientHero20003(heroModelType)
end

function ClientHero20003:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(52, 53, 26, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20003ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(74, 75, 44, -1)
    end
end

function ClientHero20003:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20003:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero20003