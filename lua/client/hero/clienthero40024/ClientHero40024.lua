require "lua.client.hero.ClientHero40024.ClientHero40024RangeAttack"
require "lua.client.hero.ClientHero40024.ClientHero40024ActiveSkill"

--- Wugushi
--- @class ClientHero40024 : ClientHero
ClientHero40024 = Class(ClientHero40024, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40024:CreateInstance(heroModelType)
    return ClientHero40024(heroModelType)
end

function ClientHero40024:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40024RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(30, 31, 19, 14)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40024ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(60, 61, 37, 32)
    end
end

function ClientHero40024:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero40024:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero40024:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

function ClientHero40024:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/fx_butterfly")
    end
    self.fx.gameObject:SetActive(isEnable)
end

return ClientHero40024