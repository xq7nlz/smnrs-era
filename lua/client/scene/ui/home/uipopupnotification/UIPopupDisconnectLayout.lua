--- @class UIPopupDisconnectLayout
UIPopupDisconnectLayout = Class(UIPopupDisconnectLayout)

--- @param view UIPopupNotificationView
--- @param anchor UnityEngine_RectTransform
function UIPopupDisconnectLayout:Ctor(view, anchor)
    --- @type UIPopupNotificationView
    self.view = view
    --- @type UIPopupNotificationConfig
    self.config = view.config
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    self.anchor.gameObject:SetActive(false)

    --- @type UIPopupDisconnectLayoutConfig
    self.layoutConfig = UIBaseConfig(anchor)
end

function UIPopupDisconnectLayout:OnShow(result)
    self:SetUpLayout()

    self:Init(result)
end

--- @param result {buttonDeleteData, clickBgCallback, button1, button2, title}
function UIPopupDisconnectLayout:Init(result)
    local showDeleteDataBtn = result.buttonDeleteData ~= nil
    if (self.layoutConfig.btnDeleteData ~= nil) then
        self.layoutConfig.btnDeleteData.gameObject:SetActive(showDeleteDataBtn)
        if (showDeleteDataBtn) then
            self.view:SetDataButton(self.layoutConfig.btnDeleteData, self.layoutConfig.textDeleteData, result.buttonDeleteData)
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
        self.layoutConfig.textNoti.text = "empty"
    else
        self.layoutConfig.textNoti.text = result.notification
    end

    if result.alignment == nil then
        self.layoutConfig.textNoti.alignment = U_TextAnchor.UpperLeft
    else
        self.layoutConfig.textNoti.alignment = result.alignment
    end

    if self.button1 ~= nil or self.button2 ~= nil then
        self.view:SetDataButton(self.layoutConfig.button1, self.layoutConfig.textButton1, self.button1)
        self.view:SetDataButton(self.layoutConfig.button2, self.layoutConfig.textButton2, self.button2)
    end
end

function UIPopupDisconnectLayout:SetUpLayout()
    self.view:SetPopupSize(U_Vector2(1150, 660))
    self.config.buttonParent:SetActive(false)
    self.anchor.gameObject:SetActive(true)

    self.config.item.gameObject:SetActive(false)

    self.config.textNoti.text = ""
end

function UIPopupDisconnectLayout:OnHide()
    self.anchor.gameObject:SetActive(false)
end