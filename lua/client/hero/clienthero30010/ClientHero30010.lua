require "lua.client.hero.ClientHero30010.ClientHero30010RangeAttack"
require "lua.client.hero.ClientHero30010.clientHero30010ActiveSkill"

--- Erde
--- @class ClientHero30010 : ClientHero
ClientHero30010 = Class(ClientHero30010, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30010:CreateInstance(heroModelType)
    return ClientHero30010(heroModelType)
end

function ClientHero30010:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30010RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(54, 55, 39, 34)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30010ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(50, 51, 32, 23)
    end
end

function ClientHero30010:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero30010:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "stone", true, 1)
end

return ClientHero30010