require "lua.client.hero.ClientHero20011.ClientHero20011ActiveSkill"
require "lua.client.hero.ClientHero20011.ClientHero20011MeleeAttack"

--- Bran
--- @class ClientHero20011 : ClientHero
ClientHero20011 = Class(ClientHero20011, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20011:CreateInstance(heroModelType)
    return ClientHero20011(heroModelType)
end

function ClientHero20011:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20011MeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(55, 56, 14, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20011ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(65, 66, 36, 0)
    end
end

function ClientHero20011:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20011:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero20011