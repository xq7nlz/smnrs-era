require "lua.client.hero.ClientHero60012.ClientHero60012ActiveSkill"

--- Juan
--- @class ClientHero60012 : ClientHero
ClientHero60012 = Class(ClientHero60012, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60012:CreateInstance(heroModelType)
    return ClientHero60012(heroModelType)
end

function ClientHero60012:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseRangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 18, 13)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60012ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(65, 66, 48, 18)
    end
end

function ClientHero60012:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero60012:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "vatao", true, 1)
end

return ClientHero60012