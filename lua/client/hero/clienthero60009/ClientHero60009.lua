require "lua.client.hero.ClientHero60009.ClientHero60009RangeAttack"
require "lua.client.hero.ClientHero60009.ClientHero60009ActiveSkill"

--- Khann
--- @class ClientHero60009 : ClientHero
ClientHero60009 = Class(ClientHero60009, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60009:CreateInstance(heroModelType)
    return ClientHero60009(heroModelType)
end

function ClientHero60009:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60009RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 19, 14)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60009ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(80, 81, 62, 57)
    end
end

function ClientHero60009:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero60009:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
    ClientHero.PlayAnimation(self, "detail", true, 1)
end

return ClientHero60009