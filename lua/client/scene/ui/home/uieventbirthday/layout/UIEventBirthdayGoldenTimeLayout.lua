require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventBirthdayGoldenTimeLayout : UIEventBirthdayLayout
UIEventBirthdayGoldenTimeLayout = Class(UIEventBirthdayGoldenTimeLayout, UIEventBirthdayLayout)

--- @param view UIEventHalloweenView
--- @param eventBirthdayTab EventBirthdayTab
--- @param anchor UnityEngine_RectTransform
function UIEventBirthdayGoldenTimeLayout:Ctor(view, eventBirthdayTab, anchor)
    --- @type UIEventBirthdayGoldenTimeLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.listPoolItemShow = List()
    UIEventBirthdayLayout.Ctor(self, view, eventBirthdayTab, anchor)
end

function UIEventBirthdayGoldenTimeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("birthday_golden_time", self.anchor)
    UIEventBirthdayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEventBirthdayGoldenTimeLayout:InitLocalization()
    UIEventBirthdayLayout.InitLocalization(self)
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("event_birthday_golden_time_desc")
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_birthday_golden_time_name")
    self.layoutConfig.textDropInfo.text = LanguageUtils.LocalizeCommon("golden_time_birthday_drop_info")
end

function UIEventBirthdayGoldenTimeLayout:InitButtonListener()
    self.layoutConfig.buttonGo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonGo()
    end)
end

function UIEventBirthdayGoldenTimeLayout:InitItemShow()
    for i = 1, self.layoutConfig.rewardAnchor.childCount do
        --- @type UnityEngine_Transform
        local child = self.layoutConfig.rewardAnchor:GetChild(i - 1)
        local itemShow = ItemShowWithNameAndType(child)
        self.listPoolItemShow:Add(itemShow)
    end
end

function UIEventBirthdayGoldenTimeLayout:OnShow()
    UIEventBirthdayLayout.OnShow(self)
    self:ShowDropTime()
    self:ShowIdleReward()
end

function UIEventBirthdayGoldenTimeLayout:ShowDropTime()
    self.layoutConfig.textDropTime.resizeTextMaxSize = 29
    self.layoutConfig.textDropTime.text = LanguageUtils.LocalizeCommon("drop_time_birthday")
end

function UIEventBirthdayGoldenTimeLayout:ShowIdleReward()
    --- @type {listGoldenTimeReward : List, lastDuration : number}
    local goldTimeConfig = self.eventConfig:GetGoldenTimeConfig()
    local listRewardConfig = goldTimeConfig.listGoldenTimeReward
    for i = 1, listRewardConfig:Count() do
        --- @type RewardInBound
        local rewardInBound = listRewardConfig:Get(i)
        local itemShow = self:GetItemShowByChildIndex(i)
        itemShow:SetReward(rewardInBound, LanguageUtils.LocalizeCommon("source_money_type_" .. rewardInBound.id))
    end
end

--- @return ItemShowWithNameAndType
function UIEventBirthdayGoldenTimeLayout:GetItemShowByChildIndex(index)
    if index > self.listPoolItemShow:Count() then
        local prefab = self.layoutConfig.rewardAnchor:GetChild(0).gameObject
        --- @type UnityEngine_GameObject
        local clone = U_GameObject.Instantiate(prefab, self.layoutConfig.rewardAnchor)
        local itemShow = ItemShowWithNameAndType(clone.transform)
        self.listPoolItemShow:Add(itemShow)
    end
    return self.listPoolItemShow:Get(index)
end

function UIEventBirthdayGoldenTimeLayout:OnHide()
    UIEventBirthdayLayout.OnHide(self)
    self:HideRewards()
end

function UIEventBirthdayGoldenTimeLayout:OnClickButtonGo()
    FeatureMapping.GoToFeature(FeatureType.CAMPAIGN, false, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventBirthdayGoldenTimeLayout:HideRewards()
    for i = 1, self.listPoolItemShow:Count() do
        --- @type ItemShowWithNameAndType
        local itemShow = self.listPoolItemShow:Get(i)
        itemShow:OnHide()
    end
end