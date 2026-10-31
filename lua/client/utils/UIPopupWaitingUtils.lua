local WAITING_TIME_SHOW = 0.5
--- @type Coroutine
local waitingCoroutine

local function HideWaiting()
    if PopupUtils.IsWaitingShowing() then
        PopupMgr.HidePopup(UIPopupName.UIPopupWaiting)
    end
end

UIPopupWaitingUtils = {}

function UIPopupWaitingUtils.StopWaitingCoroutine()
    if waitingCoroutine ~= nil then
        Coroutine.stop(waitingCoroutine)
        waitingCoroutine = nil
    end
    HideWaiting()
end

function UIPopupWaitingUtils.ShowWaiting()
    waitingCoroutine = Coroutine.start(function()
        coroutine.waitforseconds(WAITING_TIME_SHOW)
        PopupMgr.ShowPopup(UIPopupName.UIPopupWaiting, OpCode.RECONNECT)
    end)
end

function UIPopupWaitingUtils.Disconnect(disconnectReason)
    UIPopupWaitingUtils.StopWaitingCoroutine()
    zg.networkMgr:OnDisconnected(disconnectReason)
end