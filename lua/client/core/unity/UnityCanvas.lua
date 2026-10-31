--- @class UnityCanvas
UnityCanvas = Class(UnityCanvas)

--- @return void
function UnityCanvas:Ctor()
    --- @type CanvasConfig
    self.config = nil
    --- @type UnityEngine_Camera
    self.camUI = nil
    --- @type UnityEngine_Camera
    self.camIgnoreBlur = nil
    ---@type Vector2
    self.resolution = nil
    --- @type boolean
    self.canTouch = nil
    --- @type ShortNotificationView
    self.shortNotification = nil
    --- @type CanvasSystemMessage
    self.canvasSystemMessage = nil
    --- @type UnityEngine_UI_Image
    self.bgDark = nil
    --- @type UnityEngine_UI_Text
    self.localizeTapToClose = nil

    self:Init()
end

--- @return void
function UnityCanvas:SetResolution()
    local canvasTrans = ResourceLoadUtils.LoadUI("ui_canvas", true)
    ---@type CanvasConfig
    self.config = UIBaseConfig(canvasTrans)
    --self.config.blurCacher.isCacheRender = false

    self.camUI = self.config.canvas.worldCamera
    self.camIgnoreBlur = self.config.canvasIgnoreBlur.worldCamera
    self.config.eventSystem.pixelDragThreshold = 30
    local sizeScreen = U_Screen.width / U_Screen.height
    local canvasScaler = self.config.canvasScaler
    local sizeResolution = canvasScaler.referenceResolution.x / canvasScaler.referenceResolution.y
    if sizeScreen > sizeResolution then
        canvasScaler.matchWidthOrHeight = 1
        self.config.canvasScalerIgnoreBlur.matchWidthOrHeight = 1
        self.camUI.orthographicSize = 5
        self.camIgnoreBlur.orthographicSize = 5
        self.resolution = U_Vector2(canvasScaler.referenceResolution.y * sizeScreen, canvasScaler.referenceResolution.y)
    else
        canvasScaler.matchWidthOrHeight = 0
        self.config.canvasScalerIgnoreBlur.matchWidthOrHeight = 0
        self.camUI.orthographicSize = 5 * sizeResolution / sizeScreen
        self.camIgnoreBlur.orthographicSize = 5 * sizeResolution / sizeScreen
        self.resolution = U_Vector2(canvasScaler.referenceResolution.x, canvasScaler.referenceResolution.x / sizeScreen)
    end
end

function UnityCanvas:SetFingerTap()
    self.config.leanFingerTap:Init(self.camIgnoreBlur, self.config.uiTouch)
    self.config.leanFingerTap.onPosition = function(position)
        if self.canTouch then
            local fxTouch = SmartPool.Instance:SpawnUIEffectPool(EffectPoolType.EffectTouch, self.config.uiTouch)
            if fxTouch ~= nil then
                fxTouch.localPosition = U_Vector3(position.x, position.y, 0)
                fxTouch.gameObject:SetActive(true)
                Coroutine.start(function()
                    coroutine.waitforseconds(0.6)
                    SmartPool.Instance:DespawnUIEffectPool(EffectPoolType.EffectTouch, fxTouch)
                end)
            end
        end
    end
end

--- @return void
--- @param background UnityEngine_UI_Image
function UnityCanvas:SetBackgroundSize(background)
    local screenRect = uiCanvas.config.canvasScaler.referenceResolution
    local spriteRect = background.sprite.rect
    local ratio = screenRect.x / screenRect.y
    local spriteRatio = spriteRect.width / spriteRect.height
    local screen = U_Screen.width / U_Screen.height
    local width, height
    if screen > spriteRatio then
        if screen > ratio then
            width = screenRect.x * screen / ratio
        else
            width = screenRect.x * ratio / screen
        end
        height = width / spriteRatio
    else
        if screen > ratio then
            height = screenRect.y * screen / ratio
        else
            height = screenRect.y * ratio / screen
        end
        width = height * spriteRatio
    end
    background.rectTransform.sizeDelta = U_Vector2(width, height)
