require "lua.client.hero.ClientHero60025.ClientHero60025RangeAttack"
require "lua.client.hero.ClientHero60025.ClientHero60025ActiveSkill"

--- Drak
--- @class ClientHero60025 : ClientHero
ClientHero60025 = Class(ClientHero60025, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60025:CreateInstance(heroModelType)
    return ClientHero60025(heroModelType)
end

function ClientHero60025:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60025RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(32, 31, 16, 11)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60025ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(57, 58, 39, 36)
    end
end

function ClientHero60025:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero60025:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "leaf", true, 1)
end

return ClientHero60025