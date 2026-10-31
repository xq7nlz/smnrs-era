require "lua.client.scene.ui.battle.uiHeroStatusBar.UIHeroStatusBar"
require "lua.client.battleShow.PlaySoundEffectByFrame.PlaySoundEffectByFrame"
require "lua.client.battleShow.PlayAnimEffectByFrame.PlayAnimEffectByFrame"
require "lua.client.battleShow.ClientHero.ClientHeroAnimation"
require "lua.client.battleShow.ClientHeroActionResultsHandler"
require "lua.client.battleShow.ClientHero.HeroComponents"
require "lua.client.battleShow.ClientHero.effectMgr.ClientHeroEffectMgr"
require "lua.client.battleShow.ClientHero.ClientHeroMovement"
require "lua.client.battleShow.ClientHero.ClientHeroLayerChangeEvent"

--- @class HeroModelType
HeroModelType = {
    Dummy = 0,
    Basic = 1,
    Full = 2,
}

--- @class ClientHero
ClientHero = Class(ClientHero)

--- @param heroModelType HeroModelType
function ClientHero:Ctor(heroModelType)
    --- @type List
    self.listEffect = List()
    --- @type HeroModelType
    self.heroModelType = heroModelType or HeroModelType.Dummy
    --- @type PlaySoundEffectByFrame
    self.playSoundEffectByFrame = nil
    --- @type PlayAnimEffectByFrame
    self.playAnimEffectByFrame = nil
    --- @type ClientHeroAnimation
    self.animation = nil
    --- @type number
    self.mainTrackIndex = 0
    --- @type HeroComponents
    self.components = nil
    --- @type string
    self.defaultSkinName = nil
    --- @type string
    self.skinName = nil
    --- @type SkinRarity
    self.skinRarity = nil
    --- @type string
    self.prefabName = nil
    if heroModelType == HeroModelType.Dummy then
        return
    end
    --- @type BaseHero
    self.baseHero = nil
    --- @type UnityEngine_GameObject
    self.gameObject = nil
    ---@type ClientBattleShowController
    self.clientBattleShowController = zg.battleMgr.clientBattleShowController
    --- @type ClientHeroEffectMgr
    self.clientHeroEffectMgr = nil
    --- @type ClientHeroMovement
    self.clientHeroMovement = nil

    --- @type BaseSkillShow
    self.basicAttack = nil
    --- @type BaseSkillShow
    self.skillAttack = nil
    --- @type BaseSkillShow
    self.castingSkill = nil

    ---@type Vector2
    self.originPosition = nil

    self.clientHeroActionResultsHandler = nil
    --- @type string
    self.lastLoopAnimation = nil

    --- @type ClientTurnDetail
    self.actionTurnDetail = nil
    --- @type boolean
    self.isPlayingDead = false

    --- @type UIHeroStatusBar
    self.uiHeroStatusBar = nil
    --- @type Dictionary -- <ActionResultType, number>
    self.damageFollowDict = Dictionary()
    --- @type ClientEffect
    self.idle_effect = nil
end

--- @param baseHero BaseHero
--- @param overridePosition UnityEngine_Vector3
function ClientHero:Init(baseHero, overridePosition)
    self.baseHero = baseHero
    if baseHero.isDummy == true then
        return
    end
    self.skinRarity = ClientConfigUtils.GetSkinRarityByBaseHero(baseHero)
    self:SetSkin()

    self.clientHeroActionResultsHandler = ClientHeroActionResultsHandler(self)
    self.components = HeroComponents(self.gameObject)
    self:InitStatusBar()

    self:InitAnimationComponent()

    self.playSoundEffectByFrame = PlaySoundEffectByFrame(self)
    self.playSoundEffectByFrame:CreateConfig(self.baseHero.id, self.skinName)

    self.playAnimEffectByFrame = PlayAnimEffectByFrame(self)
    self.playAnimEffectByFrame:CreateConfig(self.baseHero.id, self.skinName)

    self.clientHeroEffectMgr = ClientHeroEffectMgr(self)
    self.clientHeroMovement = ClientHeroMovement(self)
    if overridePosition ~= nil then
        self.originPosition = overridePosition
    else
        self.originPosition = PositionConfig.GetHeroPosition(baseHero)
    end
    self:SetOriginalTransform(self.originPosition, baseHero.teamId)
    self:InitSkill(0)
    self:SetEffectInBattle()
