require "lua.client.hero.ClientHero50012.ClientHero50012RangeAttack"
require "lua.client.hero.ClientHero50012.ClientHero50012ActiveSkill"

--- Alvar
--- @class ClientHero50012 : ClientHero
ClientHero50012 = Class(ClientHero50012, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50012:CreateInstance(heroModelType)
    return ClientHero50012(heroModelType)
end

function ClientHero50012:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50012RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 17, 12)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50012ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 71, 54, 0)
    end
end

function ClientHero50012:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero50012:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
    ClientHero.PlayAnimation(self, "detail", true, 1)
end

return ClientHero50012