require "lua.client.hero.ClientHero30015.ClientHero30015ActiveSkill"

--- Fang
--- @class ClientHero30015 : ClientHero
ClientHero30015 = Class(ClientHero30015, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30015:CreateInstance(heroModelType)
    return ClientHero30015(heroModelType)
end

function ClientHero30015:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 23, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30015ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(66, 67, 36, -1)
    end
end

function ClientHero30015:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero30015:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
end

return ClientHero30015