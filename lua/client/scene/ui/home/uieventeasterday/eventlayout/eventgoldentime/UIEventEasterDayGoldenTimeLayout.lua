require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventEasterDayGoldenTimeLayout : UIEventEasterDayLayout
UIEventEasterDayGoldenTimeLayout = Class(UIEventEasterDayGoldenTimeLayout, UIEventEasterDayLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventEasterDayGoldenTimeLayout:Ctor(view, halloweenTab, anchor)
    --- @type DiceLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.listPoolItemShow = List()
    UIEventEasterDayLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventEasterDayGoldenTimeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("easter_day_golden_time", self.anchor)
    UIEventEasterDayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEventEasterDayGoldenTimeLayout:InitLocalization()
    UIEventEasterDayLayout.InitLocalization(self)
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("event_golden_time_easter_day_desc")
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_golden_time_easter_day_name")

    self:GetModelConfig()
    local goldTimeConfig = self.eventConfig:GetGoldenTimeConfig()
    local content = LanguageUtils.LocalizeCommon("golden_time_easter_day_drop_info")
    content = StringUtils.FormatLocalize(content,
            goldTimeConfig.intervalTime:Get(1), goldTimeConfig.intervalTime:Get(2))
    self.layoutConfig.textDropInfo.text = content
    self.layoutConfig.buttonGo.transform:Find("text_go")
            :GetComponent(ComponentName.UnityEngine_UI_Text).text = LanguageUtils.LocalizeCommon("go")
end

function UIEventEasterDayGoldenTimeLayout:InitButtonListener()
    self.layoutConfig.buttonGo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonGo()
    end)
end

function UIEventEasterDayGoldenTimeLayout:InitItemShow()
    for i = 1, self.layoutConfig.rewardAnchor.childCount do
        --- @type UnityEngine_Transform
        local child = self.layoutConfig.rewardAnchor:GetChild(i - 1)
        local itemShow = ItemShowWithNameAndType(child)
        self.listPoolItemShow:Add(itemShow)
    end
end

function UIEventEasterDayGoldenTimeLayout:OnShow()
    UIEventEasterDayLayout.OnShow(self)
    self:ShowDropTime()
    self:ShowIdleReward()
end

function UIEventEasterDayGoldenTimeLayout:ShowDropTime()
    --self.layoutConfig.textDropTime.resizeTextMaxSize = 29
    --self.layoutConfig.textDropTime.text = LanguageUtils.LocalizeCommon("drop_time_halloween")

    self.layoutConfig.textDropTime.resizeTextMaxSize = 29
    self.layoutConfig.textDropTime.text = LanguageUtils.LocalizeCommon("drop_time_easter_day")
end

function UIEventEasterDayGoldenTimeLayout:ShowIdleReward()
    --- @type {listGoldenTimeReward : List, lastDuration : number}
    local goldTimeConfig = self.eventConfig:GetGoldenTimeConfig()
    local listRewardConfig = goldTimeConfig.listGoldenTimeReward
    for i = 1, listRewardConfig:Count() do
        --- @type RewardInBound
        local rewardInBound = listRewardConfig:Get(i)
        local itemShow = self:GetItemShowByChildIndex(i)
        local shop = LanguageUtils.LocalizeCommon("easter_day_shop")
        local dailyPack = LanguageUtils.LocalizeCommon("daily_packs")
        local diceTitle = LanguageUtils.LocalizeCommon("easter_day_dice_title")
        local content = LanguageUtils.LocalizeCommon("source_money_type_" .. rewardInBound.id)
        content = StringUtils.FormatLocalize(content, nil,
                shop,
                dailyPack,
                diceTitle)
        itemShow:SetReward(rewardInBound, content)
    end
end

--- @return ItemShowWithNameAndType
function UIEventEasterDayGoldenTimeLayout:GetItemShowByChildIndex(index)
    if index > self.listPoolItemShow:Count() then
        local prefab = self.layoutConfig.rewardAnchor:GetChild(0).gameObject
        --- @type UnityEngine_GameObject
        local clone = U_GameObject.Instantiate(prefab, self.layoutConfig.rewardAnchor)
        local itemShow = ItemShowWithNameAndType(clone.transform)
        self.listPoolItemShow:Add(itemShow)
    end
    return self.listPoolItemShow:Get(index)
end

function UIEventEasterDayGoldenTimeLayout:OnHide()
    UIEventEasterDayLayout.OnHide(self)
    self:HideRewards()
end

function UIEventEasterDayGoldenTimeLayout:OnClickButtonGo()
    FeatureMapping.GoToFeature(FeatureType.CAMPAIGN, false, function()
        PopupMgr.HidePopup(UIPopupName.UIEventEasterDay)
    end)
end

function UIEventEasterDayGoldenTimeLayout:HideRewards()
    for i = 1, self.listPoolItemShow:Count() do
        --- @type ItemShowWithNameAndType
        local itemShow = self.listPoolItemShow:Get(i)
        itemShow:OnHide()
    end
end






