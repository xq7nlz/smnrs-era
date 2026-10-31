require "lua.client.hero.ClientHero60016.ClientHero60016RangeAttack"
require "lua.client.hero.ClientHero60016.ClientHero60016ActiveSkill"

--- DarkMage
--- @class ClientHero60016 : ClientHero
ClientHero60016 = Class(ClientHero60016, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60016:CreateInstance(heroModelType)
    return ClientHero60016(heroModelType)
end

function ClientHero60016:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero60016RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(35, 36, 21, 16)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60016ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(40, 41, 20, 16)
    end
end

--- @param effectLogType EffectLogType
function ClientHero60016:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero60016:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

function ClientHero60016:EnableFx(isEnable)
    if self.fx1 == nil then
        self.fx1 = self.components:FindChildByPath("Model/bone_duaphepfx/dot").gameObject
    end
    if self.fx2 == nil then
        self.fx2 = self.components:FindChildByPath("Model/bone_denfx/dot").gameObject
    end
    self.fx1:SetActive(isEnable)
    self.fx2:SetActive(isEnable)
end

return ClientHero60016