require "lua.client.hero.ClientHero10022.ClientHero10022RangeAttack"
require "lua.client.hero.ClientHero10022.ClientHero10022ActiveSkill"

--- AquaMage
--- @class ClientHero10022 : ClientHero
ClientHero10022 = Class(ClientHero10022, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10022:CreateInstance(heroModelType)
    return ClientHero10022(heroModelType)
end

function ClientHero10022:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10022RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(35, 36, 27, 22)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10022ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 70, 47, 42)
    end
end

function ClientHero10022:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero10022:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect_water", true, 0)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero10022:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero10022:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

function ClientHero10022:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/bone_effect_water/mesh")
    end
    self.fx.gameObject:SetActive(isEnable)
end

return ClientHero10022