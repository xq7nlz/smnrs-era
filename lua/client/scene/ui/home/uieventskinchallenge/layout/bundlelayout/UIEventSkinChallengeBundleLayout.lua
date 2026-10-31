require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.UIEventSkinChallengeLayout"

--- @class UIEventSkinChallengeBundleLayout : UIEventSkinChallengeLayout
UIEventSkinChallengeBundleLayout = Class(UIEventSkinChallengeBundleLayout, UIEventSkinChallengeLayout)

--- @param view UIEventZodiacView
--- @param eventSkinChallengeTab EventSkinChallengeTab
--- @param anchor UnityEngine_RectTransform
function UIEventSkinChallengeBundleLayout:Ctor(view, eventSkinChallengeTab, anchor)
    --- @type UIEventSkinChallengeBundleLayoutConfig
    self.layoutConfig = nil
    --- @type UIEventSkinChallengeLayout
    self.layout = nil
    self.view = view
    ---@type UILoopScroll
    self.uiScroll = nil
    UIEventSkinChallengeLayout.Ctor(self, view, eventSkinChallengeTab, anchor)
end

function UIEventSkinChallengeBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("ui_event_skin_challenge_bundle_layout", self.anchor)
    UIEventSkinChallengeLayout.InitLayoutConfig(self, inst)
    self:InitListeners()
    self:InitUpdateTime()
    self:InitPack()
    self:InitScrolls()
end

function UIEventSkinChallengeBundleLayout:InitListeners()
    self.layoutConfig.backButton.onClick:AddListener(function()
        --self:CloseLayout()
        self.view:SelectTab(EventSkinChallengeTab.QUEST)
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_skin_challenge_exchange_info"))
    end)
end

function UIEventSkinChallengeBundleLayout:OnShow()
    UIEventSkinChallengeLayout.OnShow(self)
    self.model = self.view.eventModel
    self:InitLocalization()
    self:SetEndEventTime(self:GetEventEndTime(), function()
        self:OnEventTimeEnded()
    end)
    self:InitMoneyBar()
    self.uiScroll:Resize(self.packOfProducts.packDict:Count())
end

function UIEventSkinChallengeBundleLayout:InitMoneyBar()
    if self.moneyBarView == nil then
        self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
        self.moneyBarView:SetIconData(MoneyType.SKIN_BADGE)
    end
end

function UIEventSkinChallengeBundleLayout:ReturnPoolMoneyBar()
    if self.moneyBarView ~= nil then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end
end

function UIEventSkinChallengeBundleLayout:InitPack()
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetSkinChallengeBundleStore():GetCurrentPack()
    self.listPack = List()
    --- @param id number
    --- @param v LimitedProduct
    for _, v in pairs(self.packOfProducts.packDict:GetItems()) do
        self.listPack:Add(v)
    end
end

function UIEventSkinChallengeBundleLayout:InitScrolls()
    --- @param obj IapTilePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type LimitedProduct
        local limitedProduct = self.listPack:Get(dataIndex)
        obj:SetViewIconData(PackViewType.SKIN_CHALLENGE_BUNDLE, limitedProduct, function()
            self:OnPurchaseSuccess(limitedProduct.id)
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.IapTilePackItem, onCreateItem)
end

function UIEventSkinChallengeBundleLayout:OnPurchaseSuccess(packId)
    self.uiScroll:Resize(self.packOfProducts.packDict:Count())
end

function UIEventSkinChallengeBundleLayout:InitLocalization()
    self.layoutConfig.textEventTittle.text = LanguageUtils.LocalizeCommon("event_skin_challenge")
end

function UIEventSkinChallengeBundleLayout:OnHide()
    self:ReturnPoolMoneyBar()
    self:RemoveUpdateTime()
    self.uiScroll:Hide()
    UIEventSkinChallengeLayout.OnHide(self)
end

function UIEventSkinChallengeBundleLayout:GetEventEndTime()
    return self.eventModel.timeData.endTime
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventSkinChallengeBundleLayout:SetEndEventTime(endTime, onEventTimeEnded)
    self.endTime = endTime
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventSkinChallengeBundleLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventSkinChallengeBundleLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSkinChallengeBundleLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSkinChallengeBundleLayout:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventSkinChallengeBundleLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end