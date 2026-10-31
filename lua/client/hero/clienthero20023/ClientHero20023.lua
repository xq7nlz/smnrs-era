require "lua.client.hero.ClientHero20023.ClientHero20023RangeAttack"
require "lua.client.hero.ClientHero20023.ClientHero20023ActiveSkill"

--- Kaboom
--- @class ClientHero20023 : ClientHero
ClientHero20023 = Class(ClientHero20023, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20023:CreateInstance(heroModelType)
    return ClientHero20023(heroModelType)
end

function ClientHero20023:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero20023RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(43, 44, 22, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20023ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(40, 70, 56, 11)
    end
end

function ClientHero20023:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self,1)
end

function ClientHero20023:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero20023:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero20023:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

--- @param isEnable boolean
function ClientHero20023:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/bomb2_bone")
    end
    self.fx.gameObject:SetActive(isEnable)
end

return ClientHero20023