end

--- @param mainTrackIndex number
function ClientHero:InitAnimationComponent(mainTrackIndex)
    self.mainTrackIndex = mainTrackIndex or 0
    self.animation = ClientHeroAnimation(self, self.mainTrackIndex)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero:GetClientEffect(effectType, effectName)
    --- @type ClientEffect
    local clientEffect
    if effectType == AssetType.GeneralBattleEffect then
        clientEffect = SmartPool.Instance:SpawnClientEffectByPoolType(AssetType.GeneralBattleEffect, GeneralEffectPoolType.ClientEffect, effectName)
    elseif effectType == AssetType.HeroBattleEffect then
        clientEffect = SmartPool.Instance:SpawnClientEffectByPoolType(AssetType.HeroBattleEffect, GeneralEffectPoolType.ClientEffect, effectName)
    elseif effectType == AssetType.DefenseBattleEffect then
        clientEffect = SmartPool.Instance:SpawnClientEffectByPoolType(AssetType.DefenseBattleEffect, GeneralEffectPoolType.ClientEffect, effectName)
    end
    if clientEffect.isInited == false then
        local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
        clientEffect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
        clientEffect.isInited = true
    end
    return clientEffect
end

function ClientHero:SpawnIdleEffectBody(effectId, inBattle)
    --if self.heroModelType ~= HeroModelType.Dummy then
    local effectName = ClientConfigUtils.GetEffectNameById(effectId)
    self:ReturnPoolIdleEffect()
    if (inBattle == true) then
        self.idle_effect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, effectName)
    else
        self.idle_effect = zg.battleEffectMgr:GetClientEffect(AssetType.GeneralBattleEffect, effectName, true)
    end
    if self.idle_effect ~= nil then
        self.idle_effect:SetToHeroAnchor(self)
        self:SetIdleEffectScale()
    else
        XDebug.LogError("cannot load idle effect")
    end
end

function ClientHero:SetIdleEffectScale()
    self.idle_effect.gameObject.transform.localScale = U_Vector3.one -- self.components.model.localScale
end

function ClientHero:SpawnIdleEffectBodyInBattle(effectId)
    --if self.heroModelType ~= HeroModelType.Dummy then
    local effectName = ClientConfigUtils.GetEffectNameById(effectId)
    XDebug.Log("EFFECT NAME battle " .. effectName)
    self:ReturnPoolIdleEffect()
    self.idle_effect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, effectName)
    if (self.idle_effect ~= nil) then
        self.idle_effect:SetToHeroAnchor(self)
        self:SetIdleEffectScale()
    else
        XDebug.LogError("cannot load idle effect")
    end
    --end
end
function ClientHero:DoFadeInOnStart()
    if self:IsDummy() then
        return
    end
    if self.originPosition ~= nil then
        self.animation:UpdateLayer(self.originPosition.y, 0)
    end
    self.animation:DoFade(0, 1, 0.8)
end

function ClientHero:PlayStartAnimation()
    self.animation:ChangeShaderByName(ClientConfigUtils.SPINE_SHADER)
    self.animation:EnableAnim(true)
    self.animation:ClearTracks()
    self.animation:SetToSetupPose()
    self:PlayIdleAnimation()
    self.animation:SetTrackTime(math.random(0, 130) / 100.0)
end

function ClientHero:InitStatusBar()
    if self.baseHero:IsSummoner() == true
            or self.baseHero.originInfo == nil then
        return
    end
    local statusBar = SmartPool.Instance:SpawnTransform(AssetType.Battle, "status_bar")
    self.uiHeroStatusBar = UIHeroStatusBar(statusBar)
    self.uiHeroStatusBar:InitCanvas()

    self.uiHeroStatusBar:SetTarget(self)
    self.uiHeroStatusBar:InitStatusBar(self.baseHero.level, self.baseHero.originInfo.faction)
    self.uiHeroStatusBar:UpdatePower(HeroConstants.DEFAULT_HERO_POWER)
end

--- @param mainTrackIndex number
function ClientHero:InitSkill(mainTrackIndex)
    self.mainTrackIndex = mainTrackIndex or 0
end

--- @param prefabName string
function ClientHero:SetPrefabName(prefabName)
    self.prefabName = prefabName
end

