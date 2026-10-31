require "lua.client.hero.ClientHero10021.ClientHero10021ActiveSkill"

--- AquaKnight
--- @class ClientHero10021 : ClientHero
ClientHero10021 = Class(ClientHero10021, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10021:CreateInstance(heroModelType)
    return ClientHero10021(heroModelType)
end

function ClientHero10021:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(34, 35, 13, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10021ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(56, 57, 31, -1)
    end
end

function ClientHero10021:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero10021:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero10021