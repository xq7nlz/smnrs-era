require "lua.client.hero.ClientHero20018.ClientHero20018ActiveSkill"

--- FireSpirit
--- @class ClientHero20018 : ClientHero
ClientHero20018 = Class(ClientHero20018, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20018:CreateInstance(heroModelType)
    return ClientHero20018(heroModelType)
end

function ClientHero20018:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseRangeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 25, 20)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20018ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(80, 81, 49, 44)
    end
end

function ClientHero20018:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20018:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero20018