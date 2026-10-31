--- @class UIEventSubButtonItem : MotionIconView
UIEventSubButtonItem = Class(UIEventSubButtonItem, MotionIconView)

function UIEventSubButtonItem:Ctor(transform)
    MotionIconView.Ctor(self, transform)
end

function UIEventSubButtonItem:SetPrefabName()
    self.prefabName = 'sub_event_button'
    self.uiPoolType = UIPoolType.EventSubButtonItem
end

--- @param transform UnityEngine_Transform
function UIEventSubButtonItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventSubButtonItemConfig
    self.config = UIBaseConfig(transform)
end


function UIEventSubButtonItem:AddOnSelectListener(listener)
    self.config.eventButton.onClick:RemoveAllListeners()
    self.config.eventButton.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener()
    end)
end

---@param eventName string
function UIEventSubButtonItem:SetText(eventName)
    self.config.textEventButton.text = eventName
end

--- @param sprite UnityEngine_Sprite
function UIEventSubButtonItem:SetIcon(sprite)
    self.config.iconImage.sprite = sprite
    self.config.iconImage:SetNativeSize()
end

--- @param isSelect boolean
function UIEventSubButtonItem:SetSelectState(isSelect)
    self.config.bgOff.gameObject:SetActive(not isSelect)
    self.config.bgOn.gameObject:SetActive(isSelect)
end

function UIEventSubButtonItem:SetPivot(pivot)
    self.config.transform.pivot = pivot
end

function UIEventSubButtonItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    self.endTime = nil
    self.onEventTimeEnded = nil
    self.notificationFunction = nil
end

function UIEventSubButtonItem:SetNotificationFunction(notificationFunction)
    self.notificationFunction = notificationFunction
    self:UpdateNotification()
end

function UIEventSubButtonItem:UpdateNotification()
    self.config.noti:SetActive(self:_IsNotified())
end

function UIEventSubButtonItem:_IsNotified()
    return self.notificationFunction ~= nil and self.notificationFunction()
end

function UIEventSubButtonItem:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

function UIEventSubButtonItem:SetAsFirstSibling()
    self.config.transform:SetAsFirstSibling()
end

function UIEventSubButtonItem:SetLocalPos(localPos)
    self.config.rectTrans.anchoredPosition3D = localPos
end

return UIEventSubButtonItem