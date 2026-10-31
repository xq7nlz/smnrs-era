require "lua.client.hero.ClientHero20001.ClientHero20001RangeAttack"
require "lua.client.hero.ClientHero20001.ClientHero20001ActiveSkill"

--- Icarus
--- @class ClientHero20001 : ClientHero
ClientHero20001 = Class(ClientHero20001, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20001:CreateInstance(heroModelType)
    return ClientHero20001(heroModelType)
end

--- @param heroModelType HeroModelType
function ClientHero20001:Ctor(heroModelType)
    --- @type ClientEffect
    self.eggBattleEffect = nil
    --- @type boolean
    self.isTriggerEgg = false
    --- @type boolean
    self.isInEggForm = false
    self.eggStart = "egg_start"
    self.eggEnd = "egg_end"
    self.audioFolderName = "Hero/20001"

    self.eggEndCoroutine = nil

    ClientHero.Ctor(self, heroModelType)
end

function ClientHero20001:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 20001001 then
            require "lua.client.hero.ClientHero20001.ClientHero20001001.ClientHero20001001RangeAttack"
            self.basicAttack = ClientHero20001001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(52, 53, 38, 23)
        elseif self.skinId == 20001002 then
            require "lua.client.hero.ClientHero20001.ClientHero20001002.ClientHero20001002RangeAttack"
            self.basicAttack = ClientHero20001002RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(52, 53, 43, 23)
        elseif self.skinId == 20001003 then
            require "lua.client.hero.ClientHero20001.ClientHero20001003.ClientHero20001003RangeAttack"
            self.basicAttack = ClientHero20001003RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(52, 53, 38, 23)
        elseif self.skinId == 20001004 then
            require "lua.client.hero.ClientHero20001.ClientHero20001004.ClientHero20001004RangeAttack"
            self.basicAttack = ClientHero20001004RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(52, 53, 43, 23)
        else
            self.basicAttack = ClientHero20001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(52, 53, 38, 23)
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 20001001 then
            require "lua.client.hero.ClientHero20001.ClientHero20001001.ClientHero20001001ActiveSkill"
            self.skillAttack = ClientHero20001001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 90, 66, 46)
        elseif self.skinId == 20001002 then
            require "lua.client.hero.ClientHero20001.ClientHero20001002.ClientHero20001002ActiveSkill"
            self.skillAttack = ClientHero20001002ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 96, 75, 45)
        elseif self.skinId == 20001003 then
            require "lua.client.hero.ClientHero20001.ClientHero20001003.ClientHero20001003ActiveSkill"
            self.skillAttack = ClientHero20001003ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 90, 66, 46)
        elseif self.skinId == 20001004 then
            require "lua.client.hero.ClientHero20001.ClientHero20001004.ClientHero20001004ActiveSkill"
            self.skillAttack = ClientHero20001004ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 96, 75, 45)
        else
            self.skillAttack = ClientHero20001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 90, 66, 46)
        end
    end
end

function ClientHero20001:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero20001:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
    ClientHero.PlayAnimation(self, "wing", true, 1)
    self:EnableRabbitFx(true)
end

--- @param regenerateActionResult RegenerateActionResult
--- @param clientActionType ClientActionType
function ClientHero20001:Regenerate(regenerateActionResult, clientActionType)
    self.isPlayingDead = false
    local remainingRound = regenerateActionResult.remainingRound
    self.eggR = MathUtils.Clamp(3 - remainingRound + 1, 1, 3)

    if remainingRound == -1 then
        self.clientBattleShowController:AddPendingClientAction(self, regenerateActionResult)
        self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)

        self.isInEggForm = false

        self:StopEggEndCoroutine()

        self.eggEndCoroutine = Coroutine.start(function()
            self.animation:PlayAnimation(self.eggEnd, false)
            coroutine.waitforseconds(2.5)
            self:PlayStartAnimation()
            self.clientBattleShowController:FinishClientAction(self, regenerateActionResult)
        end)

        self:PlayAnimationEffectByFrame(self.eggEnd)

        zg.audioMgr:PlaySound(self.audioFolderName, "sfx_hero_20001_egg_end")

        self:EnableEasterEggFx(false)

        -- Tranform to Egg
    elseif remainingRound >= 3 and self.isInEggForm == false then
        self:SetActive(true)
        ClientHero.Regenerate(self)
        self.clientBattleShowController:AddPendingClientAction(self, regenerateActionResult)
        self.isInEggForm = true
        print("Regenerate")
        self.animation:EnableAnim(true)
        self.animation:PlayAnimationWithCallback(self.eggStart, function()

            self.animation:PlayAnimation("egg_r" .. self.eggR, true, self.mainTrackIndex)
            self.clientBattleShowController:FinishClientAction(self, regenerateActionResult)
        end, false, self.mainTrackIndex)

        zg.audioMgr:PlaySound(self.audioFolderName, "sfx_hero_20001_egg_start")

        self:EnableRabbitFx(false)
    else
        self.animation:PlayAnimation("egg_r" .. self.eggR, true, self.mainTrackIndex)
        self:DoTransformEffect()
        self:EnableEasterEggFx(self.eggR == 3)
    end
end

function ClientHero20001:PlayGetHurtAnimation()
    if self.isInEggForm == false then
        ClientHero.PlayGetHurtAnimation(self)
    end
