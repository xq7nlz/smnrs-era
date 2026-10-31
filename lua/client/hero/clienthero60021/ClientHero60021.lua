require "lua.client.hero.ClientHero60021.ClientHero60021ActiveSkill"
require "lua.client.hero.ClientHero60021.ClientHero60021RangeAttack"

--- Dark Archer
--- @class ClientHero60021 : ClientHero
ClientHero60021 = Class(ClientHero60021, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60021:CreateInstance(heroModelType)
    return ClientHero60021(heroModelType)
end

function ClientHero60021:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60021RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 21, 16)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60021ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(76, 77, 57, 52)
    end
end

function ClientHero60021:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero60021:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
end

return ClientHero60021