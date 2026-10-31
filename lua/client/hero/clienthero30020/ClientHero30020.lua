require "lua.client.hero.ClientHero30020.ClientHero30020ActiveSkill"

--- Thanatos
--- @class ClientHero30020 : ClientHero
ClientHero30020 = Class(ClientHero30020, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30020:CreateInstance(heroModelType)
    return ClientHero30020(heroModelType)
end

function ClientHero30020:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 12, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30020ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(48, 49, 30, 0)
    end
end

function ClientHero30020:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 3)
end

function ClientHero30020:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "fx2", true, 1)
    ClientHero.PlayAnimation(self, "vay", true, 2)
end

return ClientHero30020