--- @type UnityEngine_Quaternion
local U_Quaternion = UnityEngine.Quaternion

require "lua.client.battleShow.ClientEffect.EffectVisual.ClientEffectVisual"
require "lua.client.battleShow.ClientEffect.EffectVisual.ParticleEffectVisual"
require "lua.client.battleShow.ClientEffect.EffectVisual.SpineEffectVisual"
require "lua.client.battleShow.ClientEffect.EffectVisual.SpriteEffectVisual"

--- @class ClientEffect
ClientEffect = Class(ClientEffect)

function ClientEffect:Ctor()
    self.isActive = false
    --- @type
    self.isInited = false
    --- @type {gameObject : UnityEngine_GameObject, transform : UnityEngine_Transform, skeletonAnimation : Spine_Unity_SkeletonAnimation, timeLife : number}
    self.config = nil
    --- @type {bounceBezier : CS_BezierSpline}
    self.configTable = {}
    --- @type number
    self.battleEffectType = nil
    --- @type string
    self.prefabName = nil
    --- @type UnityEngine_GameObject
    self.gameObject = nil

    self.playCoroutine = nil
    self.moveTweener = nil
    self.moveCoroutine = nil
    self.moveLinePointCoroutine = nil
    self.moveLineWidthCoroutine = nil

    --- @type ClientHero
    self.currentHeroAnchor = nil

    --- @type table
    self.targetLayerChangedListener = ClientHeroLayerChangeEvent(self, self.OnTargetLayerChanged)
end

--- @param configTable table
function ClientEffect:InitConfig(configTable)
    self.configTable = configTable
    if configTable.main_visual ~= nil then
        self.config.mainVisual = self.config.transform:Find(configTable.main_visual).gameObject
    end
end

--- @param effectType string
--- @param effectName string
--- @param effectPoolType GeneralEffectPoolType or HeroEffectPoolType
--- @param luaConfigFilePath string
function ClientEffect:InitRef(effectType, effectName, effectPoolType, luaConfigFilePath)
    self.effectType = effectType
    self.prefabName = effectName
    self.luaConfigFilePath = luaConfigFilePath
    self.effectPoolType = effectPoolType
    self:SetGameObject()
end

function ClientEffect:SetGameObject()
    if self.gameObject == nil then
        self.gameObject = SmartPool.Instance:CreateGameObject(self.effectType, self.prefabName, zgUnity.transform)
        if self.gameObject == nil then
            XDebug.Error(string.format("Effect is nil: %s %s", tostring(self.effectType), tostring(self.prefabName)))
            return
        end
    end
    self.config = require(self.luaConfigFilePath)(self.gameObject.transform)
end

--- @param key string
--- @param value {}
function ClientEffect:AddConfigField (key, value)
    if key ~= nil and value ~= nil then
        self.configTable[key] = value
    end
end

--- @return boolean
function ClientEffect:IsActiveSelf()
    return self.gameObject.activeSelf
end

--- @param position UnityEngine_Vector3
function ClientEffect:SetPosition(position)
    self.config.transform.position = position
end

--- @param localScale UnityEngine_Vector3
function ClientEffect:SetLocalScale(localScale)
    self.config.transform.localScale = localScale
end

--- @param parent UnityEngine_Transform
function ClientEffect:SetParent(parent)
    self.config.transform:SetParent(parent)
end

--- @return UnityEngine_Vector3
function ClientEffect:GetPosition()
    return self.config.transform.position
end

--- @param clientHero ClientHero
--- @param isPermanent boolean
function ClientEffect:SetToHeroAnchor(clientHero,isPermanent,notSetRotation)
    if clientHero == nil then
        self:Release()
        return
    end
    if (self.config == nil) then
        XDebug.Log("CONFIG NIL " .. self.prefabName)
    end
    --print(debug.traceback())
    self:SetPosition(clientHero.components:GetAnchorPosition(self.config.anchor))
    if (notSetRotation ~= true) then
        self.config.transform.rotation = clientHero.components:Rotation()
    end
    self.config.transform.localScale = clientHero.components:LocalScale()

    if self.config.isChildTarget == true or isPermanent then
        self.config.transform:SetParent(clientHero.components:GetHeroAnchor(self.config.anchor))
    end
    if self.config.isSyncLayerToTarget == true
            and self.config.listEffectVisual ~= nil then
        self.currentHeroAnchor = clientHero
        self:SyncLayerToTarget(self.currentHeroAnchor)
        self.currentHeroAnchor.animation:AddLayerChangedListener(self.targetLayerChangedListener)
    end
    if isPermanent then
        clientHero:AddEffect(self)
    end
    self:Play(isPermanent)
