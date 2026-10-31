require "lua.client.hero.ClientHero40013.ClientHero40013ActiveSkill"

--- Nature Mage
--- @class ClientHero40013 : ClientHero
ClientHero40013 = Class(ClientHero40013, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40013:CreateInstance(heroModelType)
    return ClientHero40013(heroModelType)
end

function ClientHero40013:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 14, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40013ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(48, 49, 23, 18)
    end
end

function ClientHero40013:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero40013:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "vatao", true, 0)
end

return ClientHero40013