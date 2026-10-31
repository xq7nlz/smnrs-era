--- @class BaseSkillShow
BaseSkillShow = Class(BaseSkillShow)

--- @param clientHero ClientHero
function BaseSkillShow:Ctor(clientHero, isBasicAttack)
    --- @type ClientHero
    self.clientHero = clientHero

    --- @type boolean
    self.isBasicAttack = isBasicAttack or false
    --- @type string
    if isBasicAttack == true then
        self.animName = AnimationConstants.ATTACK_ANIM
    else
        self.animName = AnimationConstants.SKILL_ANIM
    end

    --- @type Coroutine
    self.actionCoroutine = nil
    --- @type DG_Tweening_Tweener
    self.moveTween = nil

    --- @type List<table{number, function}>
    self.listFrameAction = List()
    --- @type boolean
    self.bonusTurnNum = 0

    --- @type {skill_impact_type, skill_impact_name}
    self.fxImpactConfig = nil
    --- @type {sfx_impact_type, sfx_impact_name}
    self.sfxImpactConfig = nil

    if self.clientHero.heroModelType == HeroModelType.Basic then
        self:InitBasicModel()
    end

    if self.clientHero.heroModelType ~= HeroModelType.Full then
        return
    end

    --- @type BaseHero
    self.baseHero = clientHero.baseHero
    --- @type List<BaseHero>
    self.listTargetHero = List()
    self.fxImpactName = nil
    self.projectileLaunchPos = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    --- @type ClientBattleShowController
    self.clientBattleShowController = clientHero.clientBattleShowController
    self:GetFxImpactFromConfig()
    self:GetSfxImpactFromConfig()

    if self.isBasicAttack == true then
        self.projectileName = string.format("hero_%d_%s", self.baseHero.id,
                ClientConfigUtils.DEFAULT_ATTACK_PROJECTILE)
    else
        self.projectileName = string.format("hero_%d_%s", self.baseHero.id,
                ClientConfigUtils.DEFAULT_SKILL_PROJECTILE)
    end
    self:SetOffsetAccostX()
    self:DeliverCtor()
end

function BaseSkillShow:InitBasicModel()

end

function BaseSkillShow:DeliverCtor()

end

function BaseSkillShow:GetFxImpactFromConfig()
    self.fxImpactConfig = ResourceMgr.GetHeroesConfig():GetHeroEffectImpact():GetFx(self.baseHero.id,
            self.isBasicAttack,
            self.clientHero.skinId)
    if self.fxImpactConfig ~= nil and self.fxImpactConfig.skill_impact_type == AssetType.GeneralBattleEffect then
        self.clientBattleShowController:AddPreloadGeneralBattleEffect(self.fxImpactConfig.skill_impact_name)
    end
end

function BaseSkillShow:GetSfxImpactFromConfig()
    self.sfxImpactConfig = ResourceMgr.GetHeroesConfig():GetHeroSfxImpact():GetSfx(self.baseHero.id, tostring(self.clientHero.skinId), self.isBasicAttack)
    if self.sfxImpactConfig ~= nil and self.clientBattleShowController ~= nil then
        self.clientBattleShowController:PreloadSfxGeneralBattleSound(self.sfxImpactConfig.sfx_impact_type, self.sfxImpactConfig.sfx_impact_name)
    end
end

--- @param frameAnimLength number
--- @param frameEndTurn number
--- @param frameActionResult number
--- @param frameEffect number
function BaseSkillShow:SetFrameActionEvent(frameAnimLength, frameEndTurn, frameActionResult, frameEffect)
    self:AddFrameAction(frameAnimLength, function()
        self:OnEndAnimation()
    end)
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        return
    end
    self:AddFrameAction(frameEndTurn, function()
        self:OnCompleteActionTurn()
    end)
    self:AddFrameAction(frameActionResult, function()
        self:OnTriggerActionResult()
    end)
    self:AddFrameAction(frameEffect, function()
        self:OnCastEffect()
    end)
    self:DeliverSetFrameAction()
end

function BaseSkillShow:DeliverSetFrameAction()

end

function BaseSkillShow:OnCompleteActionTurn()
    self:OnEndTurn()
end

function BaseSkillShow:DoAnimation()
    self.clientHero:PlayAnimation(self.animName, false, self.clientHero.mainTrackIndex)
    self.clientHero:PlayAnimationEffectByFrame(self.animName)

    self:PlayFrameAction(self.listFrameAction)
end