end

--- @param position UnityEngine_Vector3
function ClientEffect:LookAtPosition(position)
    local dir = position - self.config.transform.position
    if math.abs(dir.y) < 0.1 then
        dir.y = 0.1
    end
    self.config.transform.right = dir
    if dir.x < 0 then
        local angle = self.config.transform.localEulerAngles
        angle.y = 180
        angle.z = -(angle.z + 180)
        self.config.transform.localEulerAngles = angle
    end
end

--- @param destination UnityEngine_Vector3
--- @param duration number
--- @param onComplete function
function ClientEffect:DoMoveTween(destination, duration, onComplete)
    ClientConfigUtils.KillTweener(self.moveTweener)
    self.moveTweener = self.config.transform:DOMove(destination, duration):OnComplete(function()
        if onComplete ~= nil then
            onComplete()
        end
        self.moveTweener = nil
    end)
end
--- @param isPermanent boolean
function ClientEffect:Play(isPermanent)
    self:SetActive(true)
    if self.config.mainVisual ~= nil then
        self.config.mainVisual:SetActive(true)
    end
    if not isPermanent then
        local timeLife = self.config.timeLife
        if timeLife > 0 then
            ClientConfigUtils.KillCoroutine(self.playCoroutine)
            self.playCoroutine = Coroutine.start(function()
                coroutine.waitforseconds(timeLife)
                self.playCoroutine = nil
                self:Release()
            end)
        end
    end
    if self.config.battleEffectType == ClientConfigUtils.SPINE_BATTLE_EFFECT_TYPE
            and self.config.skeletonAnimation ~= nil then
        --self.config.skeletonAnimation.AnimationState:ClearTracks()
        --self.config.skeletonAnimation.skeleton:SetToSetupPose()
        self.config.skeletonAnimation.AnimationState:SetAnimation(0, self.config.defaultSpineAnim, self.config.skeletonAnimation.loop)
    end
end

--- @param skinName string
function ClientEffect:UpdateSkin(skinName)
    if self.config.skeletonAnimation ~= nil then
        self.config.skeletonAnimation.skeleton:SetSkin(skinName)
    end
end

function ClientEffect:Release()
    if self.config.mainVisual ~= nil then
        self.config.mainVisual:SetActive(false)
    end
    if self.currentHeroAnchor ~= nil then
        self.currentHeroAnchor.animation:RemoveLayerChangedListener(self.targetLayerChangedListener)
        self.currentHeroAnchor = nil
    end

    if self.config.delayDespawnOnRelease > 0 then
        ClientConfigUtils.KillCoroutine(self.playCoroutine)
        self.playCoroutine = Coroutine.start(function()
            coroutine.waitforseconds(self.config.delayDespawnOnRelease)
            self.playCoroutine = nil
            self:ReturnPool()
        end)
    else
        self:ReturnPool()
    end
end

function ClientEffect:KillAction()
    ClientConfigUtils.KillCoroutine(self.playCoroutine)
end

function ClientEffect:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

function ClientEffect:ReturnPool()
    if self.config then
        self.config.gameObject:SetActive(false)
    end
--[[    local canReturn = SmartPool.Instance:CheckCanReturnObjectList(self.effectType, self.effectPoolType, self)
    if (canReturn == true) then
        SmartPool.Instance:DespawnLuaGameObject(self.effectType, self.effectPoolType, self)
    end]]
    SmartPool.Instance:DespawnLuaGameObject(self.effectType, self.effectPoolType, self)
    zg.battleEffectMgr:ReleaseClientEffect(self)
    ClientConfigUtils.KillTweener(self.moveTweener)
    ClientConfigUtils.KillCoroutine(self.moveCoroutine)
    ClientConfigUtils.KillCoroutine(self.playCoroutine)
    ClientConfigUtils.KillCoroutine(self.moveLinePointCoroutine)
    ClientConfigUtils.KillCoroutine(self.moveLineWidthCoroutine)
    self.isActive = false
end

--- @return UnityEngine_Transform
--- @param path string
function ClientEffect:FindChildByPath(path)
    return self.config.transform:Find(path)
end

