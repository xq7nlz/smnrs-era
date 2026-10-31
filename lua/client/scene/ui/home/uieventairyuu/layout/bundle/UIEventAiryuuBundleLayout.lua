--- @class UIEventAiryuuBundleLayout : UIEventAiryuuLayout
UIEventAiryuuBundleLayout = Class(UIEventAiryuuBundleLayout, UIEventAiryuuLayout)

--- @param view UIEventAiryuuView
--- @param anchor UnityEngine_RectTransform
function UIEventAiryuuBundleLayout:Ctor(view, tab, anchor)
    ---@type UIEventAiryuuBundleLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listPack = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_AIRYUU
    --- @type PackViewType
    self.packViewType = PackViewType.EVENT_AIRYUU_BUNDLE
    UIEventAiryuuLayout.Ctor(self, view, tab, anchor)
end

function UIEventAiryuuBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_airyuu_bundle_layout", self.anchor)
    UIEventAiryuuLayout.InitLayoutConfig(self, inst)
    self:InitScrolls()
    self:InitLocalization()
    self:InitButtonListener()
end

function UIEventAiryuuBundleLayout:InitLocalization()
    UIEventAiryuuLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("airyuu_bundle")
    self.layoutConfig.textTitleDetail.text = LanguageUtils.LocalizeCommon("airyuu_bundle_infor")
end

function UIEventAiryuuBundleLayout:InitPack()
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetEventAiryuuBundleStore():GetCurrentPack()
    self.listPack = List()
    --- @param id number
    --- @param v ProductConfig
    for _, v in pairs(self.packOfProducts.packDict:GetItems()) do
        self.listPack:Add(v)
    end
end

function UIEventAiryuuBundleLayout:InitScrolls()
    --- @param obj IapTilePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type ProductConfig
        local productConfig = self.listPack:Get(dataIndex)
        obj:SetViewIconData(PackViewType.EVENT_AIRYUU_BUNDLE, productConfig, function()
            self:OnPurchaseSuccess(productConfig.id)
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.IapTilePackItem, onCreateItem)
end

function UIEventAiryuuBundleLayout:OnPurchaseSuccess(id)
    self.uiScroll:Resize(self.listPack:Count())
end

function UIEventAiryuuBundleLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
end

function UIEventAiryuuBundleLayout:OnShow()
    UIEventAiryuuLayout.OnShow(self)
    self:InitPack()
    self.uiScroll:Resize(self.listPack:Count())
    self.anchor.gameObject:SetActive(true)
end

function UIEventAiryuuBundleLayout:SetUpLayout()
    UIEventAiryuuLayout.SetUpLayout(self)
end

function UIEventAiryuuBundleLayout:OnHide()
    UIEventAiryuuLayout.OnHide(self)
    self.uiScroll:Hide()
end

--- @param onEventTimeEnded function
function UIEventAiryuuBundleLayout:SetNextDayTime(onEventTimeEnded)
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventAiryuuBundleLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventAiryuuBundleLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventAiryuuBundleLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventAiryuuBundleLayout:SetTimeRefresh()
    --self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventAiryuuBundleLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("time_next_day"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

