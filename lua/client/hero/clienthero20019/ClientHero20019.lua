require "lua.client.hero.ClientHero20019.ClientHero20019ActiveSkill"

--- Golr
--- @class ClientHero20019 : ClientHero
ClientHero20019 = Class(ClientHero20019, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20019:CreateInstance(heroModelType)
    return ClientHero20019(heroModelType)
end

function ClientHero20019:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(54, 55, 17, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20019ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(58, 59, 28, 0)
    end
end

function ClientHero20019:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20019:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero20019