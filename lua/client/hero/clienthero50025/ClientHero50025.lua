require "lua.client.hero.ClientHero50025.ClientHero50025ActiveSkill"

--- Avorn
--- @class ClientHero50025 : ClientHero
ClientHero50025 = Class(ClientHero50025, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50025:CreateInstance(heroModelType)
    return ClientHero50025(heroModelType)
end

function ClientHero50025:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(37, 38, 12, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50025ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(52, 60, 43, 38)
    end
end

function ClientHero50025:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero50025:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "toc", true, 1)
end

return ClientHero50025