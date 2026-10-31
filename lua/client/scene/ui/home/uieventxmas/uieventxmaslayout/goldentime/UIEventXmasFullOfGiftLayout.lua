--- @class UIEventXmasFullOfGiftLayout : UIEventXmasLayout
UIEventXmasFullOfGiftLayout = Class(UIEventXmasFullOfGiftLayout, UIEventXmasLayout)

--- @param view UIEventXmasView
--- @param tab XmasTab
--- @param anchor UnityEngine_RectTransform
function UIEventXmasFullOfGiftLayout:Ctor(view, tab, anchor)
    --- @type UIEventFullOfGiftConfig
    self.layoutConfig = nil
    ---@type UISelect
    self.uiScroll = nil
    --- @type List
    self.listPoolItemShow = List()
    ---@type List<DiceSlotView>
    UIEventXmasLayout.Ctor(self, view, tab, anchor)
end

function UIEventXmasFullOfGiftLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("xmas_full_of_gift", self.anchor)
    UIEventXmasLayout.InitLayoutConfig(self, inst)
    self:InitButtonListener()
    self:InitLocalization()
    self:InitScroll()
end

function UIEventXmasFullOfGiftLayout:InitLocalization()
    UIEventXmasLayout.InitLocalization(self)
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("full_of_gift_desc")
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("full_of_gift_name")
    self.layoutConfig.textDropInfo.text = LanguageUtils.LocalizeCommon("full_of_gift_drop_info")
    self.layoutConfig.textRewardPool.text = LanguageUtils.LocalizeCommon("reward_pool")
end

function UIEventXmasFullOfGiftLayout:InitButtonListener()
    self.layoutConfig.buttonGo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonGo()
    end)
end

function UIEventXmasFullOfGiftLayout:OnShow()
    UIEventXmasLayout.OnShow(self)
    self:ShowDropTime()
    self:ShowIdleReward()
end

function UIEventXmasFullOfGiftLayout:ShowDropTime()
    self.layoutConfig.textDropTime.resizeTextMaxSize = 29
    self.layoutConfig.textDropTime.text = LanguageUtils.LocalizeCommon("drop_time_xmas")
    --self.layoutConfig.textDropTime.text = string.format("%s\n%s - %s",
    --        LanguageUtils.LocalizeCommon("drop_time_halloween"),
    --        TimeUtils.GetTimeFromDateTime(self.eventHalloweenModel.timeData.startTime),
    --        TimeUtils.GetTimeFromDateTime(self.eventHalloweenModel.timeData.endTime - TimeUtils.SecondADay))
end

function UIEventXmasFullOfGiftLayout:ShowIdleReward()
    self.listData = self.eventConfig:GetListRewardBox()
    self.uiScroll:Resize(self.listData:Count())
    self.uiScroll:PlayMotion()
end

function UIEventXmasFullOfGiftLayout:InitScroll()
    ---@param obj IconView
    local OnCreateItem = function(obj, index)
        ---@type RewardInbound
        local data = self.listData:Get(index + 1)
        obj:SetIconData(data:GetIconData())
        obj:RegisterShowInfo()
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.RootIconView, OnCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig(nil, nil, nil, 0.02, 2))
end

function UIEventXmasFullOfGiftLayout:OnHide()
    UIEventXmasLayout.OnHide(self)
    self:HideRewards()
end

function UIEventXmasFullOfGiftLayout:OnClickButtonGo()
    FeatureMapping.GoToFeature(FeatureType.CAMPAIGN, false, function()
        PopupMgr.HidePopup(UIPopupName.UIEventXmas)
    end)
end

function UIEventXmasFullOfGiftLayout:HideRewards()
    -----@param v ItemIconView
    --for i, v in ipairs(self.listPoolItemShow:GetItems()) do
    --    v:ReturnPool()
    --end
    --self.listPoolItemShow:Clear()
    self.uiScroll:Hide()
end






