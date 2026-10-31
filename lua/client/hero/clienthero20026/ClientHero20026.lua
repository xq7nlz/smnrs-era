require "lua.client.hero.ClientHero20026.ClientHero20026RangeAttack"
require "lua.client.hero.ClientHero20026.ClientHero20026ActiveSkill"

--- Kardoh
--- @class ClientHero20026 : ClientHero
ClientHero20026 = Class(ClientHero20026, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20026:CreateInstance(heroModelType)
    return ClientHero20026(heroModelType)
end

function ClientHero20026:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20026RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 20, 16)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20026ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 45, 40)
    end
end

function ClientHero20026:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero20026:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
    ClientHero.PlayAnimation(self, "detail", true, 1)
end

return ClientHero20026