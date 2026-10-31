require "lua.client.hero.ClientHero10019.ClientHero10019RangeAttack"
require "lua.client.hero.ClientHero10019.ClientHero10019ActiveSkill"

--- Tidus
--- @class ClientHero10019 : ClientHero
ClientHero10019 = Class(ClientHero10019, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10019:CreateInstance(heroModelType)
    return ClientHero10019(heroModelType)
end

function ClientHero10019:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10019RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 20, 15)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10019ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(50, 51, 36, 31)
    end
end

function ClientHero10019:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero10019:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero10019