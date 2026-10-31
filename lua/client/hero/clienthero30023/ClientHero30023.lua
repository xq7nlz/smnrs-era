require "lua.client.hero.ClientHero30023.ClientHero30023RangeAttack"
require "lua.client.hero.ClientHero30023.ClientHero30023ActiveSkill"

--- Dr.Plague
--- @class ClientHero30023 : ClientHero
ClientHero30023 = Class(ClientHero30023, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30023:CreateInstance(heroModelType)
    return ClientHero30023(heroModelType)
end

function ClientHero30023:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30023RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, -1, 22)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30023ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(80, 81, 60, 55)
    end
end

function ClientHero30023:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero30023:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero30023