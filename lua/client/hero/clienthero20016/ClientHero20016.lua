require "lua.client.hero.ClientHero20016.ClientHero20016ActiveSkill"
require "lua.client.hero.ClientHero20016.ClientHero20016BaseAttack"

--- Ifrit
--- @class ClientHero20016 : ClientHero
ClientHero20016 = Class(ClientHero20016, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20016:CreateInstance(heroModelType)
    return ClientHero20016(heroModelType)
end

function ClientHero20016:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20016BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(45, 46, 16, 16)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20016ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(55, 56, 43, 38)
    end
end

function ClientHero20016:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero20016:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "duoi", true, 1)
    self.animation:SetTrackTime(math.random(0, 130) / 100.0, 0)
    self.animation:SetTrackTime(math.random(0, 130) / 100.0, 1)
end

return ClientHero20016