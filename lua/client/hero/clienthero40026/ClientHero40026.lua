require "lua.client.hero.ClientHero40026.ClientHero40026ActiveSkill"
require "lua.client.hero.ClientHero40026.ClientHero40026BaseAttack"

--- Neyuh
--- @class ClientHero40026 : ClientHero
ClientHero40026 = Class(ClientHero40026, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40026:CreateInstance(heroModelType)
    return ClientHero40026(heroModelType)
end

function ClientHero40026:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40026BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(65, 66, 34, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40026ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(70, 75, 52, 52)
    end
end

function ClientHero40026:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 3)
end

function ClientHero40026:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
end

return ClientHero40026