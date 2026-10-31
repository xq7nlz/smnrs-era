require "lua.client.hero.ClientHero30026.ClientHero30026RangeAttack"
require "lua.client.hero.ClientHero30026.ClientHero30026ActiveSkill"

--- Vlad
--- @class ClientHero30026 : ClientHero
ClientHero30026 = Class(ClientHero30026, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30026:CreateInstance(heroModelType)
    return ClientHero30026(heroModelType)
end

function ClientHero30026:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30026RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 17, 12)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30026ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 47, 42)
    end
end

function ClientHero30026:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero30026:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
    ClientHero.PlayAnimation(self, "detail", true, 1)
    self.animation:SetTrackTime(math.random(0, 260) / 100.0, 1)
end

return ClientHero30026