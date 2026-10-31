require "lua.client.hero.ClientHero40019.ClientHero40019RangeAttack"
require "lua.client.hero.ClientHero40019.ClientHero40019ActiveSkill"

--- Lith
--- @class ClientHero40019 : ClientHero
ClientHero40019 = Class(ClientHero40019, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40019:CreateInstance(heroModelType)
    return ClientHero40019(heroModelType)
end

function ClientHero40019:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40019RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(33, 34, 17, 12)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40019ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(63, 64, 47, 42)
    end
end

function ClientHero40019:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero40019:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero40019