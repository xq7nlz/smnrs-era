require "lua.client.hero.ClientHero10016.ClientHero10016ActiveSkill"

--- Croconile
--- @class ClientHero10016 : ClientHero
ClientHero10016 = Class(ClientHero10016, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10016:CreateInstance(heroModelType)
    return ClientHero10016(heroModelType)
end

function ClientHero10016:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 12, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10016ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(102, 103, 51, 42)
    end
end

function ClientHero10016:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero10016:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "duoi", true, 1)
end

return ClientHero10016