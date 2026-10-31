require "lua.client.hero.ClientHero40011.ClientHero40011ActiveSkill"

--- Neutar
--- @class ClientHero40011 : ClientHero
ClientHero40011 = Class(ClientHero40011, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40011:CreateInstance(heroModelType)
    return ClientHero40011(heroModelType)
end

function ClientHero40011:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(64, 65, 24, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40011ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(83, 84, 43, -1)
    end
end

return ClientHero40011