function ClientHero:SetSkin()
    self.defaultSkinName = ClientConfigUtils.GetSkinNameByHeroStar(self.baseHero.id, self.baseHero.star)
    self.skinName = ClientConfigUtils.GetSkinNameByBaseHero(self.baseHero)
    self.skinId = ClientConfigUtils.GetSkinIdByBaseHero(self.baseHero)
end

function ClientHero:SetEffectInUI(effectId)
    --XDebug.Log("SET EFFECT IN ui")
    if (effectId ~= nil) then
        self:SpawnIdleEffectBody(effectId)
    end
end

function ClientHero:SetEffectInBattle()
    --XDebug.Log("SET EFFECT IN BATTLE")
    local id = self.baseHero.equipmentController:GetItem(HeroItemSlot.IDLE_EFFECT)
    if (id ~= nil) then
        local _id = tonumber(id)
        if (_id > 0) then
            self:SpawnIdleEffectBody(_id, true)
        end
    end
end

--- @param baseHero BaseHero
function ClientHero:SetSkinByBaseHero(baseHero)
    self.baseHero = baseHero
    self.skinRarity = ClientConfigUtils.GetSkinRarityByBaseHero(baseHero)
    self:SetSkin()
end

--- @param listEffectConfig List -- <string>
function ClientHero:PreloadHeroEffectBySkin(listEffectConfig)
    if listEffectConfig == nil then
        return
    end
    local fileName
    for i = 1, listEffectConfig:Count() do
        fileName = listEffectConfig:Get(i)
        if self.skinName ~= nil then
            if string.match(fileName, self.skinName) then
                self.clientBattleShowController:PreloadHeroEffectType(fileName)
            end
        end
    end
end

--- @param position UnityEngine_Vector2
--- @param teamId number
function ClientHero:SetOriginalTransform(position, teamId)
    self.originPosition = position
    local trans = self.gameObject.transform
    trans.localEulerAngles = U_Vector3.zero
    trans.localScale = U_Vector3.one
    if self.baseHero.isBoss == true and teamId == BattleConstants.DEFENDER_TEAM_ID then
        local teamBossCount = self.clientBattleShowController:GetTeamBossCount(self.baseHero.teamId)
        local teamCount = self.clientBattleShowController:GetTeamCount(self.baseHero.teamId)
        if teamBossCount == 1 then
            if teamCount == 4 then
                self.originPosition = U_Vector3(3, -1.95, 0)
            else
                self.originPosition = U_Vector3(5.5, -1.95, 0)
            end
            trans.localScale = U_Vector3.one * 1.6
        elseif teamBossCount == 2 then
            trans.localScale = U_Vector3.one * 1.45
            if self.baseHero.positionInfo.position == 1 then
                self.originPosition = U_Vector3(6.9, -4.2, 0)
            elseif self.baseHero.positionInfo.position == 3 then
                self.originPosition = U_Vector3(6, -0.78, 0)
            end
        end
    end
    trans.position = self.originPosition
    self.animation:SetFlipByTeamId(teamId)
    self.animation:UpdateLayer(self.originPosition.y, 0)
end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero:DoAction(clientTurnDetail)
    ---@type ClientActionType
    local actionType = clientTurnDetail.actionType
    if actionType ~= ClientActionType.NOTHING then
        self.actionTurnDetail = clientTurnDetail
        self.clientBattleShowController:AddPendingClientAction(self, self.actionTurnDetail)
    end

    if actionType == ClientActionType.NOTHING then
        self:TriggerActionResult(clientTurnDetail)
    elseif actionType == ClientActionType.BASIC_ATTACK
            or actionType == ClientActionType.BONUS_ATTACK
            or actionType == ClientActionType.COUNTER_ATTACK then
        self:DoBasicAttack(clientTurnDetail)
    elseif actionType == ClientActionType.USE_SKILL then
        self:DoUseSkill(clientTurnDetail)
    elseif actionType == ClientActionType.BOUNCING_DAMAGE then
        local extraActionType = clientTurnDetail.extraTurnInfo.clientActionType
        if extraActionType == ClientActionType.BASIC_ATTACK then
            self:DoBasicAttack(clientTurnDetail)
        elseif extraActionType == ClientActionType.USE_SKILL then
            self:DoUseSkill(clientTurnDetail)
        end
    else
        assert(false, "Missing Do ClientActionType", actionType)
    end
