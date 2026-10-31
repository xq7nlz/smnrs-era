require "lua.client.hero.ClientHero40018.ClientHero40018ActiveSkill"

--- Oakroot
--- @class ClientHero40018 : ClientHero
ClientHero40018 = Class(ClientHero40018, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40018:CreateInstance(heroModelType)
    return ClientHero40018(heroModelType)
end

function ClientHero40018:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 15, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40018ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(65, 66, 32, -1)
    end
end

return ClientHero40018