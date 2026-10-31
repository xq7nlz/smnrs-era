require "lua.client.hero.ClientHero50009.ClientHero50009ActiveSkill"
require "lua.client.hero.ClientHero50009.ClientHero50009RangeAttack"

--- Aris
--- @class ClientHero50009 : ClientHero
ClientHero50009 = Class(ClientHero50009, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50009:CreateInstance(heroModelType)
    return ClientHero50009(heroModelType)
end

function ClientHero50009:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50009RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(55, 56, 39, 34)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50009ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(80, 81, 59, -1)
    end
end

function ClientHero50009:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero50009:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero50009