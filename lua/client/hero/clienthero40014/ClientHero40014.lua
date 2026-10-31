require "lua.client.hero.ClientHero40014.ClientHero40014ActiveSkill"

--- Tess
--- @class ClientHero40014 : ClientHero
ClientHero40014 = Class(ClientHero40014, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40014:CreateInstance(heroModelType)
    return ClientHero40014(heroModelType)
end

function ClientHero40014:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(24, 25, 11, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40014ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 43, 42)
    end
end

function ClientHero40014:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero40014:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "duoi", true, 0)
end

return ClientHero40014