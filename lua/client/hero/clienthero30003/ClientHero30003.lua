require "lua.client.hero.ClientHero30003.ClientHero30003RangeAttack"
require "lua.client.hero.ClientHero30003.ClientHero30003ActiveSkill"
require "lua.client.hero.ClientHero30003.30003001.ClientHero30003001ActiveSkill"
require "lua.client.hero.ClientHero30003.30003001.ClientHero30003001RangeAttack"

--- Nero
--- @class ClientHero30003 : ClientHero
ClientHero30003 = Class(ClientHero30003, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30003:CreateInstance(heroModelType)
    return ClientHero30003(heroModelType)
end

--- Init frame Action Event
function ClientHero30003:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 30003001 then
            self.basicAttack = ClientHero30003001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(55, 56, 25, 20)
        else
            self.basicAttack = ClientHero30003RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(55, 56, 25, 20)
        end

    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 30003001 then
            self.skillAttack = ClientHero30003001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(96, 105, 60, 0)
        else
            self.skillAttack = ClientHero30003ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(95, 96, 60, 0)
        end
    end
end

function ClientHero30003:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero30003:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero30003