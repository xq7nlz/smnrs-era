require "lua.client.hero.ClientHero60019.ClientHero60019RangeAttack"
require "lua.client.hero.ClientHero60019.ClientHero60019ActiveSkill"

--- Reji
--- @class ClientHero60019 : ClientHero
ClientHero60019 = Class(ClientHero60019, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60019:CreateInstance(heroModelType)
    return ClientHero60019(heroModelType)
end

function ClientHero60019:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60019RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(36, 37, 21, 16)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60019ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(50, 51, 22, -1)
    end
end

function ClientHero60019:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero60019:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
end

return ClientHero60019