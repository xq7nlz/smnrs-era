require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventGoldenTimeLayout : UIEventMidAutumnLayout
UIEventGoldenTimeLayout = Class(UIEventGoldenTimeLayout, UIEventMidAutumnLayout)

--- @param view UIEventView
function UIEventGoldenTimeLayout:Ctor(view, midAutumnTab, anchor)
    --- @type UIEventGoldenTimeLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.listPoolItemShow = List()
    UIEventMidAutumnLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventGoldenTimeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("golden_time_view", self.anchor)
    UIEventMidAutumnLayout.InitLayoutConfig(self, inst)

    self:InitItemShow()
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEventGoldenTimeLayout:InitLocalization()
    UIEventMidAutumnLayout.InitLocalization(self)
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("event_golden_time_desc")
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_golden_time_name")
    self.layoutConfig.textDropInfo.text = LanguageUtils.LocalizeCommon("golden_time_drop_info")
    self.layoutConfig.textGo.text = LanguageUtils.LocalizeCommon("go")
end

function UIEventGoldenTimeLayout:InitButtonListener()
    self.layoutConfig.buttonGo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonGo()
    end)
end

function UIEventGoldenTimeLayout:InitItemShow()
    for i = 1, self.layoutConfig.rewardAnchor.childCount do
        --- @type UnityEngine_Transform
        local child = self.layoutConfig.rewardAnchor:GetChild(i - 1)
        local itemShow = ItemShowWithNameAndType(child)
        self.listPoolItemShow:Add(itemShow)
    end
end

function UIEventGoldenTimeLayout:OnShow()
    UIEventMidAutumnLayout.OnShow(self)
    self:ShowDropTime()
    self:ShowIdleReward()
end

function UIEventGoldenTimeLayout:ShowDropTime()
    self.layoutConfig.textDropTime.resizeTextMaxSize = 29
    self.layoutConfig.textDropTime.text = string.format("%s\n%s - %s",
            LanguageUtils.LocalizeCommon("drop_time"),
            TimeUtils.GetTimeFromDateTime(self.eventMidAutumnModel.timeData.startTime),
            TimeUtils.GetTimeFromDateTime(self.eventMidAutumnModel.timeData.endTime - TimeUtils.SecondADay))
end

function UIEventGoldenTimeLayout:ShowIdleReward()
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
function UIEventGoldenTimeLayout:GetItemShowByChildIndex(index)
    if index > self.listPoolItemShow:Count() then
        local prefab = self.layoutConfig.rewardAnchor:GetChild(0).gameObject
        --- @type UnityEngine_GameObject
        local clone = U_GameObject.Instantiate(prefab, self.layoutConfig.rewardAnchor)
        local itemShow = ItemShowWithNameAndType(clone.transform)
        self.listPoolItemShow:Add(itemShow)
    end
    return self.listPoolItemShow:Get(index)
end

function UIEventGoldenTimeLayout:OnHide()
    UIEventMidAutumnLayout.OnHide(self)
    self:HideRewards()
end

function UIEventGoldenTimeLayout:OnClickButtonGo()
    FeatureMapping.GoToFeature(FeatureType.CAMPAIGN, false, function()
        PopupMgr.HidePopup(UIPopupName.UIEventMidAutumn)
    end)
end

function UIEventGoldenTimeLayout:HideRewards()
    for i = 1, self.listPoolItemShow:Count() do
        --- @type ItemShowWithNameAndType
        local itemShow = self.listPoolItemShow:Get(i)
        itemShow:OnHide()
    end
end
