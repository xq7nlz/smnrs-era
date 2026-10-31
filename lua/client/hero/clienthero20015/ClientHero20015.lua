require "lua.client.hero.ClientHero20015.ClientHero20015RangeAttack"
require "lua.client.hero.ClientHero20015.ClientHero20015ActiveSkill"

--- Kadul
--- @class ClientHero20015 : ClientHero
ClientHero20015 = Class(ClientHero20015, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20015:CreateInstance(heroModelType)
    return ClientHero20015(heroModelType)
end

function ClientHero20015:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20015RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(45, 46, 26, 21)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20015ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(85, 86, 60, 0)
    end
end

function ClientHero20015:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20015:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero20015