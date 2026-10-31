require "lua.client.hero.ClientHero30014.ClientHero30014ActiveSkill"
require "lua.client.hero.ClientHero30014.ClientHero30014MeleeAttack"

--- Kargoth
--- @class ClientHero30014 : ClientHero
ClientHero30014 = Class(ClientHero30014, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30014:CreateInstance(heroModelType)
    return ClientHero30014(heroModelType)
end

function ClientHero30014:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30014MeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 22, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30014ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 70, 50, 37)
    end
end

function ClientHero30014:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero30014:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
    ClientHero.PlayAnimation(self, "tail", true, 1)
end

return ClientHero30014