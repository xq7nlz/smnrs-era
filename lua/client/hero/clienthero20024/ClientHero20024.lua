require "lua.client.hero.ClientHero20024.ClientHero20024ActiveSkill"

--- Yasin
--- @class ClientHero20024 : ClientHero
ClientHero20024 = Class(ClientHero20024, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20024:CreateInstance(heroModelType)
    return ClientHero20024(heroModelType)
end

function ClientHero20024:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 13, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20024ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(73, 74, 39, 0)
    end
end

function ClientHero20024:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero20024:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "toc", true, 1)
end

return ClientHero20024