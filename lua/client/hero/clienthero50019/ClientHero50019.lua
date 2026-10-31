require "lua.client.hero.ClientHero50019.ClientHero50019RangeAttack"
require "lua.client.hero.ClientHero50019.ClientHero50019ActiveSkill"

--- Teresa
--- @class ClientHero50019 : ClientHero
ClientHero50019 = Class(ClientHero50019, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50019:CreateInstance(heroModelType)
    return ClientHero50019(heroModelType)
end

function ClientHero50019:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50019RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 17, 12)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50019ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(67, 68, 36, 31)
    end
end

function ClientHero50019:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero50019:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "ao", true, 1)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero50019:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero50019:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

--- @param deadActionResult DeadActionResult
function ClientHero50019:PlayDieAnimation(deadActionResult)
    ClientHero.PlayDieAnimation(self, deadActionResult)
    self:EnableFx(false)
end

function ClientHero50019:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/vfx_weapon")
    end
    self.fx.gameObject:SetActive(isEnable)
end

return ClientHero50019