require "lua.client.hero.ClientHero30021.ClientHero30021RangeAttack"
require "lua.client.hero.ClientHero30021.ClientHero30021ActiveSkill"

--- Earth Master
--- @class ClientHero30021 : ClientHero
ClientHero30021 = Class(ClientHero30021, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30021:CreateInstance(heroModelType)
    return ClientHero30021(heroModelType)
end

function ClientHero30021:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30021RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 22, 17)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30021ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(50, 51, 37, -1)
    end
end

function ClientHero30021:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero30021:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
end

return ClientHero30021