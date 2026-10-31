require "lua.client.hero.ClientHero10026.ClientHero10026ActiveSkill"

--- Mrrgly
--- @class ClientHero10026 : ClientHero
ClientHero10026 = Class(ClientHero10026, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10026:CreateInstance(heroModelType)
    return ClientHero10026(heroModelType)
end

function ClientHero10026:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(38, 39, 13, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10026ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(78, 79, 45, -1)
    end
end

function ClientHero10026:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero10026:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "eye", true, 1)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero10026:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero10026:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

function ClientHero10026:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/bone_vk_fx")
    end
    self.fx.gameObject:SetActive(isEnable)
end

return ClientHero10026