require "lua.client.hero.ClientHero10007.clientHero10007ActiveSkill"

--- Lashna
--- @class ClientHero10007 : ClientHero
ClientHero10007 = Class(ClientHero10007, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10007:Ctor(heroModelType)
    ClientHero.Ctor(self, heroModelType)
    self.delayDieFx = nil
end

--- @param heroModelType HeroModelType
function ClientHero10007:CreateInstance(heroModelType)
    return ClientHero10007(heroModelType)
end

function ClientHero10007:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseRangeAttack(self)
        if self.skinId == 10007001 then
            require "lua.client.hero.ClientHero10007.10007001.ClientHero10007001RangeAttack"
            self.basicAttack = ClientHero10007001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(56, 57, 31, 22)
        else
            self.basicAttack:SetFrameActionEvent(56, 57, 27, 22)
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero10007ActiveSkill(self)
        if self.skinId == 10007001 then
            require "lua.client.hero.ClientHero10007.10007001.ClientHero10007001ActiveSkill"
            self.skillAttack = ClientHero10007001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(73, 74, 35, 5)
        else
            self.skillAttack:SetFrameActionEvent(73, 74, 35, 5)
        end
    end
end

function ClientHero10007:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero10007:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "duoi", true, 1)
end

--- @param deadForDisplayActionResult DeadForDisplayActionResult
function ClientHero10007:DeadForDisplay(deadForDisplayActionResult)
    self.isPlayingDead = true

    self:BreakCastingSkill()
    --- @type BaseSkillShow
    if self.actionTurnDetail ~= nil then
        self.clientBattleShowController:FinishClientAction(self, self.actionTurnDetail)
        self.actionTurnDetail = nil
    end

    self:UpdatePower(0)
    self.clientHeroEffectMgr:RemoveAllEffectShow()
    self:PlayDieAnimation(deadForDisplayActionResult)

    if deadForDisplayActionResult.isReviveSoon == false then
        if self.skinId == 10007001 then
            self:KillDelayDieFxCoroutine()
            self.delayDieFx = Coroutine.start(function()
                coroutine.waitforseconds(23 * AnimationConstants.FRAME_LENGTH)
                self:EnableFx(true)
            end)
        else
            self.clientBattleShowController:ShowDieEffect(self)
        end
    end
end

--- @param isEnable boolean
function ClientHero10007:EnableFx(isEnable)
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/die_fx")
    end
    self.fx.gameObject:SetActive(isEnable)
end

function ClientHero10007:KillDelayDieFxCoroutine()
    if self.delayDieFx ~= nil then
        ClientConfigUtils.KillCoroutine(self.delayDieFx)
        self.delayDieFx = nil
    end
end

function ClientHero10007:ReturnPool()
    ClientHero.ReturnPool(self)
    self:KillDelayDieFxCoroutine()
end

return ClientHero10007