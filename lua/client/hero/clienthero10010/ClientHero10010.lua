require "lua.client.hero.ClientHero10010.ClientHero10010ActiveSkill"

--- Japulan
--- @class ClientHero10010 : ClientHero
ClientHero10010 = Class(ClientHero10010, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10010:CreateInstance(heroModelType)
    return ClientHero10010(heroModelType)
end

function ClientHero10010:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(34, 35, 11, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10010ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(59, 72, 30, 0)
    end
end

function ClientHero10010:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero10010:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "xuctu", true, 1)
end

return ClientHero10010