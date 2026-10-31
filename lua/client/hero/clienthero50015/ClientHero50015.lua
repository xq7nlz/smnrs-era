require "lua.client.hero.ClientHero50015.ClientHero50015RangeAttack"
require "lua.client.hero.ClientHero50015.ClientHero50015ActiveSkill"

--- Navro
--- @class ClientHero50015 : ClientHero
ClientHero50015 = Class(ClientHero50015, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50015:CreateInstance(heroModelType)
    return ClientHero50015(heroModelType)
end

function ClientHero50015:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50015RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(62, 62, 27, 22)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50015ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(90, 91, 50, 0)
    end
end

function ClientHero50015:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero50015:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    self:EnableFx(true)
end

--- @param effectLogType EffectLogType
function ClientHero50015:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero50015:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableFx(true)
end

--- @param deadActionResult DeadActionResult
function ClientHero50015:PlayDieAnimation(deadActionResult)
    ClientHero.PlayDieAnimation(self, deadActionResult)
    self:EnableFx(false)
end

function ClientHero50015:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/vfx_run")
    end
    if self.book == nil then
        self.book = self.components:FindChildByPath("Model/vfx_book")
    end
    self.fx.gameObject:SetActive(isEnable)
    self.book.gameObject:SetActive(isEnable)
end

return ClientHero50015