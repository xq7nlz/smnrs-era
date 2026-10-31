require "lua.client.hero.ClientHero40027.ClientHero40027RangeAttack"
require "lua.client.hero.ClientHero40027.ClientHero40027ActiveSkill"

--- Ariyuu
--- @class ClientHero40027 : ClientHero
ClientHero40027 = Class(ClientHero40027, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40027:Ctor(heroModelType)
    ClientHero.Ctor(self, heroModelType)
    self.isDragonForm = false
    self.animName = AnimationConstants.SKILL_ANIM
    self.delaySound = nil
    self.actionCoroutine = nil
end

--- @param heroModelType HeroModelType
function ClientHero40027:CreateInstance(heroModelType)
    return ClientHero40027(heroModelType)
end

--- @param airyuuForm AiryuuForm
--- @param actionResult AiryuuTransformResult
function ClientHero40027:SwitchModel(airyuuForm, actionResult)
    self.isDragonForm = airyuuForm == AiryuuForm.Dragon
    self.basicAttack.listFrameAction:Clear()
    if self.isDragonForm then
        if self.skinId == 40027001 then
            self.basicAttack:SetFrameActionEvent(85, 95, 66, 25, 0, false)
            self:TransformTo(AiryuuForm.Dragon, 100, 30, AnimationConstants.SKILL_ANIM, 3, false)
        else
            self.basicAttack:SetFrameActionEvent(85, 95, 71, 30, 0, false)
            self:TransformTo(AiryuuForm.Dragon, 112, 30, AnimationConstants.SKILL_ANIM, 3, false)
        end
    else
        self.clientBattleShowController:AddPendingClientAction(self, actionResult)
        if self.skinId == 40027001 then
            self.basicAttack:SetFrameActionEvent(52, 53, 29, 19, 0, true)
            self:TransformTo(AiryuuForm.Human, 41, 26, AnimationConstants.TRANSFORM, 15, false)
        else
            self.basicAttack:SetFrameActionEvent(52, 53, 40, 23, 0, true)
            self:TransformTo(AiryuuForm.Human, 41, 26, AnimationConstants.TRANSFORM, 15, false)
        end
    end
end

function ClientHero40027:PlaySoundTransformToDragon()
    zg.audioMgr:PlaySound("Hero/40027", "sfx_hero_40027_skill_cast")
end

function ClientHero40027:PlaySoundTransformToHuman()
    zg.audioMgr:PlaySound("Hero/40027", "sfx_hero_40027_transform_back")
end

function ClientHero40027:TransformTo(airyuuForm, animLength1, animLength2, animName, delay, isLoop)
    self:PlayAnimation(animName, false, self.mainTrackIndex)
    if airyuuForm == AiryuuForm.Human then
        self:PlaySoundTransformToHuman()
    end
    ClientConfigUtils.KillCoroutine(self.delaySound)
    self.delaySound = Coroutine.start(function()
        coroutine.waitforseconds(animLength1 * AnimationConstants.FRAME_LENGTH / 3.3)
        if airyuuForm == AiryuuForm.Dragon then
            self:PlaySoundTransformToDragon()
        end
        self.delaySound = nil
    end)
    self:PlayAnimationEffectByFrame(animName)
    if self.uiHeroStatusBar ~= nil then
        self.uiHeroStatusBar.config.gameObject:SetActive(false)
    end
    ClientConfigUtils.KillCoroutine(self.actionCoroutine)
    self.actionCoroutine = Coroutine.start(function()
        coroutine.waitforseconds(animLength1 * AnimationConstants.FRAME_LENGTH)
        self.animation:SwitchModel(airyuuForm, animLength2, delay, animName, isLoop)
        self.actionCoroutine = nil

        if airyuuForm == AiryuuForm.Human then
            self.clientBattleShowController:FinishClientAction(self)
        end
    end)
end

function ClientHero40027:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 40027001 then
            require "lua.client.hero.ClientHero40027.40027001.ClientHero40027001RangeAttack"
            self.basicAttack = ClientHero40027001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(52, 53, 29, 19, 0, false)
        else
            self.basicAttack = ClientHero40027RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(52, 53, 35, 23, 0, false)
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 40027001 then
            require "lua.client.hero.ClientHero40027.40027001.ClientHero40027001ActiveSkill"
            self.skillAttack = ClientHero40027001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(134, 140, 110, 118, 0, false)
        else
            self.skillAttack = ClientHero40027ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(134, 140, 110, 118, 0, false)
        end
    end
end

function ClientHero40027:InitAnimationComponent()
    self.dragon = self.components:FindChildByPath("DragonForm").gameObject
    self.eggBone = self.components:FindChildByPath("Model/egg_bone").gameObject
    self.animation = Client40027HeroAnimation(self, self.mainTrackIndex, self.dragon)
end

--- @param clientTurnDetail ClientTurnDetail
--- @param isBattleShow boolean
function ClientHero40027:DoAction(clientTurnDetail, isBattleShow)
    --if isBattleShow and self.isDragonForm then
    if isBattleShow then
        self:DoBasicAttack(clientTurnDetail)
        return
    end
    local _clientActionType = clientTurnDetail.actionType
    if _clientActionType ~= ClientActionType.NOTHING then
        self.actionTurnDetail = clientTurnDetail
        self.clientBattleShowController:AddPendingClientAction(self, self.actionTurnDetail)
    end

    if _clientActionType == ClientActionType.NOTHING then
        self:TriggerActionResult(clientTurnDetail)
    elseif _clientActionType == ClientActionType.BASIC_ATTACK
            or _clientActionType == ClientActionType.BONUS_ATTACK then
        self:DoBasicAttack(clientTurnDetail)
    elseif _clientActionType == ClientActionType.USE_SKILL then
        self:DoUseSkill(clientTurnDetail)
    elseif _clientActionType == ClientActionType.COUNTER_ATTACK then
        self:DoBasicAttack(clientTurnDetail)
    elseif _clientActionType == ClientActionType.BOUNCING_DAMAGE then
        local clientActionType = clientTurnDetail.extraTurnInfo.clientActionType
        if clientActionType == ClientActionType.BASIC_ATTACK then
            self:DoBasicAttack(clientTurnDetail)
        elseif clientActionType == ClientActionType.USE_SKILL then
            self:DoUseSkill(clientTurnDetail)
        end
    else
        assert(false, "Missing Do ClientActionType", _clientActionType)
    end
end

--- @param actionResult AiryuuTransformResult
function ClientHero40027:OnTransform(actionResult)
    if not actionResult.isDragonForm then
        self:SwitchModel(AiryuuForm.Human, actionResult)
        --zg.battleMgr.clientBattleShowController:PauseBattle(false)
    end
end

function ClientHero40027:ReturnPool()
    if self.playAnimEffectByFrame ~= nil then
        self.playAnimEffectByFrame:ReturnPool()
    end
    if self.playSoundEffectByFrame ~= nil then
        self.playSoundEffectByFrame:ReturnPool()
    end
    if (self.idle_effect ~= nil and self.idle_effect.isActive == true) then
        self.idle_effect:ReturnPool()
        self.idle_effect = nil
    end
    self:ReleaseEffect()
    self:StopAnimCoroutine()
    self:ChangeSortingLayerId(ClientConfigUtils.BATTLE_LAYER_ID)

    self:BreakCastingSkill()
    if self.isDragonForm then
        self:SwitchModelInstant(AiryuuForm.Human)
    end
    ClientConfigUtils.KillCoroutine(self.actionCoroutine)
    ClientConfigUtils.KillCoroutine(self.delaySound)
    if self.gameObject ~= nil then
        SmartPool.Instance:DespawnGameObject(AssetType.Hero, self.prefabName, self.gameObject.transform)
        local heroPrefabName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.GetSkinNameByBaseHero(self.baseHero))
        SmartPool.Instance:DestroyGameObjectByPoolTypeAndName(AssetType.Hero, heroPrefabName)
    end
end

function ClientHero40027:SwitchModelInstant(form)
    self.animation:SwitchModelInstant(form)
end

function ClientHero40027:SwitchModelInstant2()
    if self.isDragonForm then
        self.animation:SwitchModelInstant(AiryuuForm.Human)
        self.isDragonForm = false
    else
        self.animation:SwitchModelInstant(AiryuuForm.Dragon)
        self.isDragonForm = true
    end
    return self.isDragonForm
end

return ClientHero40027