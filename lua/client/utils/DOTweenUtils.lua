--- @type DG_Tweening_LoopType
local U_LoopType = CS.DG.Tweening.LoopType

--- @class DOTweenUtils
DOTweenUtils = {}

--- @return DG_Tweening_Tweener
--- @param transform UnityEngine_Transform
--- @param position UnityEngine_Vector3
--- @param time number
--- @param loops number
--- @param onFinish method
--- @param delay number
--- @param ease DG_Tweening_Ease
--- @param loopType DG_Tweening_LoopType
function DOTweenUtils.DOMove(transform, position, time, ease, onFinish, loops, loopType, delay)
    assert(transform)
    loops = loops or 1
    loopType = loopType or U_LoopType.Yoyo
    delay = delay or 0
    ease  = ease or U_Ease.Linear

    --- @type DG_Tweening_Tweener
    local tweener = transform:DOMove(position, time):SetEase(ease):SetLoops(loops, loopType):OnComplete(function()
        if onFinish then
           onFinish()
        end
    end)
    return tweener
end

--- @return DG_Tweening_Tweener
--- @param transform UnityEngine_Transform
--- @param position UnityEngine_Vector3
--- @param time number
--- @param loops number
--- @param onFinish method
--- @param delay number
--- @param ease DG_Tweening_Ease
--- @param loopType DG_Tweening_LoopType
function DOTweenUtils.DOLocalMove(transform, position, time, ease, onFinish, loops, loopType, delay)
    assert(transform)
    loops = loops or 1
    loopType = loopType or U_LoopType.Yoyo
    delay = delay or 0
    ease  = ease or U_Ease.Linear

    --- @type DG_Tweening_Tweener
    local tweener = transform:DOLocalMove(position, time):SetEase(ease):SetLoops(loops, loopType):SetDelay(delay):OnComplete(function()
        if onFinish then
            onFinish()
        end
    end)
    return tweener
end

--- @return DG_Tweening_Tweener
--- @param transform UnityEngine_Transform
--- @param posX number
--- @param time number
--- @param loops number
--- @param onFinish method
--- @param delay number
--- @param ease DG_Tweening_Ease
--- @param loopType DG_Tweening_LoopType
function DOTweenUtils.DOLocalMoveX(transform, posX, time, ease, onFinish, loops, loopType, delay)
    assert(transform)
    loops = loops or 1
    loopType = loopType or U_LoopType.Yoyo
    delay = delay or 0
    ease  = ease or U_Ease.Linear

    --- @type DG_Tweening_Tweener
    local tweener = transform:DOLocalMoveX(posX, time):SetEase(ease):SetLoops(loops, loopType):SetDelay(delay):OnComplete(function()
        if onFinish then
            onFinish()
        end
    end)
    return tweener
end

--- @return DG_Tweening_Tweener
--- @param transform UnityEngine_Transform
--- @param posX number
--- @param time number
--- @param loops number
--- @param onFinish method
--- @param delay number
--- @param ease DG_Tweening_Ease
--- @param loopType DG_Tweening_LoopType
function DOTweenUtils.DOLocalMoveY(transform, posY, time, ease, onFinish, loops, loopType, delay)
    assert(transform)
    loops = loops or 1
    loopType = loopType or U_LoopType.Yoyo
    delay = delay or 0
    ease  = ease or U_Ease.Linear

    --- @type DG_Tweening_Tweener
    local tweener = transform:DOLocalMoveY(posY, time):SetEase(ease):SetLoops(loops, loopType):SetDelay(delay):OnComplete(function()
        if onFinish then
            onFinish()
        end
    end)
    return tweener
end

--- @return DG_Tweening_Tweener
--- @param transform UnityEngine_RectTransform
--- @param posY number
--- @param time number
--- @param loops number
--- @param onFinish method
--- @param delay number
--- @param ease DG_Tweening_Ease
--- @param loopType DG_Tweening_LoopType
function DOTweenUtils.DoAnchorPosY(rectTransform, posY, time, ease, onFinish, loops, loopType, delay)
    assert(rectTransform)
    loops = loops or 1
    loopType = loopType or U_LoopType.Yoyo
    delay = delay or 0
    ease  = ease or U_Ease.Linear

    --- @type DG_Tweening_Tweener
    local tweener = rectTransform:DOAnchorPosY(posY, time):SetEase(ease):SetLoops(loops, loopType):SetDelay(delay):OnComplete(function()
        if onFinish then
            onFinish()
        end
    end)
    return tweener
end

--- @return DG_Tweening_Tweener
--- @param transform UnityEngine_Transform
--- @param scale UnityEngine_Vector3
--- @param time number
--- @param loops number
--- @param onFinish function
--- @param delay number
--- @param ease DG_Tweening_Ease
--- @param loopType DG_Tweening_LoopType
function DOTweenUtils.DOScale(transform, scale, time, ease, onFinish, loops, loopType, delay)
    assert(transform)
    ease  = ease or U_Ease.Linear
    loops = loops or 1
    loopType = loopType or U_LoopType.Yoyo
    delay = delay or 0

    --- @type DG_Tweening_Tweener
    local tweener = transform:DOScale(scale, time):SetEase(ease):SetLoops(loops, loopType):SetDelay(delay):OnComplete(function()
        if onFinish then
            onFinish()
        end
    end):SetUpdate(true) -- ignore timescale
    return tweener
end

--- @return DG_Tweening_Tweener
--- @param rectTransform UnityEngine_RectTransform
--- @param endValue UnityEngine_Vector2
--- @param duration number
--- @param onFinish function
function DOTweenUtils.DOSizeDelta(rectTransform, endValue, duration, onFinish)
    assert(rectTransform)
    --- @type DG_Tweening_Tweener
    local tweener = rectTransform:DOSizeDelta(endValue, duration):OnComplete(function()
        if onFinish then
            onFinish()
        end
    end)
    return tweener
end

--- @return DG_Tweening_Tweener
--- @param image UnityEngine_UI_Image
--- @param endValue number
--- @param duration number
--- @param onFinish method
function DOTweenUtils.DOFillAmount(image, endValue, duration, onFinish)
    assert(image)
    --- @type DG_Tweening_Tweener
    local tweener = image:DOFillAmount(endValue, duration):OnComplete(function()
        if onFinish then
            onFinish()
        end
    end)
    return tweener
end

--- @return DG_Tweening_Tweener
--- @param fadeAbleObject UnityEngine_CanvasGroup
--- @param endValue number
--- @param duration number
--- @param onFinish function
function DOTweenUtils.DOFade(fadeAbleObject, endValue, duration, onFinish)
    return fadeAbleObject:DOFade(endValue, duration):OnComplete(function()
        if onFinish then
            onFinish()
        end
    end)
end