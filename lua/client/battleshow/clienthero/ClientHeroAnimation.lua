--- @class ClientHeroAnimation
ClientHeroAnimation = Class(ClientHeroAnimation)

--- @param clientHero ClientHero
--- @param mainTrackIndex number
function ClientHeroAnimation:Ctor(clientHero, mainTrackIndex)
    self._freezeCoroutine = nil
    self.mainTrackIndex = mainTrackIndex
    --- @type ClientHero
    self.clientHero = clientHero

    --- @type Spine_Unity_SkeletonAnimation
    self.anim = nil
    --- @type UnityEngine_MeshRenderer
    self.meshRenderer = nil

    --- @type List<ClientHeroLayerChangeEvent>
    self._layerEventListener = List()

    self._tweenerMixText = nil

    self._tweenerShaderFloat = nil

    --- @type UnityEngine_MaterialPropertyBlock
    self._propBlock = U_MaterialPropertyBlock()

    --- @type string
    self._playingAnimation = nil

    self:Init(self.clientHero.gameObject)
end

function ClientHeroAnimation:Init(gameObject)
    self.anim = gameObject:GetComponentInChildren(ComponentName.Spine_Unity_SkeletonAnimation)
    self.meshRenderer = self.anim:GetComponent(ComponentName.UnityEngine_MeshRenderer)
    self.meshRenderer:GetPropertyBlock(self._propBlock)
end

--- @param animName string
--- @param isLoop boolean
--- @param trackIndex number
function ClientHeroAnimation:PlayAnimation(animName, isLoop, trackIndex)
    if self.anim.enabled == false then
        return
    end
    trackIndex = trackIndex or self.mainTrackIndex
    self.anim.AnimationState:SetAnimation(trackIndex, animName, isLoop)
    if self.clientHero.mainTrackIndex == trackIndex then
        self._playingAnimation = animName
    end
end

--- @param animName string
--- @param isLoop boolean
--- @param trackIndex number
--- @param callback function
function ClientHeroAnimation:PlayAnimationWithCallback(animName, callback, isLoop, trackIndex)
    if self.anim.enabled == false then
        return
    end
    isLoop = isLoop or false
    trackIndex = trackIndex or 0
    --- @type Spine_TrackEntry
    local trackEntry = self.anim.AnimationState:SetAnimation(trackIndex, animName, isLoop)
    trackEntry:AddCompleteListenerFromLua(callback)
    self._playingAnimation = animName
end

--- @param isEnable boolean
function ClientHeroAnimation:EnableAnim(isEnable)
    self.anim.enabled = isEnable
end

--- @param trackIndex number
function ClientHeroAnimation:ClearTrack(trackIndex)
    self.anim.AnimationState:ClearTrack(trackIndex)
end

function ClientHeroAnimation:ClearTracks()
    if (self.anim.AnimationState == nil) then
        print(debug.traceback())
    else
        self.anim.AnimationState:ClearTracks()
    end
end

function ClientHeroAnimation:SetToSetupPose()
    self.anim.skeleton:SetToSetupPose()
end

--- @param boneName string
function ClientHeroAnimation:GetBone(boneName)
    return self.anim.skeleton:FindBone(boneName)
end

--- @param skinName string
function ClientHeroAnimation:SetSkin(skinName)
    local skin = self.anim.skeleton.data:FindSkin(skinName)
    if skin ~= nil then
        self.anim.skeleton:SetSkin(skin)
    end
end

--- @param trackIndex number
--- @param trackTime number
function ClientHeroAnimation:SetTrackTime(trackTime, trackIndex)
    trackIndex = trackIndex or self.mainTrackIndex
    local trackEntry = self.anim.AnimationState:GetCurrent(trackIndex)
    if trackEntry ~= nil then
        trackEntry.trackTime = trackTime
        trackEntry.AnimationLast = trackEntry.trackTime
    end
end

--- @return number, number
function ClientHeroAnimation:GetHeroVisualLayer()
    return self.meshRenderer.sortingLayerID, self.meshRenderer.sortingOrder
end

--- @param heightY number
--- @param offset number
function ClientHeroAnimation:UpdateLayer(heightY, offset)
    offset = offset or 0
    self.meshRenderer.sortingOrder = ClientConfigUtils.CalculateBattleLayer(heightY, offset)

    self.clientHero:UpdateIdleEffectLayer()

    self:ChangeSortingLayerId(self.meshRenderer.sortingLayerID)
end

--- @param layerId number
--- @param sortingOrder number
function ClientHeroAnimation:FixedLayer(layerId, sortingOrder)
    self.meshRenderer.sortingLayerID = layerId
    self.meshRenderer.sortingOrder = sortingOrder
end

--- @param sortingLayerId number
function ClientHeroAnimation:ChangeSortingLayerId(sortingLayerId)
    self.meshRenderer.sortingLayerID = sortingLayerId

    for i = 1, self._layerEventListener:Count() do
        self._layerEventListener:Get(i):Trigger({["sortingLayerId"] = sortingLayerId})
    end
end

--- @param teamId number
function ClientHeroAnimation:SetFlipByTeamId(teamId)
    local angles = U_Vector3.zero
    if teamId == BattleConstants.DEFENDER_TEAM_ID then
        angles = U_Vector3(0, 180, 0)
    end
    self.meshRenderer.transform.localEulerAngles = angles