end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero:DoBasicAttack(clientTurnDetail)
    self.castingSkill = self.basicAttack
    if clientTurnDetail ~= nil then
        self.basicAttack:SetClientTurnDetail(clientTurnDetail)
    else
        self.basicAttack:DoAnimation()
    end
end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero:DoUseSkill(clientTurnDetail)
    self.castingSkill = self.skillAttack
    self.skillAttack:SetClientTurnDetail(clientTurnDetail)
end

function ClientHero:TriggerActionResult()
    self.clientBattleShowController:TriggerActionResult()
end

function ClientHero:PlayIdleAnimation()
    self.animation:PlayAnimation(AnimationConstants.IDLE_ANIM, true)
end

function ClientHero:PlayStunAnimation()
    self.animation:PlayAnimation(AnimationConstants.STUN_ANIM, true)
end

--- @param deadActionResult DeadActionResult
function ClientHero:PlayDieAnimation(deadActionResult)
    self:StopAnimCoroutine()
    self.animCoroutine = Coroutine.start(function()
        self.animation:PlayAnimation(AnimationConstants.DIE_ANIM, false, self.mainTrackIndex)
        coroutine.waitforseconds(1.5)
        if self.isPlayingDead == true then
            self:SetActive(false)
            self.isPlayingDead = false
        end
    end)
end

function ClientHero:PlayGetHurtAnimation()
    if self.castingSkill ~= nil then
        return
    end
    self.animation:PlayAnimationWithCallback(AnimationConstants.GET_HURT_ANIM, function()
        if self.castingSkill == nil and self.isPlayingDead == false then
            self:PlayLastLoopAnimation()
        end
    end, false, self.mainTrackIndex)
end

--- @param actionResult BaseActionResult
function ClientHero:PlayRebornAnimation(actionResult)
    self:StopAnimCoroutine()

    self.animCoroutine = Coroutine.start(function()
        self.animation:ClearTrack(self.mainTrackIndex)
        self.animation:PlayAnimation(AnimationConstants.REBORN, false, self.mainTrackIndex)
        coroutine.waitforseconds(1.3)
        self.uiHeroStatusBar:SetActive(true)
        self:UpdateHealth(actionResult.targetHpPercent)
        self:PlayStartAnimation()
        self.clientBattleShowController:FinishClientAction(self, actionResult)
    end)
end

function ClientHero:PlayLastLoopAnimation()
    if self.isPlayingDead == true then
        return
    end
    if self.lastLoopAnimation == AnimationConstants.STUN_ANIM then
        self:PlayStunAnimation()
    else
        self:PlayIdleAnimation()
    end
end

--- @param animName string
--- @param isLoop boolean
--- @param trackIndex number
function ClientHero:PlayAnimation(animName, isLoop, trackIndex)
    self.animation:PlayAnimation(animName, isLoop, trackIndex)
end

--- @param animName string
--- @param callback function
--- @param isLoop boolean
--- @param trackIndex number
function ClientHero:PlayAnimationWithCallback(animName, callback, isLoop, trackIndex)
    self.animation:PlayAnimationWithCallback(animName, callback, isLoop, trackIndex)
end

--- @param animName string
function ClientHero:PlayAnimationEffectByFrame(animName)
    self.playSoundEffectByFrame:PlaySoundByAnim(animName)
    self.playAnimEffectByFrame:PlayAnimEffectByName(animName)
end

function ClientHero:BreakCastingSkill()
    if self.castingSkill ~= nil then
        self.castingSkill:BreakSkillAction()
        self.castingSkill = nil
    end
end

--- @param baseActionResult BaseActionResult
--- @param clientActionType ClientActionType
function ClientHero:DoActionResult(baseActionResult, clientActionType)
    self.clientHeroActionResultsHandler:HandleActionResult(baseActionResult, clientActionType)
end

--- @param actionResult BaseActionResult
function ClientHero:TriggerSubActiveSkill(actionResult)
    --- override
end

--- @param actionResultType ActionResultType
--- @param value number
function ClientHero:AddLogToStack(actionResultType, value)
    if self.damageFollowDict:IsContainKey(actionResultType) == false then
        self.damageFollowDict:Add(actionResultType, value)
    else
        local updateValue = self.damageFollowDict:Get(actionResultType)
        updateValue = updateValue + value
        self.damageFollowDict:Add(actionResultType, updateValue)
    end
end

function ClientHero:ClearLogStack()
    self.damageFollowDict = Dictionary()
end

