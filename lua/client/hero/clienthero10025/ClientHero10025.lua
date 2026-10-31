require "lua.client.hero.ClientHero10025.ClientHero10025ActiveSkill"

--- Eddie
--- @class ClientHero10025 : ClientHero
ClientHero10025 = Class(ClientHero10025, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10025:CreateInstance(heroModelType)
    return ClientHero10025(heroModelType)
end

function ClientHero10025:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 22, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10025ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(70, 71, 40, -1)
    end
end

return ClientHero10025