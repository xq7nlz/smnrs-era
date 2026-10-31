require "lua.client.hero.ClientHero50016.ClientHero50016RangeAttack"
require "lua.client.hero.ClientHero50016.ClientHero50016ActiveSkill"

--- LightMage
--- @class ClientHero50016 : ClientHero
ClientHero50016 = Class(ClientHero50016, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50016:CreateInstance(heroModelType)
    return ClientHero50016(heroModelType)
end

function ClientHero50016:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50016RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(45, 46, 23, 16)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50016ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(65, 66,43 , 36)
    end
end

function ClientHero50016:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero50016:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "vatao", true, 1)
end

return ClientHero50016