require "lua.client.hero.ClientHero30027.ClientHero30027MeleeAttack"
require "lua.client.hero.ClientHero30027.ClientHero30027ActiveSkill"

--- @class ClientHero30027 : ClientHero
ClientHero30027 = Class(ClientHero30027, ClientHero)

--- @return ClientHero30027
--- @param heroModelType HeroModelType
function ClientHero30027:CreateInstance(heroModelType)
    return ClientHero30027(heroModelType)
end

function ClientHero30027:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30027MeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(66, 57, 18, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30027ActiveSkill(self)
        if self.skinId == 30027001 then
            self.skillAttack:SetFrameActionEvent(135, 105, 106, -1)
        elseif self.skinId == 30027002 then
            require "lua.client.hero.ClientHero30027.30027002.ClientHero30027002ActiveSkill"
            self.skillAttack = ClientHero30027002ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(135, 105, 80, -1)
        elseif self.skinId == 30027003 then
            self.skillAttack:SetFrameActionEvent(135, 105, 106, -1)
        else
            self.skillAttack:SetFrameActionEvent(135, 105, 106, -1)
        end
    end
end

--- Need override
--- @param effectLogType EffectLogType
function ClientHero30027:OnRemoveEffect(effectLogType)
    if effectLogType == EffectLogType.NON_TARGETED_MARK then
        self.clientHeroEffectMgr:RemoveAllEffectShow()
        self:UpdateHealth(1)
    end
end

return ClientHero30027
