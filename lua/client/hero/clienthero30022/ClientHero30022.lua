require "lua.client.hero.ClientHero30022.ClientHero30022RangeAttack"
require "lua.client.hero.ClientHero30022.clientHero30022ActiveSkill"

--- Dungan
--- @class ClientHero30022 : ClientHero
ClientHero30022 = Class(ClientHero30022, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30022:CreateInstance(heroModelType)
    return ClientHero30022(heroModelType)
end

function ClientHero30022:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30022RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(54, 60, 35, 30)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30022ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(67, 70, 41, 36)
    end
end

return ClientHero30022