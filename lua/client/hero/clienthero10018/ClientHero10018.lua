require "lua.client.hero.ClientHero10018.ClientHero10018ActiveSkill"

--- Sabertusk
--- @class ClientHero10018 : ClientHero
ClientHero10018 = Class(ClientHero10018, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10018:CreateInstance(heroModelType)
    return ClientHero10018(heroModelType)
end

function ClientHero10018:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 20, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10018ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(86, 87, 35, 30)
    end
end

return ClientHero10018