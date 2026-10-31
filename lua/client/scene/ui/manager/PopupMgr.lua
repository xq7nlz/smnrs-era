require "lua.client.scene.config.UIPopupName"
require "lua.client.scene.config.UIPopupConfig"
require "lua.client.scene.ui.manager.UIPopupInfo"
require "lua.client.utils.FontUtils"
require "lua.client.utils.UIUtils"
require "lua.client.scene.ui.UIBase"
require "lua.client.scene.ui.utils.PopupUtils"
require "lua.client.utils.UIPopupWaitingUtils"
require "lua.client.scene.config.ComponentName"

--- @class PopupMgr
PopupMgr = Class(PopupMgr)

--- @return void
function PopupMgr:Ctor()
    --- @type LRUCache
    self.popupLRUCache = LRUCache(1000)

    --- @type List --<UIPopupInfo>
    self.uiOpenPopupList = List()

    self:_OnBackPress()
    self:_InitOnChangeOrientation()
end

--- @return void
function PopupMgr:_OnBackPress()
    zgUnity.onBackPress = function()
        if UIBaseView.IsActiveTutorial() == false and uiCanvas.config.eventSystem.enabled and not PopupUtils.IsWaitingShowing() then
            --- @type UIPopupInfo
            local popupInfo = self:GetPopupAtTop()
            if popupInfo then
                local view = popupInfo.popup.view
                if view.canCloseByBackButton == true then
                    view:OnClickBackOrClose()
                end
            end
        end
    end
end

--- @return void
function PopupMgr:_InitOnChangeOrientation()
    zgUnity.onChangeOrientation = function()
        ---@param v UIPopupInfo
        for _, v in pairs(self.uiOpenPopupList:GetItems()) do
            v.popup.view:OnChangeOrientation()
        end
    end
end

--- @return UIPopupInfo
--- @param name UIPopupName
function PopupMgr:Spawn(name)
    --- @type UIPopupInfo
    local popupInfo = self.popupLRUCache:GetValue(name)
    if popupInfo == nil then
        popupInfo = UIPopupInfo(name)
        --- @type UIPopupInfo
        local popupRemoved = self.popupLRUCache:Refer(popupInfo)
        if popupRemoved ~= nil then
            if PopupUtils.IsPopupShowing(popupRemoved.name) then
                self.popupLRUCache:Refer(popupRemoved)
            else
                XDebug.Log("Destroy popup: " .. tostring(popupRemoved.name))
                popupRemoved.popup.view:Destroy()
            end

        end
    end
    return popupInfo
end

--- @return void
--- @param name UIPopupName
function PopupMgr:_HidePopup(name)
    if PopupUtils.IsPopupShowing(name) == false then
        XDebug.Log("popup is hiding: " .. name)
    end

    --- @type UIPopupInfo
    local popupInfo = self.popupLRUCache:GetValue(name)
    if popupInfo then
        popupInfo:Hide()
        if self.uiOpenPopupList:IsContainValue(popupInfo) then
            self.uiOpenPopupList:RemoveByReference(popupInfo)
        end
        RxMgr.closePopup:Next({ ["name"] = name })
    else
        XDebug.Log("popup is not exist: " .. name)
    end
end

--- @return void
--- @param hideType UIPopupHideType
--- @param uiName UIPopupName
function PopupMgr:_HidePopupByType(hideType, uiName)
    assert(hideType)
    if hideType == UIPopupHideType.HIDE_ALL then
        for _, popup in pairs(self.uiOpenPopupList:GetItems()) do
            if popup.type ~= UIPopupType.SPECIAL_POPUP then
                self:_HidePopup(popup.name)
            end
        end
    end
end

function PopupMgr:HideAllPopup()
    for _, popup in pairs(self.uiOpenPopupList:GetItems()) do
        self:_HidePopup(popup.name)
    end
    self.uiOpenPopupList:Clear()
end

function PopupMgr:_CheckRefreshUI()
    local count = self.uiOpenPopupList:Count()
    if count > 0 then
        --- @type UIPopupInfo
        local popupInfo = self.uiOpenPopupList:Get(count)
        if popupInfo.popup.model.bgDark == false then
            uiCanvas:HideBgDark()
        end
        if popupInfo then
            popupInfo:RefreshView()
        end
    end
end

--- @return UIPopupInfo
function PopupMgr:GetPopupAtTop()
    local count = self.uiOpenPopupList:Count()
    if count > 0 then
        return self.uiOpenPopupList:Get(count)
    end
    return nil
end

function PopupMgr:OnDestroy()
    self:HideAllPopup()
end

--- @return void
--- @param openPopupName UIPopupName
--- @param data table
function PopupMgr.ShowAndHidePopup(openPopupName, data, ...)
    local args = { ... }
    if #args == 0 then
        XDebug.Error("Please add close popup or use ShowPopup instead")
    end
    for i, v in pairs(args) do
        PopupMgr.HidePopup(v)
    end
    PopupMgr.ShowPopup(openPopupName, data)
end

--- @return void
--- @param name UIPopupName
--- @param hideType UIPopupHideType
function PopupMgr.ShowPopup(name, data, hideType)
    --XDebug.Log("Show popup: " .. name)
--[[    if PopupUtils.IsPopupShowing(name) == true then
        XDebug.Log("popup is showing: " .. name)
    end]]

    if hideType ~= nil then
        zg.popupMgr:_HidePopupByType(hideType, name)
    end

    local popup = zg.popupMgr:Spawn(name)
    popup:Show(data)
    --XDebug.Log("Add popup: " .. name)
    zg.popupMgr.uiOpenPopupList:Add(popup)
end
--- @return void
--- @param name UIPopupName
--- @param hideType UIPopupHideType
--- @param timeDelay number
--- @param callbackDelay function
function PopupMgr.ShowPopupDelay(timeDelay, name, data, hideType, callbackDelay)
    Coroutine.start(function()
        local touchObject = TouchUtils.Spawn("PopupMgr.ShowPopupDelay")
        coroutine.waitforseconds(timeDelay)
        touchObject:Enable()
        PopupMgr.ShowPopup(name, data, hideType)
        if callbackDelay ~= nil then
            callbackDelay()
        end
    end)
end

--- @return void
--- @param name UIPopupName
function PopupMgr.HidePopup(name)
    zg.popupMgr:_HidePopup(name)
    zg.popupMgr:_CheckRefreshUI()
end