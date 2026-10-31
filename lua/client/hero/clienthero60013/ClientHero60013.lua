require "lua.client.hero.ClientHero60013.ClientHero60013ActiveSkill"

--- Dark Knight
--- @class ClientHero60013 : ClientHero
ClientHero60013 = Class(ClientHero60013, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60013:CreateInstance(heroModelType)
    return ClientHero60013(heroModelType)
end

function ClientHero60013:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(55, 56, 29, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60013ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 39, 34)
    end
end

return ClientHero60013