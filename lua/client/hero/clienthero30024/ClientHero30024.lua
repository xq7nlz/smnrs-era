require "lua.client.hero.ClientHero30024.ClientHero30024ActiveSkill"

--- Ozroth
--- @class ClientHero30024 : ClientHero
ClientHero30024 = Class(ClientHero30024, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30024:CreateInstance(heroModelType)
    return ClientHero30024(heroModelType)
end

function ClientHero30024:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 13, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30024ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(63, 64, 29, 24)
    end
end

return ClientHero30024