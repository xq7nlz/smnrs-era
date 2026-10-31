--- @class UIPopupNotificationView : UIBaseView
UIPopupNotificationView = Class(UIPopupNotificationView, UIBaseView)

--- @return void
--- @param model UIPopupNotificationModel
function UIPopupNotificationView:Ctor(model)
    ---@type UIPopupNotificationConfig
    self.config = nil
    ---@type function
    self.closeCallback = nil
    ---@type function
    self.clickBgCallback = nil
    ---@type function
    self.okCallback = nil
    ---@type function
    self.noCallback = nil
    ---@type function
    self.yesCallback = nil
    ---@type {text, callback}
    self.button1 = nil
    ---@type {text, callback}
    self.button2 = nil
    ---@type List
    self.listItemView = List()
    --- @type UnityEngine_RectTransform
    self.popupRect = nil

    UIBaseView.Ctor(self, model, ctrl)
    --- @type boolean
    self.loadFromResources = true
    --- @type UIPopupNotificationModel
    self.model = model
end

--- @return void
function UIPopupNotificationView:OnReadyCreate()
    ---@type UIPopupNotificationConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.background.onClick:AddListener(function()
        if self.clickBgCallback ~= nil then
            self.clickBgCallback()
        end
    end)

    self.config.textNoti.resizeTextMinSize = 28

    self:InitDisconnectLayout()
end

function UIPopupNotificationView:InitDisconnectLayout()
    local result, message = pcall(function ()
        --- @type UnityEngine_RectTransform
        self.popupRect = self.config.transform:Find("popup"):GetComponent(ComponentName.UnityEngine_RectTransform)
        local layoutAnchor = self.config.transform:Find("popup/disconnect_layout")
        if layoutAnchor == nil then
            return
        end

        require "lua.client.scene.ui.home.uiPopupNotification.UIPopupDisconnectLayout"
        self.disconnectLayout = UIPopupDisconnectLayout(self, layoutAnchor)
    end)
    if result == false then
        XDebug.Error(message)
        return
    end
end

--- @param size UnityEngine_Vector2
function UIPopupNotificationView:SetPopupSize(size)
    if self.popupRect == nil then
        return
    end
    if size == nil then
        self.popupRect.sizeDelta = U_Vector2(980, 660)
    else
        self.popupRect.sizeDelta = size
    end
end

--- @return void
function UIPopupNotificationView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    UIBaseView.OnReadyShow(self, result)
    local showClearData = result.showClearData or false
    if showClearData == true and self.disconnectLayout ~= nil then
        self.disconnectLayout:OnShow(result)
    else
        self:SetUpDefaultLayout()

        self:Init(result)
    end
end

--- @return void
function UIPopupNotificationView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
    self:SetAlpha()
end

function UIPopupNotificationView:SetAlpha()
    if self._canvasGroup ~= nil then
        self._canvasGroup.alpha = 1
    end
end

function UIPopupNotificationView:ReturnPoolListItem()
    ---@param v RootIconView
    for i, v in ipairs(self.listItemView:GetItems()) do
        v:ReturnPool()
    end
    self.listItemView:Clear()
end

--- @return void
function UIPopupNotificationView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListenerTutorial()
    self.clickBgCallback = nil
    self:ReturnPoolListItem()
end

--- @return void
function UIPopupNotificationView:Init(result)
    self:ReturnPoolListItem()
    local showDeleteDataBtn = result.buttonDeleteData ~= nil
    if (self.config.btnDeleteData ~= nil) then
        self.config.btnDeleteData.gameObject:SetActive(showDeleteDataBtn)
        if (showDeleteDataBtn) then
            self:SetDataButton(self.config.btnDeleteData, self.config.textDeleteData, result.buttonDeleteData)
        end
    end

    self.clickBgCallback = result.clickBgCallback
    if result ~= nil and result.clickBgCallback ~= nil then
        result.tapToClose = true
    else
        result.tapToClose = false
    end
    self.button1 = result.button1
    self.button2 = result.button2

    if result.title == nil then
        self.config.textTitle.text = LanguageUtils.LocalizeCommon("notification")
    else
        self.config.textTitle.text = result.title
    end

    if result.notification == nil then
        self.config.textNoti.text = "empty"
    else
        self.config.textNoti.text = result.notification
    end

    if result.alignment == nil then
        self.config.textNoti.alignment = U_TextAnchor.UpperLeft
    else
        self.config.textNoti.alignment = result.alignment
    end

    if self.button1 ~= nil or self.button2 ~= nil then
        self.config.buttonParent:SetActive(true)
        self:SetDataButton(self.config.button1, self.config.textButton1, self.button1)
        self:SetDataButton(self.config.button2, self.config.textButton2, self.button2)
    else
        self.config.buttonParent:SetActive(false)
    end

    if self.config.item ~= nil then
        if result.listItem ~= nil and result.listItem:Count() > 0 then
            self.config.item.gameObject:SetActive(true)
            for _, v in ipairs(result.listItem:GetItems()) do
                ---@type RootIconView
                local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
                item:SetIconData(v)
                item:RegisterShowInfo()
                if result.disableButtonItem ~= nil then
                    item.iconView.config.button.interactable = false
                end
                self.listItemView:Add(item)
            end
        else
            self.config.item.gameObject:SetActive(false)
        end
    end

    if result.SetActiveNoButton ~= nil then
        self.config.button1.gameObject:SetActive(result.disableNoButton)
    end
end

--- @return void
---@param button UnityEngine_UI_Button
---@param text TMPro_TextMeshProUGUI
---@param data {callback, text}
function UIPopupNotificationView:SetDataButton(button, text, data)
    if data ~= nil then
        text.text = data.text
        button.gameObject:SetActive(true)
        button.onClick:RemoveAllListeners()
        button.onClick:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            if data.callback ~= nil then
                data.callback()
            end
        end)
    else
        button.gameObject:SetActive(false)
    end
end

--- @return void
function UIPopupNotificationView:ClosePopup()
    PopupMgr.HidePopup(self.model.uiName)
end

--- @return void
function UIPopupNotificationView:OnReadyHide()
    if self.closeCallback ~= nil then
        self:ClosePopup()
        self.closeCallback()
    end
    UIBaseView.OnReadyHide(self)
end

---@param tutorial UITutorialView
---@param step number
function UIPopupNotificationView:ShowTutorial(tutorial, step)
    if step == TutorialStep.CLICK_NOTIFICATION_OPTION_1 then
        tutorial:ViewFocusCurrentTutorial(self.config.button1, U_Vector2(400, 150), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_NOTIFICATION_OPTION_2 then
        tutorial:ViewFocusCurrentTutorial(self.config.button2, U_Vector2(400, 150), nil, nil, TutorialHandType.CLICK)
    end
end

function UIPopupNotificationView:SetUpDefaultLayout()
    self:SetPopupSize()

    self.config.buttonParent:SetActive(true)

    if self.disconnectLayout ~= nil then
        self.disconnectLayout:OnHide()
    end
end