--- @class LunarDicePet
LunarDicePet = Class(LunarDicePet)

--- @param rectTrans UnityEngine_RectTransform
function LunarDicePet:Ctor(rectTrans)
    --- @type UnityEngine_RectTransform
    self.rectTrans = rectTrans
    --- @type UnityEngine_Transform
    self.transform = rectTrans.transform
    self.modelTransform = rectTrans:Find("model")
    self:InitConfig()
    --- @type Coroutine
    self.jumpCoroutine = nil
    --- @type number
    self.duration = 0.6
end

function LunarDicePet:InitConfig()
    --- @type Spine_Unity_SkeletonGraphic
    self.anim = self.transform:Find("model"):GetComponent(ComponentName.Spine_Unity_SkeletonGraphic)
end

--- @param fromPosition UnityEngine_Vector3
--- @param toPosition UnityEngine_Vector3
function LunarDicePet:DoJump(fromPosition, toPosition, onLanded, onComplete)
    --local sign = 1
    --if toPosition.x < fromPosition.x then
    --    sign = -1
    --end
    --local scale = self.modelTransform.localScale
    --scale.x = math.abs(scale.x) * sign
    --self.modelTransform.localScale = scale

    ClientConfigUtils.KillCoroutine(self.jumpCoroutine)
    self.rectTrans.anchoredPosition3D = fromPosition

    self.jumpCoroutine = Coroutine.start(function()
        local listAction = self:CreateFrameAction(toPosition, onLanded)
        local time = 0
        --- @type {time, action : function}
        local action
        local getAction = function()
            action = nil
            if listAction:Count() > 0 then
                action = listAction:Get(1)
            end
        end
        getAction()
        self.anim.AnimationState:SetAnimation(0, "jump", false)
        self.anim.AnimationState:AddAnimation(0, AnimationConstants.IDLE_ANIM, true, 0)

        while time < self.duration do
            time = time + U_Time.deltaTime
            if action ~= nil then
                if time > action.time then
                    action.action()
                    listAction:RemoveByIndex(1)
                    getAction()
                end
            end
            coroutine.yield(nil)
        end
    end)
end

--- @return List
function LunarDicePet:CreateFrameAction(toPosition, onLanded)
    local listFrameAction = List()
    local startJump = {}
    local landed = {}
    startJump.time = 4.0 / ClientConfigUtils.FPS
    landed.time = 14.0 / ClientConfigUtils.FPS
    startJump.action = function()
        self.rectTrans:DOLocalMove(toPosition, landed.time - startJump.time)
    end
    landed.action = onLanded

    listFrameAction:Add(startJump)
    listFrameAction:Add(landed)
    return listFrameAction
end

function LunarDicePet:PlayIdle()
    self.anim.AnimationState:SetAnimation(0, AnimationConstants.IDLE_ANIM, true)
end

function LunarDicePet:SetDirection(sign)
    local scale = self.modelTransform.localScale
    scale.x = math.abs(scale.x) * sign
    self.modelTransform.localScale = scale
end