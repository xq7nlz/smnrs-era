require "lua.client.hero.ClientHero20005.ClientHero20005ActiveSkill"
require "lua.client.hero.ClientHero20005.ClientHero20005BaseAttack"

--- Mrrgly
--- @class ClientHero20005 : ClientHero
ClientHero20005 = Class(ClientHero20005, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20005:CreateInstance(heroModelType)
    return ClientHero20005(heroModelType)
end

function ClientHero20005:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20005BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 18, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20005ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(80, 81, 62, -1)
    end
end

function ClientHero20005:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero20005:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
    ClientHero.PlayAnimation(self, "detail", true, 1)
end

return ClientHero20005