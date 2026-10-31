require "lua.client.hero.ClientHero60001.ClientHero60001RangeAttack"
require "lua.client.hero.ClientHero60001.ClientHero60001ActiveSkill"

--- Morna
--- @class ClientHero60001 : ClientHero
ClientHero60001 = Class(ClientHero60001, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60001:CreateInstance(heroModelType)
    return ClientHero60001(heroModelType)
end

function ClientHero60001:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60001RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(55, 56, 36, 31)
    end
    if self.heroModelType >= HeroModelType.Full then

            self.skillAttack = ClientHero60001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 81, 65, 31)

    end
end

function ClientHero60001:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero60001:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self,"fx", true, 0)
end

return ClientHero60001