require "lua.client.hero.ClientHero20020.ClientHero20020ActiveSkill"

--- Ira
--- @class IS.ClientHero20020 : ClientHero
ClientHero20020 = Class(ClientHero20020, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20020:CreateInstance(heroModelType)
    return ClientHero20020(heroModelType)
end

function ClientHero20020:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(54, 55, 12, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20020ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 65, 30, 20)
    end
end

function ClientHero20020:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero20020:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "stone", true, 1)
end

return ClientHero20020