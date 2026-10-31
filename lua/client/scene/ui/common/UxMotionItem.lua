--- @class UxMotionItem
UxMotionItem = Class(UxMotionItem)

--- @param transform UnityEngine_RectTransform
function UxMotionItem:Ctor(transform)
    --- @type CS_AnimationCallback
    self.animationCallback = nil
    --- @type DG_Tweening_Tweener
    self.tweener = nil
    self:InitConfig(transform)
end

--- @param transform UnityEngine_RectTransform
function UxMotionItem:InitConfig(transform)
    local visual = transform:Find("visual")
    --- @type UnityEngine_RectTransform
    self.transform = transform
    if visual ~= nil then
        self.visual = visual
        --- @type UnityEngine_CanvasGroup
        self.canvasGroup = visual:GetComponent(ComponentName.UnityEngine_CanvasGroup)
    end

    --- @type UnityEngine_Animation
    self.anim = transform:GetComponent(ComponentName.UnityEngine_Animation)
    if self.anim ~= nil then
        ---@type CS_AnimationCallback
        self.animationCallback = transform.gameObject:AddComponent(ComponentName.AnimationCallback)
        self.animationCallback.callbackFinishAnimation = function()
            self:OnFinishAnimation()
        end
    end
end

function UxMotionItem:PlayMotion()
    if self.anim ~= nil then
        self.anim:Play()
    end
    self:DoFade()
end

function UxMotionItem:DefaultShow()
    ClientConfigUtils.KillTweener(self.tweener)
    if self.visual ~= nil then
        self.visual.anchoredPosition = U_Vector2.zero
        self.visual.localScale = U_Vector3.one
    end
    self:SetAlpha(1)
end

--- @param alpha number
function UxMotionItem:SetAlpha(alpha)
    if Main.IsNull(self.canvasGroup) then
        return
    end
    self.canvasGroup.alpha = alpha
end

function UxMotionItem:DoFade()
    if Main.IsNull(self.canvasGroup) == false then
        self:SetAlpha(0)
        ClientConfigUtils.KillTweener(self.tweener)
        self.tweener = DOTweenUtils.DOFade(self.canvasGroup, 1, 0.3)
    end
end

function UxMotionItem:OnFinishAnimation()

end

--- @class MotionConfig
MotionConfig = Class(MotionConfig)

--- @param delay number
--- @param onStart function
--- @param onFinish function
--- @param deltaTime number
function MotionConfig:Ctor(delay, onStart, onFinish, deltaTime, offsetSpawn)
    self.delay = delay or 0
    self.onStart = onStart
    self.onFinish = onFinish
    self.deltaTime = deltaTime or 0.03
    self.offsetSpawn = offsetSpawn or 1
end