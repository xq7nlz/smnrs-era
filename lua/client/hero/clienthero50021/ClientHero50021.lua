require "lua.client.hero.ClientHero50021.ClientHero50021RangeAttack"
require "lua.client.hero.ClientHero50021.ClientHero50021ActiveSkill"

--- Ismat
--- @class ClientHero50021 : ClientHero
ClientHero50021 = Class(ClientHero50021, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50021:CreateInstance(heroModelType)
    return ClientHero50021(heroModelType)
end

function ClientHero50021:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50021RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(38, 39, 21, 16)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50021ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(48, 49, 31, 26)
    end
end

function ClientHero50021:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero50021:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero50021:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

function ClientHero50021:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/bone_cung")
    end
    self.fx.gameObject:SetActive(isEnable)
end

return ClientHero50021