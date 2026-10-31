require "lua.client.hero.ClientHero20012.ClientHero20012ActiveSkill"

--- Sharon
--- @class ClientHero20012 : ClientHero
ClientHero20012 = Class(ClientHero20012, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20012:CreateInstance(heroModelType)
    return ClientHero20012(heroModelType)
end

function ClientHero20012:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(34, 35, 13, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20012ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(42, 43, 27, 23)
    end
end

function ClientHero20012:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20012:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero20012