require "lua.client.hero.ClientHero40022.ClientHero40022RangeAttack"
require "lua.client.hero.ClientHero40022.ClientHero40022ActiveSkill"

--- Arawen
--- @class ClientHero40022 : ClientHero
ClientHero40022 = Class(ClientHero40022, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40022:CreateInstance(heroModelType)
    return ClientHero40022(heroModelType)
end

function ClientHero40022:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40022RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 29, 24)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40022ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(70, 71, 55, 32)
    end
end

function ClientHero40022:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero40022:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "motion", true, 0)
    ClientHero.PlayAnimation(self, "effect", true, 1)
end

return ClientHero40022