end

--- @param isEnable boolean
function ClientHeroAnimation:EnableVisual(isEnable)
    self.meshRenderer.gameObject:SetActive(isEnable)
end

--- @param shaderName string
function ClientHeroAnimation:ChangeShaderByName(shaderName)
    if self.meshRenderer.material.shader.name ~= shaderName then
        self.meshRenderer.material.shader = ClientConfigUtils.GetShaderByName(shaderName)
        self.meshRenderer:GetPropertyBlock(self._propBlock)
    end
end

--- @param fromAlpha number
--- @param toAlpha number
--- @param duration
--- @param onComplete function
function ClientHeroAnimation:DoFade(fromAlpha, toAlpha, duration, onComplete)
    Coroutine.start(function()
        local skeleton = self.anim.skeleton
        skeleton.a = fromAlpha
        local elapse = 0
        local numberOfFrame = 30
        local deltaAlpha = (toAlpha - fromAlpha) / numberOfFrame
        local waitTime = duration / numberOfFrame
        while (elapse < duration) do
            elapse = elapse + waitTime
            if skeleton.a + deltaAlpha > 1 then
                skeleton.a = 1
            else
                skeleton.a = skeleton.a + deltaAlpha
            end
            coroutine.waitforseconds(waitTime)
        end
        if onComplete ~= nil then
            onComplete()
        end
    end)
end

--- @param fieldId number
--- @param texture UnityEngine_Texture
function ClientHeroAnimation:SetShaderTextureFieldById(fieldId, texture)
    self._propBlock:SetTexture(fieldId, texture)
    self.meshRenderer:SetPropertyBlock(self._propBlock)
end

function ClientHeroAnimation:DoFillMixTexture(fieldId, fromAmount, toAmount, duration)
    self:KillTweenerMixText()

    local frameCount = duration * ClientConfigUtils.FPS
    local frameLength = duration / frameCount
    local deltaFill = (toAmount - fromAmount) / frameCount
    local fillValue = fromAmount

    self._tweenerMixText = Coroutine.start(function()
        self:SetShaderFieldFloatById(fieldId, fillValue)
        while duration > 0 do
            coroutine.waitforseconds(frameLength)
            fillValue = fillValue + deltaFill
            self:SetShaderFieldFloatById(fieldId, fillValue)
            duration = duration - frameLength
        end
    end)
end

function ClientHeroAnimation:KillTweenerMixText()
    if self._tweenerMixText ~= nil then
        Coroutine.stop(self._tweenerMixText)
        self._tweenerMixText = nil
    end
end

--- @param fieldId number
--- @param fillAmount number
function ClientHeroAnimation:SetShaderFieldFloatById(fieldId, fillAmount)
    self._propBlock:SetFloat(fieldId, fillAmount)
    self.meshRenderer:SetPropertyBlock(self._propBlock)
end

--- @param fieldId number
--- @param color UnityEngine_Color
function ClientHeroAnimation:SetShaderFieldColorById(fieldId, color)
    self._propBlock:SetColor(fieldId, color)
    self.meshRenderer:SetPropertyBlock(self._propBlock)
end

--- @param fieldId number
--- @param startColor UnityEngine_Color
--- @param endColor UnityEngine_Color
--- @param time number
function ClientHeroAnimation:TweenShaderColorById(fieldId, startColor, endColor, time)
    self.meshRenderer:GetPropertyBlock(self._propBlock)
    local deltaColor = endColor - startColor
    local color = startColor
    Coroutine.start(function ()
        local elapse = 0
        while elapse < time do
            coroutine.yield(nil)
            elapse = elapse + U_Time.deltaTime
            color = deltaColor * (elapse / time)
            self:SetShaderFieldColorById(fieldId, color)
        end
        self:SetShaderFieldColorById(fieldId, endColor)
    end)
end

--- @param clientHeroLayerChangeEvent ClientHeroLayerChangeEvent
function ClientHeroAnimation:AddLayerChangedListener(clientHeroLayerChangeEvent)
    self._layerEventListener:Add(clientHeroLayerChangeEvent)
end

--- @param clientHeroLayerChangeEvent ClientHeroLayerChangeEvent
function ClientHeroAnimation:RemoveLayerChangedListener(clientHeroLayerChangeEvent)
    self._layerEventListener:RemoveByReference(clientHeroLayerChangeEvent)
end

--- @param fieldId number
--- @param fromAmount number
--- @param toAmount number
--- @param duration number
function ClientHeroAnimation:DoFadeShaderFloatById(fieldId, fromAmount, toAmount, duration)
    local frameCount = duration * ClientConfigUtils.FPS
    local frameLength = duration / frameCount
    local deltaFill = (toAmount - fromAmount) / frameCount
    local fillValue = fromAmount

    self._tweenerShaderFloat = Coroutine.start(function()
        self:SetShaderFieldFloatById(fieldId, fillValue)
        while duration > 0 do
            coroutine.waitforseconds(frameLength)
            fillValue = fillValue + deltaFill
            self:SetShaderFieldFloatById(fieldId, fillValue)
            duration = duration - frameLength
        end
    end)
end

function ClientHeroAnimation:KillTweenerShaderFloat()
    if self._tweenerShaderFloat ~= nil then
        Coroutine.stop(self._tweenerShaderFloat)
        self._tweenerShaderFloat = nil
    end
end