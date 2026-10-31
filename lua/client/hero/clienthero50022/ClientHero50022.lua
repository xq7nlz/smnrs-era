require "lua.client.hero.ClientHero50022.ClientHero50022RangeAttack"
require "lua.client.hero.ClientHero50022.ClientHero50022ActiveSkill"

--- Vaina
--- @class ClientHero50022 : ClientHero
ClientHero50022 = Class(ClientHero50022, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50022:CreateInstance(heroModelType)
    return ClientHero50022(heroModelType)
end

function ClientHero50022:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50022RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 21, 16)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50022ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 43, -1)
    end
end

function ClientHero50022:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero50022:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "detail", true, 0)
end

return ClientHero50022