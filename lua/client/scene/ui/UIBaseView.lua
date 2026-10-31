--- @class UIBaseView
UIBaseView = Class(UIBaseView)

--- @return void
function UIBaseView:Ctor(model, ctrl)
    --- @type table
    self.config = nil
    --- @type boolean
    self.canCloseByBackButton = true
    --- @type boolean
    self.loadFromResources = false
    --- @type UIBaseModel
    self.model = model
    --- @type UIBaseCtrl
    self.ctrl = ctrl
    ---@type CS_AnimationCallback
    self.animationCallback = nil
    --- @type UnityEngine_Transform
    self.uiTransform = nil
    --- @type function
    self.callbackClose = nil
    ---@type UnityEngine_Canvas
    self._canvas = nil
    --- @type UnityEngine_CanvasGroup
    self._canvasGroup = nil
    --- @type string
    self.language = nil
    --- @type table
    self.result = nil
end

---@type UITutorialView
UIBaseView.tutorial = nil
---@type boolean
UIBaseView.isBlurCache = false

--- @return boolean
function UIBaseView.IsActiveTutorial()
    return UIBaseView.tutorial ~= nil and UIBaseView.tutorial.config.gameObject.activeInHierarchy
end

--- @return void
function UIBaseView:OnCreate()
    if self.uiTransform == nil then
        local onLoaded = function(data)
            self.uiTransform = data
            self.uiTransform.gameObject:SetActive(false)
            self:SetBlur()
            self:CheckCanvasGroup()
            self:OnReadyCreate()
            if Main.IsNull(self.uiTransform.gameObject:GetComponent(ComponentName.UnityEngine_Animation)) == false then
                ---@type CS_AnimationCallback
                self.animationCallback = self.uiTransform.gameObject:AddComponent(ComponentName.AnimationCallback)
                self.animationCallback.callbackFinishAnimation = function()
                    self:OnFinishAnimation()
                end
            end
        end
        PopupUtils.SpawnUI(self.model.prefabName, uiCanvas:GetUiPopup(self.model), onLoaded, self.loadFromResources)
    end
end

function UIBaseView:InitUpdateTimeNextDay(callbackUpdateTimeNextDay)
    assert(callbackUpdateTimeNextDay)
    --- @param isSetTime boolean
    self.updateTimeNextDay = function(isSetTime)
        if isSetTime == true then
            self.timeRefreshNextDay = zg.timeMgr:GetRemainingTime()
        else
            self.timeRefreshNextDay = self.timeRefreshNextDay - 1
        end
        callbackUpdateTimeNextDay(TimeUtils.SecondsToClock(self.timeRefreshNextDay), isSetTime)
    end
end

--- @return void
function UIBaseView:CheckStartTimeRefreshNextDay()
    if self.updateTimeNextDay ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTimeNextDay)
    end
end

function UIBaseView:CheckRemoveUpdateTimeNextDay()
    if self.updateTimeNextDay ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTimeNextDay)
    end
end

--- @return void
function UIBaseView:TriggerLoaded()
    RxMgr.finishLoadPopup:Next(self.model.uiName)
end

--- @return void
function UIBaseView:OnReadyCreate()
end

--- @return void
function UIBaseView:OnChangeOrientation()
    if self.uiTransform ~= nil and self.uiTransform.gameObject.activeInHierarchy
            and self.config ~= nil and self.config.safeArea ~= nil then
        UIUtils.SetSafeArea(self.config.safeArea)
    end
end

--- @return void
function UIBaseView:CheckLoadLocalize()
    if self.language ~= PlayerSettingData.language then
        self.language = PlayerSettingData.language
        FontUtils.SetNewFont(self.config.transform, self.language)
        self:InitLocalization()
    end
end

--- @return void
function UIBaseView:InitLocalization()
    --- override
end

