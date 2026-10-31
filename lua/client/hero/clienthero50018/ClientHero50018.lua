require "lua.client.hero.ClientHero50018.ClientHero50018RangeAttack"
require "lua.client.hero.ClientHero50018.ClientHero50018ActiveSkill"

--- Lucy
--- @class ClientHero50018 ClientHero
ClientHero50018 = Class(ClientHero50018, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50018:CreateInstance(heroModelType)
    return ClientHero50018(heroModelType)
end

function ClientHero50018:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50018RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(60, 61, -1, 27)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50018ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(65, 66, 43, 38)
    end
end

function ClientHero50018:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero50018:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "wing", true, 0)
end

return ClientHero50018