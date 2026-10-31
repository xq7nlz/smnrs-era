require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventHalloweenGoldenTimeLayout : UIEventHalloweenLayout
UIEventHalloweenGoldenTimeLayout = Class(UIEventHalloweenGoldenTimeLayout, UIEventHalloweenLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventHalloweenGoldenTimeLayout:Ctor(view, halloweenTab, anchor)
    --- @type DiceLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.listPoolItemShow = List()
    UIEventHalloweenLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventHalloweenGoldenTimeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("halloween_golden_time", self.anchor)
    UIEventHalloweenLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEventHalloweenGoldenTimeLayout:InitLocalization()
    UIEventHalloweenLayout.InitLocalization(self)
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("event_golden_time_halloween_desc")
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_golden_time_halloween_name")

    self:GetModelConfig()
    local goldTimeConfig = self.eventConfig:GetGoldenTimeConfig()
    local content = LanguageUtils.LocalizeCommon("golden_time_halloween_drop_info")
    content = StringUtils.FormatLocalize(content,
            goldTimeConfig.intervalTime:Get(1), goldTimeConfig.intervalTime:Get(2))
    self.layoutConfig.textDropInfo.text = content
    self.layoutConfig.buttonGo.transform:Find("text_go")
            :GetComponent(ComponentName.UnityEngine_UI_Text).text = LanguageUtils.LocalizeCommon("go")
end

function UIEventHalloweenGoldenTimeLayout:InitButtonListener()
    self.layoutConfig.buttonGo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonGo()
    end)
end

function UIEventHalloweenGoldenTimeLayout:InitItemShow()
    for i = 1, self.layoutConfig.rewardAnchor.childCount do
        --- @type UnityEngine_Transform
        local child = self.layoutConfig.rewardAnchor:GetChild(i - 1)
        local itemShow = ItemShowWithNameAndType(child)
        self.listPoolItemShow:Add(itemShow)
    end
end

function UIEventHalloweenGoldenTimeLayout:OnShow()
    UIEventHalloweenLayout.OnShow(self)
    self:ShowDropTime()
    self:ShowIdleReward()
end

function UIEventHalloweenGoldenTimeLayout:ShowDropTime()
    --self.layoutConfig.textDropTime.resizeTextMaxSize = 29
    --self.layoutConfig.textDropTime.text = LanguageUtils.LocalizeCommon("drop_time_halloween")

    self.layoutConfig.textDropTime.resizeTextMaxSize = 29
    self.layoutConfig.textDropTime.text = LanguageUtils.LocalizeCommon("drop_time_halloween")
end

function UIEventHalloweenGoldenTimeLayout:ShowIdleReward()
    --- @type {listGoldenTimeReward : List, lastDuration : number}
    local goldTimeConfig = self.eventConfig:GetGoldenTimeConfig()
    local listRewardConfig = goldTimeConfig.listGoldenTimeReward
    for i = 1, listRewardConfig:Count() do
        --- @type RewardInBound
        local rewardInBound = listRewardConfig:Get(i)
        local itemShow = self:GetItemShowByChildIndex(i)
        local shop = LanguageUtils.LocalizeCommon("shop")
        local dailyPack = LanguageUtils.LocalizeCommon("daily_packs")
        local diceTitle = LanguageUtils.LocalizeCommon("dice_title")
        local content = LanguageUtils.LocalizeCommon("source_money_type_" .. rewardInBound.id)
        content = StringUtils.FormatLocalize(content, nil,
                shop,
                dailyPack,
                diceTitle)
        itemShow:SetReward(rewardInBound, content)
    end
end

--- @return ItemShowWithNameAndType
function UIEventHalloweenGoldenTimeLayout:GetItemShowByChildIndex(index)
    if index > self.listPoolItemShow:Count() then
        local prefab = self.layoutConfig.rewardAnchor:GetChild(0).gameObject
        --- @type UnityEngine_GameObject
        local clone = U_GameObject.Instantiate(prefab, self.layoutConfig.rewardAnchor)
        local itemShow = ItemShowWithNameAndType(clone.transform)
        self.listPoolItemShow:Add(itemShow)
    end
    return self.listPoolItemShow:Get(index)
end

function UIEventHalloweenGoldenTimeLayout:OnHide()
    UIEventHalloweenLayout.OnHide(self)
    self:HideRewards()
end

function UIEventHalloweenGoldenTimeLayout:OnClickButtonGo()
    FeatureMapping.GoToFeature(FeatureType.CAMPAIGN, false, function()
        PopupMgr.HidePopup(UIPopupName.UIEventHalloween)
    end)
end

function UIEventHalloweenGoldenTimeLayout:HideRewards()
    for i = 1, self.listPoolItemShow:Count() do
        --- @type ItemShowWithNameAndType
        local itemShow = self.listPoolItemShow:Get(i)
        itemShow:OnHide()
    end
end






