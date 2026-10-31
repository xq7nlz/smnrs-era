require "lua.client.hero.ClientHero20022.ClientHero20022RangeAttack"
require "lua.client.hero.ClientHero20022.ClientHero20022ActiveSkill"

--- Imp
--- @class ClientHero20022 : ClientHero
ClientHero20022 = Class(ClientHero20022, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20022:CreateInstance(heroModelType)
    return ClientHero20022(heroModelType)
end

function ClientHero20022:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20022RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 17, 12)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20022ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(50, 51, 26, 1)
    end
end

function ClientHero20022:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20022:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect_fire", true, 0)
end

return ClientHero20022