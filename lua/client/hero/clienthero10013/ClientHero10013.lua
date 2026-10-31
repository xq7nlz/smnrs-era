require "lua.client.hero.ClientHero10013.ClientHero10013RangeAttack"
require "lua.client.hero.ClientHero10013.ClientHero10013ActiveSkill"

--- Oceanee
--- @class ClientHero10013 : ClientHero
ClientHero10013 = Class(ClientHero10013, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10013:CreateInstance(heroModelType)
    return ClientHero10013(heroModelType)
end

function ClientHero10013:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero10013RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 20, 13)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10013ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(95, 96, 40, -1)
    end
end

function ClientHero10013:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero10013:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "toc", true, 1)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero10013:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero10013:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

function ClientHero10013:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/fx_bone_vk")
    end
    self.fx.gameObject:SetActive(isEnable)
end

return ClientHero10013