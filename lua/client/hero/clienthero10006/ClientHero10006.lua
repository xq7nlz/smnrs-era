require "lua.client.hero.ClientHero10006.ClientHero10006ActiveSkill"
require "lua.client.hero.ClientHero10006.ClientHero10006BaseAttack"

--- Aqualord
--- @class ClientHero10006 : ClientHero
ClientHero10006 = Class(ClientHero10006, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10006:CreateInstance(heroModelType)
    return ClientHero10006(heroModelType)
end

function ClientHero10006:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10006BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 20, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10006ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(70, 71, 35, 0)
    end
end

function ClientHero10006:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero10006:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self,"effect", true, 0)
end

return ClientHero10006