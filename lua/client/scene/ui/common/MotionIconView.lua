--- @class MotionIconView : IconView
MotionIconView = Class(MotionIconView, IconView)

--- @param transform UnityEngine_RectTransform
function MotionIconView:Ctor(transform)
    IconView.Ctor(self, transform)
end

--- @param transform UnityEngine_RectTransform
function MotionIconView:SetConfig(transform)
    --- @type UxMotionItem
    self.uxMotion = UxMotionItem(transform)
end

--- @param isEnable boolean
function MotionIconView:PlayMotion(isEnable)
    if isEnable then
        self.uxMotion:PlayMotion()
    else
        self.uxMotion:DefaultShow()
    end
end

--- @param alpha number
function MotionIconView:SetAlpha(alpha)
    self.uxMotion:SetAlpha(alpha)
end

--- @return UnityEngine_RectTransform
--- @param poolType UIPoolType
--- @param isActive boolean
--- @param callbackActive function
--- @param parent UnityEngine_RectTransform
function MotionIconView:ActiveUIPool(poolType, isActive, size, callbackActive, parent)
    if parent == nil then
        parent = self.uxMotion.visual
    end
    return IconView.ActiveUIPool(self, poolType, isActive, size, callbackActive, parent)
end

function MotionIconView:DefaultShow()
    self.uxMotion:DefaultShow()
end

return MotionIconView