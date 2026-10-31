require "lua.client.hero.ClientHero60007.ClientHero60007RangeAttack"
require "lua.client.hero.ClientHero60007.ClientHero60007ActiveSkill"

--- Ranatos
--- @class ClientHero60007 : ClientHero
ClientHero60007 = Class(ClientHero60007, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60007:CreateInstance(heroModelType)
    return ClientHero60007(heroModelType)
end

function ClientHero60007:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60007RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(45, 46, 20, 15)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60007ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(78, 79, 50, 45)
    end
end

function ClientHero60007:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero60007:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero60007