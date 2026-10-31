require "lua.client.hero.ClientHero30002.ClientHero30002ActiveSkill"

--- En
--- @class ClientHero30002 : ClientHero
ClientHero30002 = Class(ClientHero30002, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30002:CreateInstance(heroModelType)
    return ClientHero30002(heroModelType)
end

function ClientHero30002:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(55, 56, 22, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30002ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(80, 90, 52, -1)
    end
end

function ClientHero30002:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero30002:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero30002