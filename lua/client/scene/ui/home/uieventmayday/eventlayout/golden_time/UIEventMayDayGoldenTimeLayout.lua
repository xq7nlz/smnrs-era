require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventMayDayGoldenTimeLayout : UIEventMayDayLayout
UIEventMayDayGoldenTimeLayout = Class(UIEventMayDayGoldenTimeLayout, UIEventMayDayLayout)

--- @param view UIEventMayDayView
--- @param halloweenTab MayDayTab
--- @param anchor UnityEngine_RectTransform
function UIEventMayDayGoldenTimeLayout:Ctor(view, halloweenTab, anchor)
    --- @type UIEventMayDayGoldenTimeLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.listPoolItemShow = List()
    UIEventMayDayLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventMayDayGoldenTimeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("may_day_golden_time", self.anchor)
    UIEventMayDayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEventMayDayGoldenTimeLayout:InitLocalization()
    UIEventMayDayLayout.InitLocalization(self)
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("event_golden_time_may_day_desc")
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_golden_time_may_day_name")

    self:GetModelConfig()
    local goldTimeConfig = self.eventConfig:GetGoldenTimeConfig()
    local content = LanguageUtils.LocalizeCommon("golden_time_may_day_drop_info")
    content = StringUtils.FormatLocalize(content,
            goldTimeConfig.intervalTime:Get(1), goldTimeConfig.intervalTime:Get(2))
    self.layoutConfig.textDropInfo.text = content
    self.layoutConfig.buttonGo.transform:Find("text_go")
            :GetComponent(ComponentName.UnityEngine_UI_Text).text = LanguageUtils.LocalizeCommon("go")
end

function UIEventMayDayGoldenTimeLayout:InitButtonListener()
    self.layoutConfig.buttonGo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonGo()
    end)
end

function UIEventMayDayGoldenTimeLayout:InitItemShow()
    for i = 1, self.layoutConfig.rewardAnchor.childCount do
        --- @type UnityEngine_Transform
        local child = self.layoutConfig.rewardAnchor:GetChild(i - 1)
        local itemShow = ItemShowWithNameAndType(child)
        self.listPoolItemShow:Add(itemShow)
    end
end

function UIEventMayDayGoldenTimeLayout:OnShow()
    UIEventMayDayLayout.OnShow(self)
    self:ShowDropTime()
    self:ShowIdleReward()
end

function UIEventMayDayGoldenTimeLayout:ShowDropTime()
    self.layoutConfig.textDropTime.resizeTextMaxSize = 29
    self.layoutConfig.textDropTime.text = LanguageUtils.LocalizeCommon("drop_time_may_day")
end

function UIEventMayDayGoldenTimeLayout:ShowIdleReward()
    --- @type {listGoldenTimeReward : List, lastDuration : number}
    local goldTimeConfig = self.eventConfig:GetGoldenTimeConfig()
    local listRewardConfig = goldTimeConfig.listGoldenTimeReward
    for i = 1, listRewardConfig:Count() do
        --- @type RewardInBound
        local rewardInBound = listRewardConfig:Get(i)
        local itemShow = self:GetItemShowByChildIndex(i)
        local shop = LanguageUtils.LocalizeCommon("may_day_shop")
        local dailyPack = LanguageUtils.LocalizeCommon("daily_packs")
        local diceTitle = LanguageUtils.LocalizeCommon("may_day_dice_title")
        local content = LanguageUtils.LocalizeCommon("source_money_type_" .. rewardInBound.id)
        content = StringUtils.FormatLocalize(content, nil,
                shop,
                dailyPack,
                diceTitle)
        itemShow:SetReward(rewardInBound, content)
    end
end

--- @return ItemShowWithNameAndType
function UIEventMayDayGoldenTimeLayout:GetItemShowByChildIndex(index)
    if index > self.listPoolItemShow:Count() then
        local prefab = self.layoutConfig.rewardAnchor:GetChild(0).gameObject
        --- @type UnityEngine_GameObject
        local clone = U_GameObject.Instantiate(prefab, self.layoutConfig.rewardAnchor)
        local itemShow = ItemShowWithNameAndType(clone.transform)
        self.listPoolItemShow:Add(itemShow)
    end
    return self.listPoolItemShow:Get(index)
end

function UIEventMayDayGoldenTimeLayout:OnHide()
    UIEventMayDayLayout.OnHide(self)
    self:HideRewards()
end

function UIEventMayDayGoldenTimeLayout:OnClickButtonGo()
    FeatureMapping.GoToFeature(FeatureType.CAMPAIGN, false, function()
        PopupMgr.HidePopup(UIPopupName.UIEventMayDay)
    end)
end

function UIEventMayDayGoldenTimeLayout:HideRewards()
    for i = 1, self.listPoolItemShow:Count() do
        --- @type ItemShowWithNameAndType
        local itemShow = self.listPoolItemShow:Get(i)
        itemShow:OnHide()
    end
end






