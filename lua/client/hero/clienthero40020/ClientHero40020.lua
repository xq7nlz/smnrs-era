require "lua.client.hero.ClientHero40020.ClientHero40020RangeAttack"
require "lua.client.hero.ClientHero40020.ClientHero40020ActiveSkill"

--- Athelas
--- @class ClientHero40020 : ClientHero
ClientHero40020 = Class(ClientHero40020, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40020:CreateInstance(heroModelType)
    return ClientHero40020(heroModelType)
end

function ClientHero40020:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40020RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 18, 13)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40020ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(50, 51, 34, 30)
    end
end

function ClientHero40020:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero40020:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect_fire", true, 0)
end

return ClientHero40020