--- @class UIFlashSalePackageTabItem : MotionIconView
UIFlashSalePackageTabItem = Class(UIFlashSalePackageTabItem, MotionIconView)

function UIFlashSalePackageTabItem:Ctor()
    self.groupId = nil
    MotionIconView.Ctor(self)
end

function UIFlashSalePackageTabItem:SetGroupID(groupID, view)
    self.groupId = groupID
    self.view = view
end
function UIFlashSalePackageTabItem:SetPrefabName()
    self.prefabName = 'flash_sale_package_tab'
    self.uiPoolType = UIPoolType.FlashSalePackageTabItem
end

--- @param transform UnityEngine_Transform
function UIFlashSalePackageTabItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIFlashSalePackageTabItemConfig
    self.config = UIBaseConfig(transform)

    self:InitUpdateTime()
end

function UIFlashSalePackageTabItem:AddOnSelectListener(listener)
    self.config.buttonSelect.onClick:RemoveAllListeners()
    self.config.buttonSelect.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener()
    end)
end

---@param eventName string
function UIFlashSalePackageTabItem:SetText(eventName)
    self.config.textEventName.text = eventName
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIFlashSalePackageTabItem:SetEndEventTime(onEventTimeEnded)
    --- @type ProgressPackCollection
    local progressPackCollection = zg.playerData:GetMethod(PlayerDataMethod.IAP).progressPackData
    local createdTime = progressPackCollection.activeProgressPackDict:Get(self.groupId)
    ---@type GroupProductConfig
    local groupProductConfig = self.view:GetGroupProductConfigByID(self.groupId)
    self.endTime = createdTime + groupProductConfig.duration
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

function UIFlashSalePackageTabItem:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIFlashSalePackageTabItem:SetIcon(groupId)
    local spritePath = "Textures/IconTabFlashSale/" .. groupId
    ClientConfigUtils.SetSprite(self.config.icon, spritePath)
    self.config.icon:SetNativeSize()
end

function UIFlashSalePackageTabItem:InitUpdateTime()
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

function UIFlashSalePackageTabItem:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIFlashSalePackageTabItem:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

--- @param isSelect boolean
function UIFlashSalePackageTabItem:SetSelectState(isSelect)
    self.config.bgOff.gameObject:SetActive(not isSelect)
    self.config.bgOn.gameObject:SetActive(isSelect)
end

function UIFlashSalePackageTabItem:SetPivot(pivot)
    -- self.config.transform.pivot = pivot
end

function UIFlashSalePackageTabItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:RemoveUpdateTime()
    self.endTime = nil
    self.onEventTimeEnded = nil
    self.notificationFunction = nil
end

function UIFlashSalePackageTabItem:SetNotificationFunction(notificationFunction)
    self.notificationFunction = notificationFunction
    self:UpdateNotification()
end

function UIFlashSalePackageTabItem:UpdateNotification()
    self.config.iconNew:SetActive(self:_IsNotified())
end

function UIFlashSalePackageTabItem:_IsNotified()
    return self.notificationFunction ~= nil and self.notificationFunction()
end

function UIFlashSalePackageTabItem:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

function UIFlashSalePackageTabItem:SetAsFirstSibling()
    self.config.transform:SetAsFirstSibling()
end

function UIFlashSalePackageTabItem:SetLocalPos(localPos)
    self.config.rectTrans.anchoredPosition3D = localPos
end

function UIFlashSalePackageTabItem:EnableTimer(isEnable)
    self.config.bgTimer:SetActive(isEnable)
end

return UIFlashSalePackageTabItem