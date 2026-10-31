require "lua.client.hero.ClientHero50013.ClientHero50013RangeAttack"
require "lua.client.hero.ClientHero50013.ClientHero50013ActiveSkill"

--- Celes
--- @class ClientHero50013 : ClientHero
ClientHero50013 = Class(ClientHero50013, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50013:CreateInstance(heroModelType)
    return ClientHero50013(heroModelType)
end

function ClientHero50013:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50013RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(76, 77, 40, 35)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50013ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(86, 87, 50, 45)
    end
end

function ClientHero50013:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero50013:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "ao", true, 1)
end

return ClientHero50013