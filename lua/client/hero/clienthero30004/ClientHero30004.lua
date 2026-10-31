require "lua.client.hero.ClientHero30004.ClientHero30004RangeAttack"
require "lua.client.hero.ClientHero30004.ClientHero30004ActiveSkill"

--- Stheno
--- @class ClientHero30004 : ClientHero
ClientHero30004 = Class(ClientHero30004, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30004:CreateInstance(heroModelType)
    return ClientHero30004(heroModelType)
end

function ClientHero30004:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30004RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(40, 41, 17, 12)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30004ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(50, 51, 27, 22)
    end
end

function ClientHero30004:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    self:EnableFx(true)
end

--- @param deadForDisplayActionResult DeadForDisplayActionResult
function ClientHero30004:DeadForDisplay(deadForDisplayActionResult)
    ClientHero.DeadForDisplay(self, deadForDisplayActionResult)
    self:EnableFx(false)
end

--- @param isEnable boolean
function ClientHero30004:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/bone_fx_eye")
    end
    self.fx.gameObject:SetActive(isEnable)
end

--- @param effectLogType EffectLogType
function ClientHero30004:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero30004:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

return ClientHero30004