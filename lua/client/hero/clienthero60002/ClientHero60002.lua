require "lua.client.hero.ClientHero60002.ClientHero60002ActiveSkill"
require "lua.client.hero.ClientHero60002.ClientHero60002BaseAttack"

--- Maknok
--- @class ClientHero60002 : ClientHero
ClientHero60002 = Class(ClientHero60002, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60002:CreateInstance(heroModelType)
    return ClientHero60002(heroModelType)
end

function ClientHero60002:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60002BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 23, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60002ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 35, 0)
    end
end

function ClientHero60002:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero60002:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
end

return ClientHero60002