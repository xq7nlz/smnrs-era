require "lua.client.battleShow.ClientHero.ClientHeroAnimation"
--- @class Client40027HeroAnimation :ClientHeroAnimation
Client40027HeroAnimation = Class(Client40027HeroAnimation, ClientHeroAnimation)

--- @param clientHero ClientHero
--- @param mainTrackIndex number
function Client40027HeroAnimation:Ctor(clientHero, mainTrackIndex, dragonForm)
    --- @type Dictionary
    self.modelDict = Dictionary()
    ClientHeroAnimation.Ctor(self, clientHero, mainTrackIndex)
    self:InitDragonModel(dragonForm)
end

function Client40027HeroAnimation:Init(gameObject)
    local data = {}
    data.anim = gameObject:GetComponentInChildren(ComponentName.Spine_Unity_SkeletonAnimation)
    data.meshRenderer = data.anim:GetComponent(ComponentName.UnityEngine_MeshRenderer)
    data.meshRenderer:GetPropertyBlock(self._propBlock)
    self.anim = data.anim
    self.meshRenderer = data.meshRenderer
    self.modelDict:Add(AiryuuForm.Human, data)
end

function Client40027HeroAnimation:InitDragonModel(gameObject)
    local data = {}
    data.anim = gameObject:GetComponentInChildren(ComponentName.Spine_Unity_SkeletonAnimation)
    data.meshRenderer = data.anim:GetComponent(ComponentName.UnityEngine_MeshRenderer)
    data.meshRenderer:GetPropertyBlock(self._propBlock)
    self.modelDict:Add(AiryuuForm.Dragon, data)
end

--- @param form AiryuuForm
--- @param animLength number
--- @param delay number
--- @param animName string
--- @param isLoop boolean
function Client40027HeroAnimation:SwitchModel(form, animLength, delay, animName, isLoop)
    ClientConfigUtils.KillCoroutine(self.actionCoroutine)
    self.actionCoroutine = Coroutine.start(function()
        local tempAnim = self.anim
        local tempRenderer = self.meshRenderer
        --self.anim.AnimationState:SetAnimation(self.clientHero.mainTrackIndex, AnimationConstants.IDLE_ANIM, true)
        local data = self.modelDict:Get(form)
        self.anim = data.anim
        self.meshRenderer = data.meshRenderer

        local prepareAnim = AnimationConstants.IDLE_ANIM
        if form == AiryuuForm.Dragon then
            local pos = PositionConfig.GetBattleCentralPosition()
            self.clientHero.clientHeroMovement.transform.position = pos
            prepareAnim = AnimationConstants.PRE_TRANSFORM
        end

        self:SetFlipByTeamId(self.clientHero.baseHero.teamId)

        self:PlayAnimation(animName, isLoop, self.mainTrackIndex)

        self.meshRenderer.enabled = true

        coroutine.waitforseconds(delay * AnimationConstants.FRAME_LENGTH)

        tempAnim.AnimationState:SetAnimation(self.mainTrackIndex, prepareAnim, false)
        tempRenderer.enabled = false

        coroutine.waitforseconds((animLength - delay) * AnimationConstants.FRAME_LENGTH)

        self.clientHero.clientHeroMovement:SetPosition(self.clientHero.originPosition)
        if self.clientHero.uiHeroStatusBar ~= nil then
            self.clientHero.uiHeroStatusBar.config.gameObject:SetActive(true)
        end
        if form == AiryuuForm.Human then
            --zg.battleMgr.clientBattleShowController:ResumeBattle(false)
            self:PlayAnimation(AnimationConstants.IDLE_ANIM, true, self.mainTrackIndex)
        end
        self.actionCoroutine = nil
    end)
end

--- @param form AiryuuForm
--- @param delay number
--- @param animName string
function Client40027HeroAnimation:SwitchModelInstant(form)
    self.meshRenderer.enabled = false
    local data = self.modelDict:Get(form)
    self.anim = data.anim
    self.meshRenderer = data.meshRenderer
    self.meshRenderer.enabled = true
end

--- @param animName string
--- @param isLoop boolean
--- @param trackIndex number
function Client40027HeroAnimation:PlayAnimation(animName, isLoop, trackIndex)
    if self.anim.enabled == false then
        return
    end
    trackIndex = trackIndex or self.mainTrackIndex
    self.anim.AnimationState:SetAnimation(trackIndex, animName, isLoop)
    if self.clientHero.mainTrackIndex == trackIndex then
        self._playingAnimation = animName
    end
end

--- @param sortingLayerId number
function Client40027HeroAnimation:ChangeSortingLayerId(sortingLayerId)
    --- @param k AiryuuForm
    --- @param v
    for k, v in pairs(self.modelDict:GetItems()) do
        v.meshRenderer.sortingLayerID = sortingLayerId
    end

    for i = 1, self._layerEventListener:Count() do
        self._layerEventListener:Get(i):Trigger({ ["sortingLayerId"] = sortingLayerId })
    end
end

--- @class AiryuuForm
AiryuuForm = {
    Human = 1,
    Dragon = 2
}