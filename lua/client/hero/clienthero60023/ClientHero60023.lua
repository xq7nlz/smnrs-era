require "lua.client.hero.ClientHero60023.ClientHero60023ActiveSkill"

--- Sytak
--- @class ClientHero60023 : ClientHero
ClientHero60023 = Class(ClientHero60023, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60023:CreateInstance(heroModelType)
    return ClientHero60023(heroModelType)
end

function ClientHero60023:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 12, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60023ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(50, 51, 37, 32)
    end
end

function ClientHero60023:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero60023:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
end

return ClientHero60023