require "lua.client.hero.ClientHero40021.ClientHero40021ActiveSkill"

--- Titi
--- @class ClientHero40021 : ClientHero
ClientHero40021 = Class(ClientHero40021, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40021:CreateInstance(heroModelType)
    return ClientHero40021(heroModelType)
end

function ClientHero40021:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 20, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40021ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(50, 51, 23, 18)
    end
end

function ClientHero40021:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero40021:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "duoi", true, 0)
end

return ClientHero40021