function ClientHero:LogAllFromStack()
    if self.damageFollowDict:Count() == 0 then
        return
    end

    local tableValue = self.damageFollowDict:GetItems()
    local offsetY = -ClientConfigUtils.OFFSET_TEXT_LOG_FOLLOW_Y
    Coroutine.start(function()
        for _, v in pairs(tableValue) do
            coroutine.waitforseconds(ClientConfigUtils.DELAY_TEXT_LOG_FOLLOW)
            local battleTextLog = self.clientBattleShowController:GetUIBattleTextLog()
            if battleTextLog ~= nil then
                battleTextLog:LogDamageFollow(self, v, offsetY)
                offsetY = offsetY + BattleTextLogUtil.OFFSET_LOG_FOLLOW
            end
        end
    end)
end

--- @param actionResultType ActionResultType
--- @param damage number
--- @param isCrit boolean
--- @param dodgeType DodgeType
--- @param isBlock boolean
function ClientHero:LogDamageResult(actionResultType, damage, isCrit, isBlock, dodgeType)
    local battleTextLog = self.clientBattleShowController:GetUIBattleTextLog()
    if battleTextLog == nil then
        return
    end

    if dodgeType == DodgeType.MISS then
        battleTextLog:LogMiss(self)
    elseif dodgeType == DodgeType.GLANCING then
        battleTextLog:LogGlancing(self)
        local damageLog = self.clientBattleShowController:GetUIBattleTextLog()
        if damageLog ~= nil then
            damageLog:LogDamage(self, isCrit, damage)
        end
    elseif isBlock == true then
        battleTextLog:LogBlock(self)
        local _damageLog = self.clientBattleShowController:GetUIBattleTextLog()
        if _damageLog ~= nil then
            _damageLog:LogDamage(self, isCrit, damage)
        end
        local shieldBlockEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "shield_block")
        shieldBlockEffect:SetToHeroAnchor(self)
    elseif isBlock == false then
        battleTextLog:LogDamage(self, isCrit, damage)
    else
        if actionResultType == ActionResultType.REFLECT_DAMAGE then
            battleTextLog:LogDamage(self, isCrit, damage)
            local reflectLog = self.clientBattleShowController:GetUIBattleTextLog()
            if reflectLog ~= nil then
                reflectLog:LogReflect(self)
            end
        end
    end
end

function ClientHero:FinishActionTurn()
    self.castingSkill = nil
    if self.clientHeroEffectMgr:PriorityEffectShow() ~= nil then
        self:OnAddCCEffect(self.clientHeroEffectMgr:PriorityEffectShow())
    end

    self.clientBattleShowController:FinishClientAction(self, self.actionTurnDetail)
    --self.actionTurnDetail = nil
end

--- @param hpPercent number
function ClientHero:InitHealth(hpPercent)
    if self.uiHeroStatusBar ~= nil then
        self.uiHeroStatusBar:InitHealth(hpPercent)
    end
end

--- @param hpPercent number
function ClientHero:UpdateHealth(hpPercent)
    if self.uiHeroStatusBar ~= nil and hpPercent ~= nil then
        self.uiHeroStatusBar:UpdateHealth(hpPercent)
    end
end

--- @param powerPercent number
--- @param useTween boolean
function ClientHero:UpdatePower(powerPercent, useTween)
    if self.uiHeroStatusBar ~= nil and powerPercent ~= nil then
        useTween = useTween or true
        self.uiHeroStatusBar:UpdatePower(powerPercent, useTween)
    end
end

--- @param updatedEffects ClientEffectLogDetail
function ClientHero:UpdateEffect(updatedEffects)
    if updatedEffects == nil then
        return
    end

    local _listEffectChange = updatedEffects.effectDict:GetItems()
    self.clientHeroEffectMgr.effectIconBarMgr:UpdateTotalAtTurn(_listEffectChange)
    --- @param clientEffectDetail ClientEffectDetail
    for effectLogType, clientEffectDetail in pairs(_listEffectChange) do
        if ClientActionResultUtils.IsEffectHasIcon(effectLogType) then
            --self.clientHeroEffectMgr:UpdateEffectIconType(effectLogType, ClientEffectDetail)
        elseif ClientActionResultUtils.IsEffectHasMarkOnBar(effectLogType) then
            self.clientHeroEffectMgr:UpdateEffectMarkIconByType(effectLogType, clientEffectDetail)
        elseif ClientActionResultUtils.IsEffectHasMark(effectLogType) then
            self.clientHeroEffectMgr:UpdateEffectMarkType(effectLogType, clientEffectDetail)
        else
            assert(false, "Missing Update EffectLogType " .. effectLogType)
        end
    end
