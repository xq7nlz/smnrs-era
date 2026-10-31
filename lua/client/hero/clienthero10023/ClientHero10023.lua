require "lua.client.hero.ClientHero10023.ClientHero10023ActiveSkill"

--- Krag
--- @class ClientHero10023 : ClientHero
ClientHero10023 = Class(ClientHero10023, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10023:CreateInstance(heroModelType)
    return ClientHero10023(heroModelType)
end
function ClientHero10023:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 13, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10023ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(94, 95, 60, 30)
    end
end

function ClientHero10023:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero10023:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "vat ao", true, 0)
end

return ClientHero10023