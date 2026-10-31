require "lua.client.hero.ClientHero10017.ClientHero10017ActiveSkill"
require "lua.client.hero.ClientHero10017.ClientHero10017BaseAttack"

--- Glugrgly
--- @class ClientHero10017 : ClientHero
ClientHero10017 = Class(ClientHero10017, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10017:CreateInstance(heroModelType)
    return ClientHero10017(heroModelType)
end

function ClientHero10017:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 27, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10017ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 34, 29)
    end
end

function ClientHero10017:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero10017:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero10017