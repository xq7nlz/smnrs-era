require "lua.client.hero.ClientHero20008.ClientHero20008ActiveSkill"
require "lua.client.hero.ClientHero20008.ClientHero20008BaseAttack"

--- Moblin
--- @class ClientHero20008 : ClientHero
ClientHero20008 = Class(ClientHero20008, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20008:CreateInstance(heroModelType)
    return ClientHero20008(heroModelType)
end

function ClientHero20008:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20008BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(68, 69, 30, 25)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20008ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(80, 81, 50, 39)
    end
end

function ClientHero20008:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20008:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self,"fx", true, 0)
end

return ClientHero20008