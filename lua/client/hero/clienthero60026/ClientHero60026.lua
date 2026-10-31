require "lua.client.hero.ClientHero60026.ClientHero60026ActiveSkill"
require "lua.client.hero.ClientHero60026.ClientHero60026RangeAttack"

--- Ghunon
--- @class ClientHero60026 : ClientHero
ClientHero60026 = Class(ClientHero60026, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60026:CreateInstance(heroModelType)
    return ClientHero60026(heroModelType)
end

function ClientHero60026:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60026RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 25, 20)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60026ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(86, 87, 60, 20)
    end
end

function ClientHero60026:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero60026:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero60026