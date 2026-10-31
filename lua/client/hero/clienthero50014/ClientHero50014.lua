require "lua.client.hero.ClientHero50014.ClientHero50014RangeAttack"
require "lua.client.hero.ClientHero50014.clientHero50014ActiveSkill"

--- Hweston
--- @class ClientHero50014 : ClientHero
ClientHero50014 = Class(ClientHero50014, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50014:CreateInstance(heroModelType)
    return ClientHero50014(heroModelType)
end

function ClientHero50014:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50014RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(39, 40, 16, 11)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50014ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(65, 66, 36, 31)
    end
end

function ClientHero50014:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero50014:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero50014