end

function ClientHero20001:PlayStunAnimation()
    if self.isInEggForm == false then
        ClientHero.PlayStunAnimation(self)
    end
end

function ClientHero20001:PlayIdleAnimation()
    if self.isInEggForm == false then
        ClientHero.PlayIdleAnimation(self)
        self:EnableRabbitFx(true)
    end
end

--- @param dieActionResult BaseActionResult
function ClientHero20001:PlayDieAnimation(dieActionResult)
    local dieAnim = AnimationConstants.DIE_ANIM
    if self.isInEggForm == true then
        dieAnim = "egg_die"
        zg.audioMgr:PlaySound(self.audioFolderName, "sfx_hero_20001_egg_start")
    end
    self.animation:PlayAnimationWithCallback(dieAnim, function()
        if self.isPlayingDead == true then
            self:SetActive(false)
            self.isPlayingDead = false
        end
    end, false, self.mainTrackIndex)
    if self.isInEggForm == true then
        self:PlayAnimationEffectByFrame(dieAnim)
    end
end

--- @param actionResult ReviveActionResult
--- @param actionResult RebornActionResult
--- @param initiatorFaction number
--- @param isPermanent boolean
function ClientHero20001:DoRebornOrReviveActionResult(actionResult, initiatorFaction,isPermanent)
    self.clientBattleShowController:ShowRebornOrReviveEffect(self, initiatorFaction,isPermanent)
    self.isPlayingDead = false
    self:SetActive(true)
    if self.isInEggForm == false then

        self.animation:PlayAnimationWithCallback(AnimationConstants.REBORN, function()
            self.uiHeroStatusBar:SetActive(true)

            self:PlayIdleAnimation()

            ClientHero.PlayAnimation(self, "fx", true, 0)
            ClientHero.PlayAnimation(self, "wing", true, 1)

            self.clientBattleShowController:FinishClientAction(self, actionResult)
        end, false, self.mainTrackIndex)
    else
        self.animation:PlayAnimationWithCallback(self.eggStart, function()
            self.uiHeroStatusBar:SetActive(true)
            self.animation:PlayAnimation("egg_r" .. 1, true, self.mainTrackIndex)
            self.clientBattleShowController:FinishClientAction(self, actionResult)
        end, false, self.mainTrackIndex)
    end
end

function ClientHero20001:DoTransformEffect()
    if self.skinId == 20001001 or self.skinId == 20001002 or self.skinId == 20001003 or self.skinId == 20001004 then
        local effectName = self:GetEffectNameByFormat("hero_%s_%s_egg_tranform")
        local transformEffect = self.clientBattleShowController:GetClientEffect(AssetType.HeroBattleEffect, effectName)
        transformEffect:SetToHeroAnchor(self)
    end
end

--- @param effectLogType EffectLogType
function ClientHero20001:OnCompleteGettingFreezed(effectLogType)
    ClientHero.OnCompleteGettingFreezed(self, effectLogType)
    self:EnableSmokeEffectFx(false)
    self:EnableRabbitFx(false)
    self:EnableEasterEggFx(false)
end

--- @param effectLogType EffectLogType
function ClientHero20001:RemoveFreezedByType(effectLogType)
    ClientHero.RemoveFreezedByType(self, effectLogType)
    self:EnableSmokeEffectFx(true)
    self:EnableRabbitFx(true)
    if self.isInEggForm == true and self.eggR == 3 then
        self:EnableEasterEggFx(true)
    end
end

--- @param isEnable boolean
function ClientHero20001:EnableRabbitFx(isEnable)
    if self.skinId ~= 20001002 or (self.isInEggForm == true and isEnable == true) then
        return
    end
    if self.fx == nil then
        self.fx = self.components:FindChildByPath("Model/bone_rabbit_idle")
    end
    self.fx.gameObject:SetActive(isEnable)
end

--- @param isEnable boolean
function ClientHero20001:EnableEasterEggFx(isEnable)
    if self.skinId ~= 20001002 then
        return
    end
    if self.fxEgg == nil then
        self.fxEgg = self.components:FindChildByPath("Model/egg_bone")
    end
    self.fxEgg.gameObject:SetActive(isEnable)
    self:EnableSmokeEffectFx(not isEnable)
end

function ClientHero20001:ReturnPool()
    ClientHero.ReturnPool(self)
    self:StopEggEndCoroutine()
end

function ClientHero20001:StopEggEndCoroutine()
    if self.eggEndCoroutine ~= nil then
        ClientConfigUtils.KillCoroutine(self.eggEndCoroutine)
        self.eggEndCoroutine = nil
    end
end

--- @param isEnable boolean
function ClientHero20001:EnableSmokeEffectFx(isEnable)
    if self.skinId ~= 20001003 then
        return
    end
    if self.idleSmokeEffectFX == nil then
        self.idleSmokeEffectFX = self.components:FindChildByPath("Model/20001003_idle_rose")
    end
    if self.idleSmokeEffectFX ~= nil then
        self.idleSmokeEffectFX.gameObject:SetActive(isEnable)
    end
end

function ClientHero20001:Dead(deadActionResult)
    if self.skinId == 20001003 then
        self:EnableSmokeEffectFx(false)
    end
    ClientHero.Dead(self,deadActionResult)
end

return ClientHero20001