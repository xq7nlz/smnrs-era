require "lua.client.hero.ClientHero60022.ClientHero60022ActiveSkill"

--- Dead Servant
--- @class ClientHero60022 : ClientHero
ClientHero60022 = Class(ClientHero60022, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60022:CreateInstance(heroModelType)
    return ClientHero60022(heroModelType)
end

function ClientHero60022:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 22, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60022ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 42, 0)
    end
end

function ClientHero60022:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero60022:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
    ClientHero.PlayAnimation(self, "detail", true, 1)
end

return ClientHero60022