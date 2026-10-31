require "lua.client.hero.ClientHero20014.ClientHero20014ActiveSkill"
require "lua.client.hero.ClientHero20014.ClientHero20014RangeAttack"

--- Khezzec
--- @class ClientHero20014 : ClientHero
ClientHero20014 = Class(ClientHero20014, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20014:CreateInstance(heroModelType)
    return ClientHero20014(heroModelType)
end

function ClientHero20014:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20014RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 25, 20)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20014ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(87, 88, 40, 35)
    end
end

function ClientHero20014:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20014:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero20014