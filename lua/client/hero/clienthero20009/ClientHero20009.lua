require "lua.client.hero.ClientHero20009.ClientHero20009RangeAttack"
require "lua.client.hero.ClientHero20009.ClientHero20009ActiveSkill"

--- Fragnil
--- @class ClientHero20009 : ClientHero
ClientHero20009 = Class(ClientHero20009, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20009:CreateInstance(heroModelType)
    return ClientHero20009(heroModelType)
end

function ClientHero20009:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20009RangeAttack(self)
        if(self.skinId ==  20009001) then
            self.basicAttack:SetFrameActionEvent(100, 75, 25, 20)
        else
            self.basicAttack:SetFrameActionEvent(50, 100, 25, 20)
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        if (self.skinId == 20009001) then
            require "lua.client.hero.ClientHero20009.20009001.ClientHero20009001ActiveSkill"
            self.skillAttack = ClientHero20009001ActiveSkill(self)
        else
            self.skillAttack = ClientHero20009ActiveSkill(self)
        end

        self.skillAttack:SetFrameActionEvent(85, 86, 43, 38)
    end
end

function ClientHero20009:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20009:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    self:PlayAnimation("fx", true, 0)
end

return ClientHero20009