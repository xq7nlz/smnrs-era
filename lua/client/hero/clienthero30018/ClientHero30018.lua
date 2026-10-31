require "lua.client.hero.ClientHero30018.ClientHero30018ActiveSkill"

--- Death Jester
--- @class ClientHero30018 : ClientHero
ClientHero30018 = Class(ClientHero30018, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30018:CreateInstance(heroModelType)
    return ClientHero30018(heroModelType)
end

function ClientHero30018:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 11, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30018ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(90, 91, 47, -1)
    end
end

function ClientHero30018:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero30018:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "hair", true, 1)
end

return ClientHero30018