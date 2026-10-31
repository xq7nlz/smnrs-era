require "lua.client.hero.ClientHero50023.ClientHero50023ActiveSkill"

--- Felina
--- @class ClientHero50023 : ClientHero
ClientHero50023 = Class(ClientHero50023, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50023:CreateInstance(heroModelType)
    return ClientHero50023(heroModelType)
end
function ClientHero50023:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(42, 43, 13, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50023ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(71, 72, 33, 30)
    end
end

function ClientHero50023:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero50023:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "hair", true, 1)
end

return ClientHero50023