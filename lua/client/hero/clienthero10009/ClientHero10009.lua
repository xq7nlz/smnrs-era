require "lua.client.hero.ClientHero10009.ClientHero10009RangeAttack"
require "lua.client.hero.ClientHero10009.ClientHero10009ActiveSkill"

--- Lashna
--- @class ClientHero10009 : ClientHero
ClientHero10009 = Class(ClientHero10009, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10009:CreateInstance(heroModelType)
    return ClientHero10009(heroModelType)
end

function ClientHero10009:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10009RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(60, 61, -1, 30)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10009ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(72, 73, 66, 46)
    end
end

function ClientHero10009:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero10009:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "xuctu", true, 1)
end

return ClientHero10009