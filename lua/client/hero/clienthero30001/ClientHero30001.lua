require "lua.client.hero.ClientHero30001.ClientHero30001ActiveSkill"
require "lua.client.hero.ClientHero30001.ClientHero30001BaseAttack"

--- Charon
--- @class ClientHero30001 : ClientHero
ClientHero30001 = Class(ClientHero30001, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30001:CreateInstance(heroModelType)
    return ClientHero30001(heroModelType)
end

function ClientHero30001:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 30001001 then
            require "lua.client.hero.ClientHero30001.ClientHero30001001.ClientHero30001001BaseAttack"
            self.basicAttack = ClientHero30001001BaseAttack(self)
            self.basicAttack:SetFrameActionEvent(56, 57, 15, -1)
            else
            self.basicAttack = ClientHero30001BaseAttack(self)
            self.basicAttack:SetFrameActionEvent(56, 57, 15, -1)
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 30001001 then
            require "lua.client.hero.ClientHero30001.ClientHero30001001.ClientHero30001001ActiveSkill"
            self.skillAttack = ClientHero30001001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(105, 106, 65, -1)
        else
            self.skillAttack = ClientHero30001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(105, 106, 65, -1)
        end
    end
end

function ClientHero30001:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero30001:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "effect", true, 0)
    ClientHero.PlayAnimation(self, "detail", true, 1)
end

--- @param effectLogType EffectLogType
function ClientHero30001:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableIdleEffectFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero30001:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableIdleEffectFx(true)

end

--- @param isEnable boolean
function ClientHero30001:EnableIdleEffectFx(isEnable)
    if self.skinId ~= 30001001 then
        return
    end
    if self.idleEffectFX == nil then
        self.idleEffectFX = self.components:FindChildByPath("Model/30001001_idle_effect")
    end
    if self.idleEffectFX ~= nil then
        self.idleEffectFX.gameObject:SetActive(isEnable)
    end
    if self.idleSmokeEffectFX == nil then
        self.idleSmokeEffectFX = self.components:FindChildByPath("Model/30001001_idle_smoke")
    end
    if self.idleSmokeEffectFX ~= nil then
        self.idleSmokeEffectFX.gameObject:SetActive(isEnable)
    end
end

--- @param isEnable boolean
function ClientHero30001:EnableSmokeEffectFx(isEnable)
    if self.idleSmokeEffectFX == nil then
        self.idleSmokeEffectFX = self.components:FindChildByPath("Model/30001001_idle_smoke")
    end
    if self.idleSmokeEffectFX ~= nil then
        self.idleSmokeEffectFX.gameObject:SetActive(isEnable)
    end
end

function ClientHero30001:Dead(deadActionResult)
    if self.skinId == 30001001 then
        self:EnableSmokeEffectFx(false)
    end
    ClientHero.Dead(self,deadActionResult)
end

--[[function ClientHero30001:ReturnPool()
    if self.skinId == 30001001 then
        self:EnableSmokeEffectFx(false)
    end
    ClientHero.ReturnPool()
end]]

return ClientHero30001