end

--- @return Vector2
function UnityCanvas:GetResolution()
    if self.resolution == nil then
        self:SetResolution()
    end
    return self.resolution
end

--- @return void
function UnityCanvas:Init()
    self:SetResolution()
    self:SetFingerTap()
    self.config.transform:SetParent(zgUnity.transform)
end

--- @return UnityEngine_RectTransform
--- @param model UIBaseModel
function UnityCanvas:GetUiPopup(model)
    if model.uiName == UIPopupName.UITutorial then
        return self.config.uiTutorial
    elseif model.uiName == UIPopupName.UILoading or model.uiName == UIPopupName.UIPopupWaiting then
        return self.config.uiLoading
    else
        if model.type == UIPopupType.BLUR_POPUP then
            return self.config.uiPopupIgnoreBlur
        else
            return self.config.uiPopup
        end
    end
end

function UnityCanvas:ShowShortNotification(message)
    if self.shortNotification == nil then
        self:_GetShortNotificationViewInfo()
    end
    self.shortNotification:ShowMessage(message)
end

function UnityCanvas:ShowRewardNotification(rewardInBound)
    if self.shortNotification == nil then
        self:_GetShortNotificationViewInfo()
    end
    self.shortNotification:ShowRewardNotification(rewardInBound)
end

function UnityCanvas:_GetShortNotificationViewInfo()
    local rect = PrefabLoadUtils.Instantiate("short_noti_info", self.config.uiSystem)
    require "lua.client.core.unity.ShortNotificationView"
    self.shortNotification = ShortNotificationView(rect)
end

--- @return void
--- @param parent UnityEngine_RectTransform
function UnityCanvas:ShowBgDark(parent)
    if self.bgDark == nil then
        self:InitBgDark(parent)
        self:SetLocalize()
    else
        self.bgDark.transform:SetParent(parent)
    end
    self.bgDark.transform:SetAsFirstSibling()
    if self.bgDark.color.a == 0 then
        require "lua.client.utils.DOTweenUtils"
        DOTweenUtils.DOFade(self.bgDark, 0.7, 0.3)
    end
end

--- @return void
function UnityCanvas:ShowTapToClose(active)
    self.localizeTapToClose.gameObject:SetActive(active)
end

--- @return void
function UnityCanvas:HideBgDark()
    if self.bgDark then
        self.bgDark.color = U_Color(0, 0, 0, 0)
    end
end

--- @return void
function UnityCanvas:InitBgDark(parent)
    local obj = PrefabLoadUtils.Instantiate("bg_dark", parent)
    self.bgDark = obj:GetComponent(ComponentName.UnityEngine_UI_Image)
    self.localizeTapToClose = obj.transform:Find("text_tap_to_close"):GetComponent(ComponentName.UnityEngine_UI_Text)
end

function UnityCanvas:SetLocalize()
    if self.localizeTapToClose == nil then
        self:InitBgDark()
    end

    local font = FontUtils.GetFontByLanguage(PlayerSettingData.language)
    if font ~= nil then
        self.localizeTapToClose.font = font
    end
    self.localizeTapToClose.text = LanguageUtils.LocalizeCommon("tap_to_close")
end

function UnityCanvas:SetSystemMessage()
    if self.canvasSystemMessage == nil then
        local rect = PrefabLoadUtils.Instantiate("system_message", self.config.uiSystem)
        require "lua.client.core.unity.CanvasSystemMessage"
        self.canvasSystemMessage = CanvasSystemMessage(rect)
    end
end

function UnityCanvas:ShowOnlineOverTime()
    self:SetSystemMessage()
    self.canvasSystemMessage:ShowOnlineOverTimeMessage()
end

--- @param message MessageInBound
function UnityCanvas:ShowMaintenanceMessage(message)
    self:SetSystemMessage()
    self.canvasSystemMessage:ShowMaintenanceMessage(message)
end