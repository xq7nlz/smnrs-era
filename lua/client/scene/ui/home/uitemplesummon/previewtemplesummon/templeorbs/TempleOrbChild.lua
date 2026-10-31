--- @class TempleOrbChild
TempleOrbChild = Class(TempleOrbChild)

--- @param transform UnityEngine_Transform
function TempleOrbChild:Ctor(transform)
    self.transform = transform
    local visual = transform:Find("visual")
    --- @type UnityEngine_MeshRenderer
    self.meshRenderer = visual:GetComponent(ComponentName.UnityEngine_MeshRenderer)
    --- @type Spine_Unity_SkeletonAnimation
    self.skeletonAnimation = visual:GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
    local listFxParticle = visual:GetComponentsInChildren(ComponentName.UnityEngine_ParticleSystemRenderer)
    self.listClientEffect = List()
    for i = 0, listFxParticle.Length - 1 do
        local clientEffect = ClientEffect.CreateByGameObject(listFxParticle[i].gameObject)
        self.listClientEffect:Add(clientEffect)
    end
end

function TempleOrbChild:UpdateFxOrbLayer()
    for i = 1, self.listClientEffect:Count() do
        --- @type ClientEffect
        local clientEffect = self.listClientEffect:Get(i)
        clientEffect:SyncLayerByParams(self.meshRenderer.sortingLayerID, self.meshRenderer.sortingOrder)
    end
end

--- @param nextTransform UnityEngine_Transform
function TempleOrbChild:DoMove(nextTransform, deltaOrbLayer, timeTempleRotate)
    local nextPosition = nextTransform.localPosition
    local nextLocalScale = nextTransform.localScale

    self.meshRenderer.sortingOrder = nextPosition.z * deltaOrbLayer
    self:UpdateFxOrbLayer()

    DOTweenUtils.DOLocalMove(self.transform, nextPosition, timeTempleRotate)
    DOTweenUtils.DOScale(self.transform, nextLocalScale, timeTempleRotate)
end

function TempleOrbChild:DoFade()
    local fromAlpha = 0
    local toAlpha = 1
    local duration = 0.5
    local skeleton = self.skeletonAnimation.skeleton
    if skeleton == nil then
        return
    end
    self:Active()
    Coroutine.start(function()
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
    end)
end

function TempleOrbChild:Active()
    self.skeletonAnimation.AnimationState:SetAnimation(0, "fx", true)
    self.skeletonAnimation.AnimationState:SetAnimation(1, "idle", true)
end