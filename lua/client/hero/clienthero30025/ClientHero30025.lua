require "lua.client.hero.ClientHero30025.ClientHero30025RangeAttack"
require "lua.client.hero.ClientHero30025.ClientHero30025ActiveSkill"

--- Grig
--- @class ClientHero30025 : ClientHero
ClientHero30025 = Class(ClientHero30025, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30025:CreateInstance(heroModelType)
    return ClientHero30025(heroModelType)
end

function ClientHero30025:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30025RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 17, 12)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30025ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 49, 44)
    end
end

function ClientHero30025:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero30025:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
    ClientHero.PlayAnimation(self, "detail", true, 1)
end

return ClientHero30025