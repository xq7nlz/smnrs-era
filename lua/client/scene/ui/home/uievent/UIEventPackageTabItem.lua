--- @class UIEventPackageTabItem : MotionIconView
UIEventPackageTabItem = Class(UIEventPackageTabItem, MotionIconView)

function UIEventPackageTabItem:Ctor()
    MotionIconView.Ctor(self)
end

function UIEventPackageTabItem:SetPrefabName()
    self.prefabName = 'event_package_tab'
    self.uiPoolType = UIPoolType.EventPackageTabItem
end

--- @param transform UnityEngine_Transform
function UIEventPackageTabItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventPackageTabItemConfig
    self.config = UIBaseConfig(transform)

    self:InitUpdateTime()
end

function UIEventPackageTabItem:AddOnSelectListener(listener)
    self.config.buttonSelect.onClick:RemoveAllListeners()
    self.config.buttonSelect.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener()
    end)
end

---@param eventName string
function UIEventPackageTabItem:SetText(eventName)
    self.config.textEventName.text = eventName
end

function UIEventPackageTabItem:SetTextPositionY(positionY)
    ---@type UnityEngine_Vector3
    local post = self.config.textEventName.rectTransform.anchoredPosition
    if positionY then
        post.y = positionY
    else
        post.y = 0
    end
    self.config.textEventName.rectTransform.anchoredPosition = post
end

--- @param sprite UnityEngine_Sprite
function UIEventPackageTabItem:SetIcon(sprite)
    self.config.icon.sprite = sprite
    self.config.icon:SetNativeSize()
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventPackageTabItem:SetEndEventTime(endTime, onEventTimeEnded)
    self.endTime = endTime
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

function UIEventPackageTabItem:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventPackageTabItem:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.config.textEventTime.text = TimeUtils.GetDeltaTime(self.timeRefresh)
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

function UIEventPackageTabItem:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventPackageTabItem:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

--- @param isSelect boolean
function UIEventPackageTabItem:SetSelectState(isSelect)
    self.config.bgOff.gameObject:SetActive(not isSelect)
    self.config.bgOn.gameObject:SetActive(isSelect)
end

function UIEventPackageTabItem:SetPivot(pivot)
    self.config.transform.pivot = pivot
end

function UIEventPackageTabItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:RemoveUpdateTime()
    self.endTime = nil
    self.onEventTimeEnded = nil
    self.notificationFunction = nil
end

function UIEventPackageTabItem:SetNotificationFunction(notificationFunction)
    self.notificationFunction = notificationFunction
    self:UpdateNotification()
end

function UIEventPackageTabItem:UpdateNotification()
    self.config.iconNew:SetActive(self:_IsNotified())
end

function UIEventPackageTabItem:_IsNotified()
    return self.notificationFunction ~= nil and self.notificationFunction()
end

function UIEventPackageTabItem:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
    if not isActive then
        self:RemoveUpdateTime()
    end
end

function UIEventPackageTabItem:SetAsFirstSibling()
    self.config.transform:SetAsFirstSibling()
end

function UIEventPackageTabItem:SetLocalPos(localPos)
    self.config.rectTrans.anchoredPosition3D = localPos
end

function UIEventPackageTabItem:EnableTimer(isEnable)
    self.config.bgTimer:SetActive(isEnable)
end

function UIEventPackageTabItem:EnableNoti(isEnable)
    self.config.iconNew:SetActive(isEnable)
end

return UIEventPackageTabItem