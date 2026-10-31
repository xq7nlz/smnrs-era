require "lua.client.hero.ClientHero40001.ClientHero40001RangeAttack"
require "lua.client.hero.ClientHero40001.ClientHero40001ActiveSkill"

--- Tilion
--- @class ClientHero40001 : ClientHero
ClientHero40001 = Class(ClientHero40001, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40001:CreateInstance(heroModelType)
    return ClientHero40001(heroModelType)
end

function ClientHero40001:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40001RangeAttack(self)
        if self.skinId == 40001001 then
            require "lua.client.hero.ClientHero40001.40001001.ClientHero40001001RangeAttack"
            self.basicAttack = ClientHero40001001RangeAttack(self)
        end
        self.basicAttack:SetFrameActionEvent(42, 43, 18, 13)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40001ActiveSkill(self)
        if self.skinId == 40001001 then
            require "lua.client.hero.ClientHero40001.40001001.ClientHero40001001ActiveSkill"
            self.skillAttack = ClientHero40001001ActiveSkill(self)
        end
        self.skillAttack:SetFrameActionEvent(70, 71, 58, 53)
    end
end

function ClientHero40001:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero40001:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero40001:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero40001:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

function ClientHero40001:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/vfx_weapon")
    end
    self.fx.gameObject:SetActive(isEnable)
end

return ClientHero40001