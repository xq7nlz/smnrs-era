require "lua.client.hero.ClientHero40010.ClientHero40010RangeAttack"
require "lua.client.hero.ClientHero40010.ClientHero40010ActiveSkill"

--- Yome
--- @class ClientHero40010 : ClientHero
ClientHero40010 = Class(ClientHero40010, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40010:CreateInstance(heroModelType)
    return ClientHero40010(heroModelType)
end

function ClientHero40010:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40010RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 50, -1, 12)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40010ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(42, 75, -1, 23)
    end
end

function ClientHero40010:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero40010:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "toc", true, 1)
end

return ClientHero40010