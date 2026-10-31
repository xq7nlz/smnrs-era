local ON_TEXT_COLOR = U_Color(0.29, 0.24, 0.19, 1)
--- @class UIEventIdleEffectBundleView : UIBaseView
UIEventIdleEffectBundleView = Class(UIEventIdleEffectBundleView, UIBaseView)

--- @param model UIEventIdleEffectBundleModel
function UIEventIdleEffectBundleView:Ctor(model)
    --- @type UIEventIdleEffectBundleConfig
    self.config = nil
    --- @type function
    self.updateTime = nil
    --- @type EventSkinBundleModel
    self.eventModel = nil
    --- @type List
    self.listBundleItem =  List()
    UIBaseView.Ctor(self, model)
    --- @type UIEventIdleEffectBundleModel
    self.model = model
end

function UIEventIdleEffectBundleView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtons()
    self:InitLayout()
    self:InitUpdateTime()
end

function UIEventIdleEffectBundleView:InitLayout()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_IDLE_EFFECT_BUNDLE)
    local bigBundle = IdleEffectBundleItemView(self.config.bigBundle.transform)
    local customBundle1 = IdleEffectBundleItemView(self.config.customBundle1.transform)
    local customBundle2 = IdleEffectBundleItemView(self.config.customBundle2.transform)
    local randomBundle = IdleEffectBundleItemView(self.config.randomBundle.transform)
    self.listBundleItem:Add(bigBundle)
    self.listBundleItem:Add(customBundle1)
    self.listBundleItem:Add(customBundle2)
    self.listBundleItem:Add(randomBundle)
    self:InitItemData()
end
function UIEventIdleEffectBundleView:InitItemData()
    for i = 1, self.listBundleItem:Count() do
        self.listBundleItem:Get(i):SetData(self.eventModel.timeData.dataId,i)
    end
end
function UIEventIdleEffectBundleView:InitButtons()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIEventIdleEffectBundleView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea , nil ,self.model.uiName)
end

function UIEventIdleEffectBundleView:InitLocalization()
    self.config.idleEffectBundleDecs.text = LanguageUtils.LocalizeCommon("bundle_idle_effect")
    if self.listBundleItem ~= nil then
        --- @param v IdleEffectBundleItemView
        for _, v in pairs(self.listBundleItem:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventIdleEffectBundleView:DisableCommon()
end

--- @param data {callbackClose : function}
function UIEventIdleEffectBundleView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    self:InitItemData()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_IDLE_EFFECT_BUNDLE)
    self:StartRefreshTime()
end

function UIEventIdleEffectBundleView:Hide()
    UIBaseView.Hide(self)
    self:RemoveUpdateTime()
end

function UIEventIdleEffectBundleView:InitUpdateTime()
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


function UIEventIdleEffectBundleView:StartRefreshTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventIdleEffectBundleView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventIdleEffectBundleView:SetTimeRefresh()
    self.timeRefresh = self.eventModel.timeData.endTime - zg.timeMgr:GetServerTime()
end

function UIEventIdleEffectBundleView:OnEventEnded()
    self:OnReadyHide()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
end