end

--- @param effectChangeResult EffectChangeResult
--- @param serverRound number
function ClientHero:UpdateCCEffect(effectChangeResult, serverRound)
    self.clientHeroEffectMgr:UpdateCCEffect(effectChangeResult, serverRound)
end

--- @param bondShareDamageResult BondShareDamageResult
function ClientHero:CreateDamageBondEffectShow(bondShareDamageResult)
    local bondLink = self.clientBattleShowController:GetBondLink()
    bondLink:MakeBond(self.clientBattleShowController:GetClientHeroByBaseHero(bondShareDamageResult.initiator),
            self.clientBattleShowController:GetClientHeroByBaseHero(bondShareDamageResult.target))
end

--- @param effectLogType EffectLogType
function ClientHero:OnAddCCEffect(effectLogType)
    if self.castingSkill ~= nil then
        return
    end
    self.clientHeroEffectMgr:OnAddCcEffect(effectLogType)

    if effectLogType == EffectLogType.STUN or effectLogType == EffectLogType.SLEEP then
        self.lastLoopAnimation = AnimationConstants.STUN_ANIM
        self:PlayLastLoopAnimation()
    elseif effectLogType == EffectLogType.FREEZE or effectLogType == EffectLogType.PETRIFY then
        self:OnCompleteGettingFreezed(effectLogType)
    else
        assert(false, "Missing OnAddCC EffectLogType " .. effectLogType)
    end
end

--- @param effectLogType EffectLogType
function ClientHero:OnRemoveCCEffect(effectLogType)
    if effectLogType == EffectLogType.STUN or effectLogType == EffectLogType.SLEEP then
        self.lastLoopAnimation = AnimationConstants.IDLE_ANIM
        self:PlayIdleAnimation()
    elseif effectLogType == EffectLogType.FREEZE or effectLogType == EffectLogType.PETRIFY then
        self.animation:ChangeShaderByName(ClientConfigUtils.SPINE_SHADER)
        self:RemoveFreezedByType(effectLogType)
        self.lastLoopAnimation = AnimationConstants.IDLE_ANIM
        self:PlayIdleAnimation()
    else
        assert(false, "Missing OnRemoveCC EffectLogType " .. effectLogType)
    end
end

--- @param effectLogType EffectLogType
function ClientHero:OnCompleteGettingFreezed(effectLogType)
    self.animation:EnableAnim(false)
    self.animation:KillTweenerShaderFloat()
    self.animation:ChangeShaderByName(ClientConfigUtils.SPINE_CUSTOM_SHADER)
    local texture
    if effectLogType == EffectLogType.FREEZE then
        texture = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBattleEffect, "ice", ComponentName.UnityEngine_Texture)
    elseif effectLogType == EffectLogType.PETRIFY then
        texture = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBattleEffect, "stone", ComponentName.UnityEngine_Texture)
    end
    self.animation:SetShaderTextureFieldById(ClientConfigUtils.FIELD_MIX_TEX_ID, texture)
    self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_PHASE_ID, 1)
    self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_MIX_ID, 1)
end

--- @param effectLogType EffectLogType
function ClientHero:RemoveFreezedByType(effectLogType)
    self.animation:EnableAnim(true)
    self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_PHASE_ID, 0)
    self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_MIX_ID, 0)
end

--- Need override
--- @param effectLogType EffectLogType
function ClientHero:OnAddEffect(effectLogType)
    if effectLogType == EffectLogType.NON_TARGETED_MARK then

    end
end

--- Need override
--- @param effectLogType EffectLogType
function ClientHero:OnRemoveEffect(effectLogType)
    if effectLogType == EffectLogType.NON_TARGETED_MARK then

    end
end

--- @param value number
function ClientHero:LogHealing(value)
    local battleTextLog = self.clientBattleShowController:GetUIBattleTextLog()
    if battleTextLog ~= nil then
        battleTextLog:LogHealing(self, value)
    end
    self.clientBattleShowController:ShowHealingEffect(self)
end