--- @return void
function UIBaseView:InitListenerTutorial()
    self.listenerTutorial = RxMgr.tutorialFocus:Subscribe(RxMgr.CreateFunction(self, self.CheckTutorial))
end

--- @return void
function UIBaseView:RemoveListenerTutorial()
    if self.listenerTutorial ~= nil then
        self.listenerTutorial:Unsubscribe()
        self.listenerTutorial = nil
    end
end

--- @return void
function UIBaseView:CheckTutorial()
    --XDebug.Log('check tut')
    local show = function()
        if UIBaseView.IsActiveTutorial() and UIBaseView.tutorial.isWaitingFocusPosition == true then
            local step = UIBaseView.tutorial.currentTutorial.tutorialStepData.step
            self:ShowTutorial(UIBaseView.tutorial, step)
        end
    end
    if PopupUtils.IsPopupShowing(UIPopupName.UILoading) then
        self.subscriptionLoading = RxMgr.hideLoading:Subscribe(function()
            show()
            if self.subscriptionLoading ~= nil then
                self.subscriptionLoading:Unsubscribe()
            end
        end)
    else
        show()
    end
end

--- @return void
function UIBaseView:CheckAndInitTutorial()
    self:CheckTutorial()
    self:InitListenerTutorial()
end

--- @return void
---@param tutorial number
---@param step number
function UIBaseView:ShowTutorial(tutorial, step)

end

--- @return void
--- @param result table
function UIBaseView:Show(result)
    self:OnCreate()

    if result ~= nil and type(result) == 'table' then
        self.callbackClose = result.callbackClose
    end

    if self._canvas ~= nil then
        self._canvas.sortingOrder = 100 + self.uiTransform:GetSiblingIndex()
    end
    self:CheckLoadLocalize()
    self.uiTransform:SetAsLastSibling()
    self:ResetAlpha()
    self:SetActive(true)
    self:CheckBlur()
    self:OnChangeOrientation()
    self:OnReadyShow(result)
    self:CheckShowBgDark(result)
    self:CheckStartTimeRefreshNextDay()
    self:CheckCallbackAnimation()
    self:TriggerLoaded()

    if self.listenerChangeLanguage == nil then
        self.listenerChangeLanguage = RxMgr.changeLanguage:Subscribe(RxMgr.CreateFunction(self, self.CheckLoadLocalize))
    end
end

function UIBaseView:RefreshView()
    self:CheckShowBgDark()
end

function UIBaseView:CheckShowBgDark(result)
    if self.model.bgDark == true then
        uiCanvas:ShowBgDark(self.config.transform)
        if result ~= nil and type(result) == "table" and result.tapToClose == false then
            uiCanvas:ShowTapToClose(false)
        else
            uiCanvas:ShowTapToClose(true)
        end
    end
end

function UIBaseView:SetActive(isActive)
    self.uiTransform.gameObject:SetActive(isActive)
end

--- @return boolean
function UIBaseView:IsActive()
    return self.uiTransform ~= nil and self.uiTransform.gameObject.activeInHierarchy
end

--- @return void
function UIBaseView:CheckCallbackAnimation()
    if self.animationCallback == nil then
        Coroutine.start(function()
            coroutine.waitforseconds(0.1)
            self:OnFinishAnimation()
        end)
    end
end

local layerUI = 5
local layerIgnoreBlur = 11

--- @return void
function UIBaseView.CheckBlurMain(isHideMain, isBlurMain, callback)
    local show = function()
        if callback ~= nil then
            callback()
        end
        if isHideMain == true then
            PopupMgr.HidePopup(UIPopupName.UIMainArea)
        end
    end

    if isBlurMain == true then
        local blurCacher = uiCanvas.config.blurCacher
        blurCacher.callbackCacheBlur = function()
            blurCacher.rawImage.gameObject:SetActive(false)
            show()
            blurCacher.rawImage.enabled = true
            blurCacher.callbackCacheBlur = nil
        end
        blurCacher.rawImage.enabled = false
        blurCacher.enabled = true
    else
        show()
    end
