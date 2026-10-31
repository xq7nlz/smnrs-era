require "lua.client.hero.ClientHero10012.ClientHero10012ActiveSkill"

--- Mrrgly
--- @class ClientHero10012 : ClientHero
ClientHero10012 = Class(ClientHero10012, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10012:CreateInstance(heroModelType)
    return ClientHero10012(heroModelType)
end

function ClientHero10012:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 21, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10012ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(65, 66, 35, -1)
    end
end

return ClientHero10012