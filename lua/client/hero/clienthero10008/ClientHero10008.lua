require "lua.client.hero.ClientHero10008.ClientHero10008BaseAttack"
require "lua.client.hero.ClientHero10008.ClientHero10008ActiveSkill"

--- Murath
--- @class ClientHero10008 : ClientHero
ClientHero10008 = Class(ClientHero10008, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10008:CreateInstance(heroModelType)
    return ClientHero10008(heroModelType)
end

function ClientHero10008:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10008BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(60, 61, 27, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10008ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(82, 83, 43, 25)
    end
end

return ClientHero10008