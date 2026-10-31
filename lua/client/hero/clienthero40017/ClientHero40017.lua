require "lua.client.hero.ClientHero40017.ClientHero40017ActiveSkill"
require "lua.client.hero.ClientHero40017.ClientHero40017RangeAttack"

--- Ktul
--- @class ClientHero40017 : ClientHero
ClientHero40017 = Class(ClientHero40017, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40017:CreateInstance(heroModelType)
    return ClientHero40017(heroModelType)
end

function ClientHero40017:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40017RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 24, 19)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40017ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(66, 67, 37, 31)
    end
end

function ClientHero40017:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero40017:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero40017