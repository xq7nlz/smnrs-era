------ @class CanvasSystemMessage
CanvasSystemMessage = Class(CanvasSystemMessage)

--- @param transform UnityEngine_RectTransform
function CanvasSystemMessage:Ctor(transform)
    --- @type CanvasSystemMessageConfig
    self.config = nil
    --- @type DG_Tweening_Tweener
    self.moveTweener = nil
    --- @type Coroutine
    self.messageCouroutine = nil
    self:InitConfig(transform)
end

function CanvasSystemMessage:InitConfig(transform)
    --- @type CanvasSystemMessageConfig
    self.config = UIBaseConfig(transform)
    self.targetSizeDelta = U_Vector2(uiCanvas.resolution.x / 2 + 100, self.config.bgMessage.sizeDelta.y)
    self.config.textMessage.supportRichText = true
end

--- @param content string
function CanvasSystemMessage:ShowMessage(content)
    self:Cancel()
    assert(content)
    self.config.textMessage.text = content
    self.messageCouroutine = Coroutine.start(function()
        self.config.bgMessage.sizeDelta = U_Vector2(self.targetSizeDelta.x, 0)
        self.config.bgMessage.gameObject:SetActive(true)
        coroutine.yield(nil)
        DOTweenUtils.DOSizeDelta(self.config.bgMessage, self.targetSizeDelta, 0.5)
        self.config.textTransform.anchoredPosition = U_Vector2(self.targetSizeDelta.x, 0)
        local targetX = -self.targetSizeDelta.x - self.config.textTransform.sizeDelta.x
        self.moveTweener = DOTweenUtils.DOLocalMoveX(self.config.textTransform, targetX, 15, nil,
                function()
                    DOTweenUtils.DOSizeDelta(self.config.bgMessage, U_Vector2(self.targetSizeDelta.x, 0), 0.5,
                            function()
                                self.config.bgMessage.gameObject:SetActive(false)
                            end)
                end)
        self.moveTweener:SetUpdate(true)
    end)
end

--- @return void
function CanvasSystemMessage:ShowOnlineOverTimeMessage()
    local content = "Chơi quá 180 phút một ngày sẽ ảnh hưởng xấu tới sức khoẻ"
    self:ShowMessage(content)
end

--- @param messageInBound MaintenanceMessageInBound
function CanvasSystemMessage:ShowMaintenanceMessage(messageInBound)
    if messageInBound == nil then
        return
    end
    local content = string.format(LanguageUtils.LocalizeCommon("server_maintain_in_x"),
            UIUtils.SetColorString(UIUtils.color7, TimeUtils.GetDeltaTime(messageInBound.endTime - zg.timeMgr:GetServerTime())))
    self:ShowMessage(content)
end

function CanvasSystemMessage:Cancel()
    self.config.bgMessage.gameObject:SetActive(false)
    ClientConfigUtils.KillTweener(self.moveTweener)
    ClientConfigUtils.KillCoroutine(self.messageCouroutine)
    self.moveTweener = nil
    self.messageCouroutine = nil
end