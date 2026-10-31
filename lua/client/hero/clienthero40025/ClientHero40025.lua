require "lua.client.hero.ClientHero40025.ClientHero40025RangeAttack"
require "lua.client.hero.ClientHero40025.ClientHero40025ActiveSkill"

--- Arason
--- @class ClientHero40025 : ClientHero
ClientHero40025 = Class(ClientHero40025, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40025:CreateInstance(heroModelType)
    return ClientHero40025(heroModelType)
end

function ClientHero40025:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40025RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(35, 36, 20, 15)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40025ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(70, 71, 36, -1)
    end
end

function ClientHero40025:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero40025:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero40025