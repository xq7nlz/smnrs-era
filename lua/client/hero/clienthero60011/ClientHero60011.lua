require "lua.client.hero.ClientHero60011.ClientHero60011RangeAttack"
require "lua.client.hero.ClientHero60011.ClientHero60011ActiveSkill"

--- Vera
--- @class ClientHero60011 : ClientHero
ClientHero60011 = Class(ClientHero60011, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60011:CreateInstance(heroModelType)
    return ClientHero60011(heroModelType)
end

function ClientHero60011:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60011RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(42, 43, 15, 0)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60011ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(80, 81, 50, 0)
    end
end

function ClientHero60011:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 3)
end

function ClientHero60011:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self,"fx", true, 1)
    ClientHero.PlayAnimation(self,"toc", true, 2)
end

return ClientHero60011