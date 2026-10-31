require "lua.client.hero.ClientHero10020.ClientHero10020RangeAttack"
require "lua.client.hero.ClientHero10020.ClientHero10020ActiveSkill"

--- Blackbeard
--- @class ClientHero10020 : ClientHero
ClientHero10020 = Class(ClientHero10020, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10020:CreateInstance(heroModelType)
    return ClientHero10020(heroModelType)
end

function ClientHero10020:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10020RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(57, 58, 24, 19)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10020ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(72, 73, 48, 38)
    end
end

function ClientHero10020:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero10020:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayStartAnimation(self, "fx", true, 0)
end

return ClientHero10020