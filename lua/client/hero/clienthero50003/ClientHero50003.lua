--- Xavier
--- @class ClientHero50003 : ClientHero
ClientHero50003 = Class(ClientHero50003, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50003:CreateInstance(heroModelType)
    return ClientHero50003(heroModelType)
end

function ClientHero50003:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 50003001 then
            require "lua.client.hero.ClientHero50003.50003001.ClientHero50003001RangeAttack"
            self.basicAttack = ClientHero50003001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(40, 41, 27, 22)
        elseif self.skinId == 50003002 then
            require "lua.client.hero.ClientHero50003.50003002.ClientHero50003002RangeAttack"
            self.basicAttack = ClientHero50003002RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(40, 41, 27, 22)
        else
            require "lua.client.hero.ClientHero50003.ClientHero50003RangeAttack"
            self.basicAttack = ClientHero50003RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(40, 41, 27, 22)
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 50003001 then
            require "lua.client.hero.ClientHero50003.50003001.ClientHero50003001ActiveSkill"
            self.skillAttack = ClientHero50003001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 85, 68, 0)
        elseif self.skinId == 50003002 then
            require "lua.client.hero.ClientHero50003.50003002.ClientHero50003002ActiveSkill"
            self.skillAttack = ClientHero50003002ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 85, 68, 0)
        else
            require "lua.client.hero.ClientHero50003.ClientHero50003ActiveSkill"
            self.skillAttack = ClientHero50003ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 85, 68, 0)
        end
    end
end

function ClientHero50003:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero50003:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
    ClientHero.PlayAnimation(self, "detail", true, 1)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero50003:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero50003:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

function ClientHero50003:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/Fx_vanhkhan")
    end
    if self.fx ~= nil then
        self.fx.gameObject:SetActive(isEnable)
    end
end

return ClientHero50003