--- @param listFrameAction List
function BaseSkillShow:PlayFrameAction(listFrameAction)
    ClientConfigUtils.KillCoroutine(self.actionCoroutine)
    self.actionCoroutine = Coroutine.start(function()
        coroutine.waitforseconds(listFrameAction:Get(1).frame * AnimationConstants.FRAME_LENGTH)
        listFrameAction:Get(1):action()
        for i = 2, listFrameAction:Count() do
            local waitTime = (listFrameAction:Get(i).frame - listFrameAction:Get(i - 1).frame) * AnimationConstants.FRAME_LENGTH
            coroutine.waitforseconds(waitTime)
            listFrameAction:Get(i):action()
        end
        self.actionCoroutine = nil
    end)
end

--- @param clientTurnDetail ClientTurnDetail
function BaseSkillShow:SetClientTurnDetail(clientTurnDetail)
    local extraTurnInfo = clientTurnDetail.extraTurnInfo
    if extraTurnInfo ~= nil then
        if extraTurnInfo.clientActionType == ClientActionType.BONUS_ATTACK then
            self.bonusTurnNum = extraTurnInfo.numberBonusTurn
        end
    end
    self:CastOnTarget(clientTurnDetail.actionList)
end

--- @param bonusTurnNum number
function BaseSkillShow:SetBonusTurn(bonusTurnNum)
    self.bonusTurnNum = bonusTurnNum
end

--- @param actionResults List<BaseActionResult>
function BaseSkillShow:CastOnTarget(actionResults)
    self:GetListTargetFromActions(actionResults)
end

--- @param actionResults List<BaseActionResult>
function BaseSkillShow:GetListTargetFromActions(actionResults)
    self.listTargetHero = List()
    for i = 1, actionResults:Count() do
        --- @type BaseActionResult
        local baseActionResult = actionResults:Get(i)
        if baseActionResult.initiator == self.baseHero then
            local _actionResultType = actionResults:Get(i).type
            if _actionResultType == ActionResultType.ATTACK
                    or _actionResultType == ActionResultType.USE_ACTIVE_DAMAGE_SKILL
                    or _actionResultType == ActionResultType.COUNTER_ATTACK
                    or _actionResultType == ActionResultType.BONUS_ATTACK
                    or _actionResultType == ActionResultType.INSTANT_KILL
                    or _actionResultType == ActionResultType.BOUNCING_DAMAGE then
                self.listTargetHero:Add(actionResults:Get(i).target)
            end
        end
    end
end

--- @param counterAttackResult CounterAttackResult
function BaseSkillShow:CounterAttackOnTarget(counterAttackResult)
    self.listTargetHero = List()
    self.listTargetHero:Add(counterAttackResult.target)
end

function BaseSkillShow:OnEndAnimation()
    self.clientHero:PlayLastLoopAnimation()
    if self.bonusTurnNum > 0 then
        ClientConfigUtils.KillCoroutine(self.actionCoroutine)
        self:OnEndTurn()
    end
end

function BaseSkillShow:OnEndTurn()
    self.clientHero:FinishActionTurn()
end

function BaseSkillShow:OnTriggerActionResult()
    self:CastImpactFromConfig()
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function BaseSkillShow:CastImpactFromConfig()
    if self.fxImpactConfig ~= nil then
        self:CastNewClientImpactOnTargets(self.fxImpactConfig.skill_impact_type, self.fxImpactConfig.skill_impact_name)
    end
end

function BaseSkillShow:CastSfxImpactFromConfig()
    --if self.sfxImpactPath ~= nil then
    --    zg.audioMgr:PlaySound(self.sfxImpactPath)
    --end
    if self.sfxImpactConfig ~= nil then
        zg.audioMgr:PlaySound(self.sfxImpactConfig.sfx_impact_type, self.sfxImpactConfig.sfx_impact_name)
    end
end

function BaseSkillShow:OnCastEffect()
    --- override
end

function BaseSkillShow:BreakSkillAction()
    ClientConfigUtils.KillCoroutine(self.actionCoroutine)
    ClientConfigUtils.KillTweener(self.moveTween)
end

function BaseSkillShow:DoActionOnListTarget()
    --- override
end

--- @param effectType string
--- @param effectName string
function BaseSkillShow:CastNewClientImpactOnTargets(effectType, effectName)
    for i = 1, self.listTargetHero:Count() do
        --- @type ClientEffect
        local fxImpact = self:GetClientEffect(effectType, effectName)
        if fxImpact ~= nil then
            local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            fxImpact:SetToHeroAnchor(clientTargetHero)
        end
    end
end

