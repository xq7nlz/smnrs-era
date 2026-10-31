require "lua.client.hero.ClientHero50024.ClientHero50024ActiveSkill"

--- Eltick
--- @class ClientHero50024 : ClientHero
ClientHero50024 = Class(ClientHero50024, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50024:CreateInstance(heroModelType)
    return ClientHero50024(heroModelType)
end

function ClientHero50024:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 12, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50024ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(66, 67, 34, -1)
    end
end

function ClientHero50024:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero50024:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero50024