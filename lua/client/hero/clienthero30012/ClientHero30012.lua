require "lua.client.hero.ClientHero30012.ClientHero30012ActiveSkill"
require "lua.client.hero.ClientHero30012.ClientHero30012RangeAttack"

--- Dzu-Teh
--- @class ClientHero30012 : ClientHero
ClientHero30012 = Class(ClientHero30012, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30012:CreateInstance(heroModelType)
    return ClientHero30012(heroModelType)
end

function ClientHero30012:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30012RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 25, 20)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30012ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 44, -1)
    end
end

function ClientHero30012:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero30012:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
end

return ClientHero30012