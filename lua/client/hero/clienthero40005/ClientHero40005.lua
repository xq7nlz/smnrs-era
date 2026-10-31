require "lua.client.hero.ClientHero40005.ClientHero40005RangeAttack"
require "lua.client.hero.ClientHero40005.ClientHero40005ActiveSkill"

--- Yang
--- @class ClientHero40005 : ClientHero
ClientHero40005 = Class(ClientHero40005, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40005:CreateInstance(heroModelType)
    return ClientHero40005(heroModelType)
end

function ClientHero40005:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40005RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(48, 49, 23, 18)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40005ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(100, 101, 68, 23)
    end
end

function ClientHero40005:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 3)
end

function ClientHero40005:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "toc", true, 0)
end

return ClientHero40005