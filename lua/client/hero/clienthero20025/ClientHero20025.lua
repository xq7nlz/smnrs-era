require "lua.client.hero.ClientHero20025.ClientHero20025RangeAttack"
require "lua.client.hero.ClientHero20025.ClientHero20025ActiveSkill"

--- Yirlal
--- @class ClientHero20025 : ClientHero
ClientHero20025 = Class(ClientHero20025, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20025:CreateInstance(heroModelType)
    return ClientHero20025(heroModelType)
end

function ClientHero20025:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20025RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 28, 23)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20025ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(70, 71, 47, 42)
    end
end

function ClientHero20025:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero20025:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero20025:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

function ClientHero20025:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/daycung")
    end
    self.fx.gameObject:SetActive(isEnable)
end

return ClientHero20025