--- @param deadActionResult DeadActionResult
function ClientHero:Dead(deadActionResult)
    if self.isPlayingDead == true then
        self.clientBattleShowController:FinishClientAction(self, nil)
        if self.uiHeroStatusBar ~= nil then
            self.uiHeroStatusBar:SetActive(false)
        end
        return
    end
    if self.uiHeroStatusBar ~= nil then
        self.uiHeroStatusBar:SetActive(false)
    end
    self:SetActive(false)
end

--- @param deadForDisplayActionResult DeadForDisplayActionResult
function ClientHero:DeadForDisplay(deadForDisplayActionResult)
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
        self.clientBattleShowController:ShowDieEffect(self)
    end
end

--- @param actionResult ReviveActionResult
--- @param actionResult RebornActionResult
--- @param initiatorFaction number
--- @param isPermanent boolean
function ClientHero:DoRebornOrReviveActionResult(actionResult, initiatorFaction, isPermanent)
    self:SetActive(true)
    self:SetOriginalTransform(self.originPosition, self.baseHero.teamId)
    self.clientBattleShowController:ShowRebornOrReviveEffect(self, initiatorFaction, isPermanent)
    self:PlayRebornAnimation(actionResult)
end

--- @param regenerateActionResult RegenerateActionResult
--- @param clientActionType ClientActionType
function ClientHero:Regenerate(regenerateActionResult, clientActionType)
    self:SetActive(true)
    self.uiHeroStatusBar:SetActive(true)
    --- override
end

--- @param isActive boolean
function ClientHero:SetActive(isActive)
    if self.gameObject ~= nil then
        self.gameObject:SetActive(isActive)
    end
end

--- @param sortingLayerId number
function ClientHero:ChangeSortingLayerId(sortingLayerId)
    if self.animation ~= nil then
        self.animation:ChangeSortingLayerId(sortingLayerId)
    end
end

function ClientHero:DoFillMixTexture(textureName, fromAmount, toAmount, duration)
    local texture = ResourceLoadUtils.LoadTextureBattle(textureName)
    self.animation:SetShaderTextureFieldById(ClientConfigUtils.FIELD_MIX_TEX_ID, texture)
    self.animation:DoFadeShaderFloatById(ClientConfigUtils.FIELD_FILL_PHASE_ID, fromAmount, toAmount, duration)
end

function ClientHero:ReturnPool()
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
    if self.gameObject ~= nil then
        SmartPool.Instance:DespawnGameObject(AssetType.Hero, self.prefabName, self.gameObject.transform)
    end
end

function ClientHero:FakeBaseHero(heroId, star, level)
    if self.baseHero == nil then
        self.baseHero = BaseHero()
    end
    self.baseHero.id = heroId
    self.baseHero.star = star
    self.baseHero.level = level
end

--- @return boolean
function ClientHero:IsDummy()
    return self.baseHero == nil or self.baseHero.isDummy == true
end

--- @param format string
function ClientHero:GetEffectNameByFormat(format)
    if self.heroModelType ~= HeroModelType.Full then
        return nil
    end
    if self.skinRarity == SkinRarity.DEFAULT
            or self.skinRarity == SkinRarity.COMMON then
        return string.format(format, self.baseHero.id, self.defaultSkinName)
    end
    return string.format(format, self.baseHero.id, self.skinName)
end

--- @param actionResult TransformResult
function ClientHero:OnTransform(actionResult)

end

function ClientHero:StopAnimCoroutine()
    if self.animCoroutine ~= nil then
        ClientConfigUtils.KillCoroutine(self.animCoroutine)
        self.animCoroutine = nil
    end
end

function ClientHero:UpdateIdleEffectLayer()
    if self.idle_effect ~= nil then
        self.idle_effect:SetToHeroAnchor(self)
    end
end

function ClientHero:ReleaseEffect()
    if self.listEffect ~= nil then
        for i = 1, self.listEffect:Count() do
            --- @type ClientEffect
            local effect = self.listEffect:Get(i)
            effect:Release()
        end
    end
end

--- @param effect ClientEffect
function ClientHero:AddEffect(effect)
    if effect ~= nil then
        self.listEffect:Add(effect)
    end
end

--- @param target ClientHero
function ClientHero:OnTransferStat(target)
    print("OnTransferStat")
end

function ClientHero:ReturnPoolIdleEffect()
    self.idle_effect = nil
    --[[    if self.idle_effect ~= nil then
            self.idle_effect:ReturnPool()
            self.idle_effect = nil
        end]]
end


