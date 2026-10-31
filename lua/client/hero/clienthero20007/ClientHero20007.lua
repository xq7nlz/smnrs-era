require "lua.client.hero.ClientHero20007.ClientHero20007ActiveSkill"
require "lua.client.hero.ClientHero20007.ClientHero20007RangeAttack"

--- NineTales
--- @class ClientHero20007 : ClientHero
ClientHero20007 = Class(ClientHero20007, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20007:CreateInstance(heroModelType)
    return ClientHero20007(heroModelType)
end

function ClientHero20007:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20007RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(60, 61, 35, 30)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20007ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(110, 111, 88, 0)
    end
end

function ClientHero20007:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero20007:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "duoi", true, 1)
end

return ClientHero20007