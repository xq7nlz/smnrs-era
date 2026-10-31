require "lua.client.hero.ClientHero50005.ClientHero50005ActiveSkill"
require "lua.client.hero.ClientHero50005.ClientHero50005BaseAttack"

--- Odreus
--- @class ClientHero50005 : ClientHero
ClientHero50005 = Class(ClientHero50005, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50005:CreateInstance(heroModelType)
    return ClientHero50005(heroModelType)
end

function ClientHero50005:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50005BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 18, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50005ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 34, 5)
    end
end

function ClientHero50005:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero50005:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
end

return ClientHero50005