require "lua.client.hero.ClientHero30017.ClientHero30017ActiveSkill"

--- Gloz
--- @class ClientHero30017 : ClientHero
ClientHero30017 = Class(ClientHero30017, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30017:CreateInstance(heroModelType)
    return ClientHero30017(heroModelType)
end

function ClientHero30017:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 22, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30017ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(70, 71, 43, -1)
    end
end

return ClientHero30017