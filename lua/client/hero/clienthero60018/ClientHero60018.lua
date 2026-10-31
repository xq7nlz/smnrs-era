require "lua.client.hero.ClientHero60018.ClientHero60018RangeAttack"
require "lua.client.hero.ClientHero60018.ClientHero60018ActiveSkill"

--- Gwarth
--- @class ClientHero60018 : ClientHero
ClientHero60018 = Class(ClientHero60018, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60018:CreateInstance(heroModelType)
    return ClientHero60018(heroModelType)
end

function ClientHero60018:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60018RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 18, 13)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60018ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(56, 65, 53, 50)
    end
end

function ClientHero60018:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero60018:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "vay", true, 1)
end

return ClientHero60018