--- @param lineRenderer UnityEngine_LineRenderer
--- @param pointIndex number
--- @param toPosition UnityEngine_Vector3
--- @param duration number
--- @param delayMove number
--- @param onComplete function
function ClientEffect:MoveLineRendererPointIndexToPosition(lineRenderer, pointIndex, toPosition, duration, delayMove, onComplete)
    ClientConfigUtils.KillCoroutine(self.moveLinePointCoroutine)
    self.moveLinePointCoroutine = Coroutine.start(function()
        coroutine.waitforseconds(delayMove)
        local originPos = lineRenderer:GetPosition(pointIndex)
        local dir = toPosition - originPos
        local currentPos = originPos
        local elapse = 0
        local progress = 0
        while elapse < duration do
            progress = elapse / duration
            dir = toPosition - originPos
            currentPos = originPos + dir * progress
            lineRenderer:SetPosition(pointIndex, currentPos)
            coroutine.yield(nil)
            elapse = elapse + U_Time.deltaTime
        end
        lineRenderer:SetPosition(pointIndex, toPosition)
        coroutine.yield(nil)
        if onComplete ~= nil then
            onComplete()
        end
        self.moveLinePointCoroutine = nil
    end)
end

--- @param lineRenderer UnityEngine_LineRenderer
--- @param targetWidth number
--- @param duration number
--- @param delay number
--- @param onComplete function
function ClientEffect:TweenLineRendererWidth(lineRenderer, targetWidth, duration, delay, onComplete)
    ClientConfigUtils.KillCoroutine(self.moveLineWidthCoroutine)
    self.moveLineWidthCoroutine = Coroutine.start(function()
        coroutine.waitforseconds(delay)
        local elapse = 0
        local startWidth = lineRenderer.startWidth
        local progress = 0
        while elapse < duration do
            progress = elapse / duration
            lineRenderer.startWidth = startWidth + (targetWidth - startWidth) * progress
            coroutine.yield(nil)
            elapse = elapse + U_Time.deltaTime
        end
        lineRenderer.startWidth = targetWidth
        coroutine.yield(nil)
        if onComplete ~= nil then
            onComplete()
        end
        self.moveLineWidthCoroutine = nil
    end)
end

--- @param fromClientHero ClientHero
--- @param toClientHero ClientHero
function ClientEffect:DoCurveMoveBetweenHero(fromClientHero, toClientHero, onComplete)
    local startPos = fromClientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self:SetPosition(startPos)

    --- @return boolean
    local function IsReachTarget(dest)
        --- @type UnityEngine_Vector3
        local vector = dest - self:GetPosition()
        return vector.sqrMagnitude < 0.25
    end

    ClientConfigUtils.KillCoroutine(self.moveCoroutine)
    self.moveCoroutine = Coroutine.start(function()
        local uMathf = U_Mathf
        local uTime = U_Time
        local uVector3 = U_Vector3

        local originSpeed = self.configTable.originSpeed
        local deltaSpeed = self.configTable.deltaSpeed
        local rotationSpeed = self.configTable.rotationSpeed
        local deltaTime

        --local dest = toClientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
        --local bodyLocalPos = toClientHero.components:GetHeroAnchor(ClientConfigUtils.BODY_ANCHOR).position

        local dest = toClientHero.components:GetHeroAnchor(ClientConfigUtils.BODY_ANCHOR).position
        dest = uVector3(dest.x, dest.y, 0)

        --- @type UnityEngine_Vector3
        local range = (dest - startPos).magnitude

        local targetDir = dest - startPos
        local newDir = targetDir
        self.config.transform.right = -targetDir
        local speed = originSpeed
        local rotSpeed = (self.configTable.rotationSpeed + math.random(-50, 50) / 100.0) * 10 / range
        local elapse = 0

        while IsReachTarget(dest) == false do
            coroutine.yield(nil)
            deltaTime = uTime.deltaTime
            elapse = elapse + deltaTime
            if elapse > self.config.timeLife then
                self:Release()
                return
            end
            --dest = toClientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
            newDir = (dest - self:GetPosition()).normalized
            if uMathf.Sign(newDir.x) ~= uMathf.Sign(targetDir.x) then
                self:Release()
                return
            end
            targetDir = newDir
            local angle = uMathf.Atan2(targetDir.y, targetDir.x) * uMathf.Rad2Deg
            local rotToTarget = U_Quaternion.AngleAxis(angle, uVector3.forward)
            self.config.transform.rotation = U_Quaternion.Slerp(self.config.transform.rotation, rotToTarget, uTime.deltaTime * rotSpeed)
            self.config.transform:Translate(uVector3.right * speed * uTime.deltaTime)

            speed = speed + deltaSpeed * deltaTime
            rotSpeed = rotSpeed + rotationSpeed * deltaTime
        end
        if onComplete ~= nil then
            onComplete()
        end
        self:Release()
    end)