--- @param effectType string
--- @param effectName string
--- @param flyTime number
--- @param targetAnchorId number
function BaseSkillShow:CastNewProjectileOnTargets(effectType, effectName, flyTime, targetAnchorId, launchPos)
    flyTime = flyTime or ClientConfigUtils.PROJECTILE_FRY_TIME
    targetAnchorId = targetAnchorId or ClientConfigUtils.BODY_ANCHOR
    launchPos = launchPos or self.projectileLaunchPos
    effectName = effectName or self.projectileName
    --- @type ClientHero
    local clientTargetHero
    --- @type ClientEffect
    local targetPosition
    for i = 1, self.listTargetHero:Count() do
        local projectile = self:GetClientEffect(effectType, effectName)
        if projectile ~= nil then
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            if clientTargetHero ~= nil then
                targetPosition = clientTargetHero.components:GetAnchorPosition(targetAnchorId)
                projectile:SetPosition(launchPos)
                projectile:LookAtPosition(targetPosition)
                projectile:DoMoveTween(targetPosition, flyTime, function()
                    projectile:Release()
                end)
                projectile:Play()
            end
        end
    end
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function BaseSkillShow:GetClientEffect(effectType, effectName)
    return self.clientBattleShowController:GetClientEffect(effectType, effectName)
end

function BaseSkillShow:DoCoverBattle(coverDuration, fadeInDuration, fadeOutDuration, coverAlpha, onEndFadeIn, onEndFade)
    self.clientBattleShowController:DoCoverBattle(coverDuration, fadeInDuration, fadeOutDuration, coverAlpha, onEndFadeIn, onEndFade)
    self:ChangeListTargetLayer(ClientConfigUtils.FRONT_BATTLE_LAYER_ID)
end

--- @param sortingLayerId number
function BaseSkillShow:ChangeListTargetLayer(sortingLayerId)
    self.clientBattleShowController:ChangeHeroLayerByBaseHero(self.baseHero, sortingLayerId)

    --- @param v BaseHero
    for _, v in pairs(self.listTargetHero:GetItems()) do
        self.clientBattleShowController:ChangeHeroLayerByBaseHero(v, sortingLayerId)
    end
end

--- @param frame number
--- @param action function
function BaseSkillShow:AddFrameAction(frame, action)
    if frame < 0 then
        return
    end
    self.listFrameAction = self:CreateSerializeListActionByFrame(frame, action, self.listFrameAction)
end

--- @param frame number
--- @param action function
--- @param currentList List
function BaseSkillShow:CreateSerializeListActionByFrame(frame, action, currentList)
    local actionTable = {}
    actionTable.frame = frame
    actionTable.action = action
    local isAdded = false

    local serializedList = List()
    for i = 1, currentList:Count() do
        if actionTable.frame <= currentList:Get(i).frame
                and isAdded == false then
            serializedList:Add(actionTable)
            isAdded = true
        end
        serializedList:Add(currentList:Get(i))
    end
    if isAdded == false then
        serializedList:Add(actionTable)
        isAdded = true
    end
    return serializedList
end

--- @param clientTargetHero ClientHero
--- @param onComplete function
--- @param offsetAccostY number
--- @param offsetAccostX number
--- @param duration number
--- @param easeType DOTweenEase
function BaseSkillShow:AccostTarget(clientTargetHero, onComplete, offsetAccostX, offsetAccostY, duration, easeType)
    if clientTargetHero == nil then
        return
    end
    offsetAccostX = offsetAccostX or self.offsetAccostX
    offsetAccostY = offsetAccostY or ClientConfigUtils.OFFSET_ACCOST_Y
    duration = duration or ClientConfigUtils.EXECUTE_MOVE_TIME
    easeType = easeType or DOTweenEase.Linear
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    targetPosition.y = targetPosition.y - offsetAccostY
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        targetPosition.x = targetPosition.x - offsetAccostX
    else
        targetPosition.x = targetPosition.x + offsetAccostX
    end
    self.moveTween = self.clientHero.clientHeroMovement:DoMovePosition(targetPosition, function()
        if onComplete then
            onComplete()
        end
    end, duration, easeType)
end

--- @param baseOffsetAccostX number
--- @param bossOffsetMultiplier number
function BaseSkillShow:SetOffsetAccostX(baseOffsetAccostX, bossOffsetMultiplier)
    baseOffsetAccostX = baseOffsetAccostX or ClientConfigUtils.OFFSET_ACCOST_X
    bossOffsetMultiplier = bossOffsetMultiplier or 1.5
    self.offsetAccostX = baseOffsetAccostX
    if self.baseHero.isBoss == true then
        self.offsetAccostX = self.offsetAccostX * bossOffsetMultiplier
    end
end

--- @return DG_Tweening_Tweener
--- @param position UnityEngine_Vector3
--- @param duration number
--- @param onComplete function
--- @param easeType DOTweenEase
function BaseSkillShow:DoMovePosition(position, onComplete, duration, easeType)
    self.moveTween = self.clientHero.clientHeroMovement:DoMovePosition(position, onComplete, duration, easeType)
end

return BaseSkillShow