require "lua.client.hero.ClientHero60015.ClientHero60015BaseAttack"
require "lua.client.hero.ClientHero60015.ClientHero60015ActiveSkill"

--- Murath
--- @class ClientHero60015 : ClientHero
ClientHero60015 = Class(ClientHero60015, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60015:CreateInstance(heroModelType)
    return ClientHero60015(heroModelType)
end

function ClientHero60015:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60015BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(60, 61, 26, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60015ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(90, 91, 50, 45)
    end
end

return ClientHero60015