end

--- @param fromPos UnityEngine_Vector3
--- @param toPos UnityEngine_Vector3
function ClientEffect:DoCurveMoveBetweenPosition(fromPos, toPos, onComplete)
    self:SetPosition(fromPos)

    --- @return boolean
    local function IsReachTarget(dest)
        --- @type UnityEngine_Vector3
        local vector = dest - self:GetPosition()
        return vector.sqrMagnitude < 0.25
    end

    ClientConfigUtils.KillCoroutine(self.moveCoroutine)
    self.moveCoroutine = Coroutine.start(function()
        local uMathf = U_Mathf
        local uTime = U_Time
        local uVector3 = U_Vector3
        local U_Quaternion = U_Quaternion

        local originSpeed = self.configTable.originSpeed
        local deltaSpeed = self.configTable.deltaSpeed
        local rotationSpeed = self.configTable.rotationSpeed
        local deltaTime

        --- @type UnityEngine_Vector3
        local range = (toPos - fromPos).magnitude

        local targetDir = toPos - fromPos
        local newDir = targetDir
        self.config.transform.right = -targetDir
        local speed = originSpeed
        local rotSpeed = (self.configTable.rotationSpeed + math.random(-50, 50) / 100.0) * 10 / range
        local elapse = 0

        while IsReachTarget(toPos) == false do
            coroutine.yield(nil)
            deltaTime = uTime.deltaTime
            elapse = elapse + deltaTime
            if elapse > self.config.timeLife then
                self:Release()
                return
            end
            newDir = (toPos - self:GetPosition()).normalized
            if uMathf.Sign(newDir.x) ~= uMathf.Sign(targetDir.x) then
                self:Release()
                return
            end
            targetDir = newDir
            local angle = uMathf.Atan2(targetDir.y, targetDir.x) * uMathf.Rad2Deg
            local rotToTarget = U_Quaternion.AngleAxis(angle, uVector3.forward)
            self.config.transform.rotation = U_Quaternion.Slerp(self.config.transform.rotation, rotToTarget, uTime.deltaTime * rotSpeed)
            self.config.transform:Translate(uVector3.right * speed * uTime.deltaTime)

            speed = speed + deltaSpeed * deltaTime
            rotSpeed = rotSpeed + rotationSpeed * deltaTime
        end
        if onComplete ~= nil then
            onComplete()
        end
        self:Release()
    end)
end

--- @param clientHero ClientHero
function ClientEffect:SyncLayerToTarget(clientHero)
    for i = 1, self.config.listEffectVisual:Count() do
        --- @type ClientEffectVisual
        self.config.listEffectVisual:Get(i):OnTargetLayerChanged(clientHero)
    end
end

--- @param clientHero ClientHero
function ClientEffect:SyncLayerByConfig(clientHero)
    for i = 1, self.config.listEffectVisual:Count() do
        --- @type ClientEffectVisual
        self.config.listEffectVisual:Get(i):OnTargetLayerChanged(clientHero)
    end
end

function ClientEffect:OnTargetLayerChanged()
    self:SyncLayerToTarget(self.currentHeroAnchor)
end

--- @param sortingLayerId number
--- @param sortingOrder number
function ClientEffect:SyncLayerByParams(sortingLayerId, sortingOrder)
    for i = 1, self.config.listEffectVisual:Count() do
        --- @type ClientEffectVisual
        local effectVisual = self.config.listEffectVisual:Get(i)
        effectVisual:SyncLayerByParams(sortingLayerId, sortingOrder)
    end
end

--- @return ClientEffect
--- @param gameObject UnityEngine_GameObject
function ClientEffect.CreateByGameObject(gameObject)
    local clientEffect = ClientEffect()
    --- @type {gameObject : UnityEngine_GameObject, transform : UnityEngine_Transform}
    clientEffect.config = {}
    clientEffect.config.gameObject = gameObject
    clientEffect.config.transform = gameObject.transform
    clientEffect.config.listEffectVisual = List()
    local listEffectVisual = gameObject:GetComponentsInChildren(typeof(CS.IS.Battle.EffectVisual))
    for i = 0, listEffectVisual.Length - 1 do
        local effectVisual = listEffectVisual[i]
        clientEffect.config.listEffectVisual:Add(ParticleEffectVisual(gameObject.transform, "",
                effectVisual._isSyncSortingLayerId,
                effectVisual._isSyncSortingOrder,
                effectVisual._offsetSortingOrder))
    end
    return clientEffect
end

return ClientEffect