require "lua.client.scene.ui.home.uiEventSkinBundle.layout.UIEventSkinBundleLayout"

local ON_TEXT_COLOR = U_Color(0.29, 0.24, 0.19, 1)

--- @class UIEventSkinBundleView : UIBaseView
UIEventSkinBundleView = Class(UIEventSkinBundleView, UIBaseView)

--- @param model UIEventSkinBundleModel
function UIEventSkinBundleView:Ctor(model)
    --- @type UIEventSkinBundleConfig
    self.config = nil
    --- @type Dictionary
    self.tabDict = Dictionary()
    --- @type UIEventSkinBundleLayout
    self.currentLayout = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type function
    self.updateTime = nil
    --- @type EventSkinBundleModel
    self.eventModel = nil
    --- @type UISelect
    self.uiSelectPage = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventSkinBundleModel
    self.model = model
end

function UIEventSkinBundleView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()

    self:InitTabs()

    self:InitUpdateTime()

    self:SetUpButtonPage(UIEventSkinBundleTab.SKINS)
end

function UIEventSkinBundleView:InitTabs()
    self.selectTab = function(uiEventSkinBundleTab)
        self:ShowLayout(uiEventSkinBundleTab)
        --- @param v UITabItem
        for k, v in pairs(self.tabDict:GetItems()) do
            v:SetTabState(k == uiEventSkinBundleTab)
        end
        self.uiSelectPage:Select(UIEventSkinBundleTab.SKINS - uiEventSkinBundleTab + 1)
    end
    local addTab = function(uiEventSkinBundleTab, localizeFunction)
        local uiTabItem = UITabItem(self.config.tab:GetChild(2 - uiEventSkinBundleTab), self.selectTab, localizeFunction, uiEventSkinBundleTab)
        uiTabItem:OverrideColor(ON_TEXT_COLOR)
        self.tabDict:Add(uiEventSkinBundleTab, uiTabItem)
    end
    addTab(UIEventSkinBundleTab.BUNDLE, function()
        return LanguageUtils.LocalizeCommon("skin_bundle_view_43")
    end)
    addTab(UIEventSkinBundleTab.SKINS, function()
        return LanguageUtils.LocalizeCommon("skin_bundle_view_44")
    end)
end

function UIEventSkinBundleView:InitButtons()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIEventSkinBundleView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventSkinBundleView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventSkinBundleLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
    if self.tabDict ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventSkinBundleView:DisableCommon()
    self.config.bundleAnchor1.gameObject:SetActive(false)
    self.config.bundleAnchor2.gameObject:SetActive(false)
end

--- @param data {callbackClose : function}
function UIEventSkinBundleView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)

    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_BUNDLE)

    self.selectTab(UIEventSkinBundleTab.BUNDLE)

    self:StartRefreshTime()
end

--- @param uiEventSkinBundleTab UIEventSkinBundleTab
function UIEventSkinBundleView:ShowLayout(uiEventSkinBundleTab)
    self:HideLayout()
    self:DisableCommon()
    self:GetLayout(uiEventSkinBundleTab)
    self.currentLayout:OnShow()
end

function UIEventSkinBundleView:HideLayout()
    if self.currentLayout ~= nil then
        self.currentLayout:OnHide()
    end
end

--- @param uiEventSkinBundleTab UIEventSkinBundleTab
function UIEventSkinBundleView:GetLayout(uiEventSkinBundleTab)
    self.currentLayout = self.layoutDict:Get(uiEventSkinBundleTab)
    if self.currentLayout == nil then
        if uiEventSkinBundleTab == UIEventSkinBundleTab.BUNDLE then
            require "lua.client.scene.ui.home.uiEventSkinBundle.layout.UIEventSkinBundle1Layout"
            self.currentLayout = UIEventSkinBundle1Layout(self, uiEventSkinBundleTab, self.config.bundleAnchor1)
        elseif uiEventSkinBundleTab == UIEventSkinBundleTab.SKINS then
            require "lua.client.scene.ui.home.uiEventSkinBundle.layout.UIEventSkinBundle2Layout"
            self.currentLayout = UIEventSkinBundle2Layout(self, uiEventSkinBundleTab, self.config.bundleAnchor2)
        end
        self.layoutDict:Add(uiEventSkinBundleTab, self.currentLayout)
    end
end

function UIEventSkinBundleView:Hide()
    self:HideLayout()
    UIBaseView.Hide(self)
    self:RemoveUpdateTime()
end

function UIEventSkinBundleView:InitUpdateTime()
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
            if self.timeRefresh < 0 then
                self:OnEventEnded()
                return
            end
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self.timeRefresh < 0 then
            self:RemoveUpdateTime()

            self:OnEventEnded()
        end
        self.config.textTimer.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
    end
end

--- @param pageCount number
function UIEventSkinBundleView:SetUpButtonPage(pageCount)
    if self.uiSelectPage == nil then
        --- @param obj UIBlackMarketPageConfig
        --- @param isSelect boolean
        local onSelect = function(obj, isSelect)
            UIUtils.SetInteractableButton(obj.button, false)
            obj.imageOn:SetActive(isSelect)
        end

        --- @param indexTab number
        local onChangePage = function(indexTab, lastTab)
            if lastTab ~= nil and self.model.currentPage ~= indexTab then
                self.model.currentPage = indexTab
            end
        end
        self.uiSelectPage = UISelect(self.config.pageMarket, UIBaseConfig, onSelect, onChangePage)
    end
    self.uiSelectPage:SetPagesCount(pageCount)
end

function UIEventSkinBundleView:StartRefreshTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSkinBundleView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSkinBundleView:SetTimeRefresh()
    self.timeRefresh = self.eventModel.timeData.endTime - zg.timeMgr:GetServerTime()
end

function UIEventSkinBundleView:OnEventEnded()
    self:OnReadyHide()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
end


