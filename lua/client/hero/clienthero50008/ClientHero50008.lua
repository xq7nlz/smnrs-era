require "lua.client.hero.ClientHero50008.ClientHero50008RangeAttack"
require "lua.client.hero.ClientHero50008.ClientHero50008ActiveSkill"

--- Fanar
--- @class ClientHero50008 : ClientHero
ClientHero50008 = Class(ClientHero50008, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50008:CreateInstance(heroModelType)
    return ClientHero50008(heroModelType)
end

function ClientHero50008:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero50008RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(42, 43, 13, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50008ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(85, 86, 61, 56)
    end
end

function ClientHero50008:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero50008:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "vatao", true, 1)
    self.animation:SetShaderFieldColorById(ClientConfigUtils.FIELD_COLOR_BLACK_ID, U_Color(0, 0, 0, 0))
end

--- @param effectLogType EffectLogType
function ClientHero50008:OnRemoveCCEffect(effectLogType)
    if effectLogType == EffectLogType.STUN
            or effectLogType == EffectLogType.SLEEP then
        self.lastLoopAnimation = AnimationConstants.IDLE_ANIM
        self:PlayIdleAnimation()
    elseif effectLogType == EffectLogType.FREEZE
            or effectLogType == EffectLogType.PETRIFY then
        self.animation:ChangeShaderByName(ClientConfigUtils.SPINE_TINT_BLACK_SHADER)
        self:RemoveFreezedByType(effectLogType)
        self:PlayLastLoopAnimation()
    else
        assert(false, "Missing OnRemoveCC EffectLogType " .. effectLogType)
    end
end

return ClientHero50008