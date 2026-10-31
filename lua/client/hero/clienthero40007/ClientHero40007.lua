require "lua.client.hero.ClientHero40007.ClientHero40007RangeAttack"
require "lua.client.hero.ClientHero40007.ClientHero40007ActiveSkill"

--- Noroth
--- @class ClientHero40007 : ClientHero
ClientHero40007 = Class(ClientHero40007, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40007:CreateInstance(heroModelType)
    return ClientHero40007(heroModelType)
end

function ClientHero40007:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40007RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(57, 58, 37, 32)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40007ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(87, 88, 47, 42)
    end
end

return ClientHero40007