end

--- @return void
function UIBaseView:CheckBlur()
    local canvasConfig = uiCanvas.config
    if self.model.type == UIPopupType.BLUR_POPUP then
        --if UIBaseView.isBlurCache == false then
        --    canvasConfig.blurCacher.rawImage.enabled = true
        --    canvasConfig.blurCacher.enabled = true
        --    UIBaseView.isBlurCache = true
        --else
        canvasConfig.blurCacher.rawImage.gameObject:SetActive(true)
        --end
    elseif self.model.type == UIPopupType.NORMAL_POPUP then
        if canvasConfig.blurCacher.enabled or uiCanvas.config.blurCacher.rawImage.gameObject.activeSelf then
            PopupUtils.ResetTransform(self.uiTransform, canvasConfig.uiPopupIgnoreBlur)
            self:SetLayer(layerIgnoreBlur)
        else
            if self.uiTransform.parent ~= canvasConfig.uiPopup then
                PopupUtils.ResetTransform(self.uiTransform, canvasConfig.uiPopup)
            end
            self:SetLayer(layerUI)
        end
    end
end

function UIBaseView:SetBlur()
    if self.model.type == UIPopupType.BLUR_POPUP then
        self:SetLayer(layerIgnoreBlur)
    elseif self.model.type == UIPopupType.NO_BLUR_POPUP then
        self:SetLayer(layerUI)
    end
end

--- @return void
function UIBaseView:OnReadyShow(result)
    self:SetCanCloseByBackButton(result)
end

function UIBaseView:SetCanCloseByBackButton(result)
    if result ~= nil and result.canCloseByBackButton ~= nil then
        self.canCloseByBackButton = result.canCloseByBackButton
    else
        self.canCloseByBackButton = true
    end
end

--- @return void
function UIBaseView:OnFinishAnimation()
end

--- @return void
function UIBaseView:OnReadyHide()
    if self.callbackClose ~= nil then
        self.callbackClose()
    else
        PopupMgr.HidePopup(self.model.uiName)
    end
end

function UIBaseView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnReadyHide()
end

--- @return void
function UIBaseView:Hide()
    if self.model.type == UIPopupType.BLUR_POPUP then
        uiCanvas.config.blurCacher.rawImage.gameObject:SetActive(false)
    end
    if self.coroutineDelayTut ~= nil then
        Coroutine.stop(self.coroutineDelayTut)
        self.coroutineDelayTut = nil
    end
    self:SetActive(false)
    self:CheckRemoveUpdateTimeNextDay()
    if self.listenerChangeLanguage ~= nil then
        self.listenerChangeLanguage:Unsubscribe()
    end
end

function UIBaseView:Destroy()
    self:OnDestroy()
    U_Object.Destroy(self.uiTransform.gameObject)
end

--- @return void
function UIBaseView:OnDestroy()

end

--- @return void
function UIBaseView:SetLayer(layer)
    self.uiTransform.gameObject.layer = layer
end

function UIBaseView:CheckCanvasGroup()
    if self._canvasGroup == nil and self.model.type == UIPopupType.NORMAL_POPUP then
        if self.uiTransform ~= nil then
            --- @type UnityEngine_RectTransform
            local popup = self.uiTransform:Find("popup")
            --print("popup" , LogUtils.ToDetail(popup))
            if popup then
                --print("ComponentName.UnityEngine_CanvasGroup ",ComponentName.UnityEngine_CanvasGroup)
                local canvasGroup = popup:GetComponent(ComponentName.UnityEngine_CanvasGroup)
                if Main.IsNull(canvasGroup) == false then
                    self._canvasGroup = canvasGroup
                end
            end
        end
    end
end

function UIBaseView:ResetAlpha()
    if self._canvasGroup ~= nil then
        self._canvasGroup.alpha = 0
    end
end