require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"
--- @class UIEventNewYearGoldenTimeLayout : UIEventNewYearLayout
UIEventNewYearGoldenTimeLayout = Class(UIEventNewYearGoldenTimeLayout, UIEventNewYearLayout)

function UIEventNewYearGoldenTimeLayout:Ctor(view, tab, anchor)
    --- @type UIEventNewYearGoldenTimeLayoutConfig
    self.layoutConfig = nil
    ---@type UISelect
    self.uiScroll = nil
    --- @type List
    self.listPoolItemShow = List()
    ---@type List<DiceSlotView>
    UIEventNewYearLayout.Ctor(self, view, tab, anchor)
end

function UIEventNewYearGoldenTimeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_year_golden_time", self.anchor)
    UIEventNewYearLayout.InitLayoutConfig(self, inst)

    self:InitButtonListener()
    self:InitLocalization()
    self:InitItemShow()
end

function UIEventNewYearGoldenTimeLayout:InitLocalization()
    UIEventNewYearLayout.InitLocalization(self)
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("new_year_golden_time_title")
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("new_year_golden_time_desc")
    self.layoutConfig.textGo.text = LanguageUtils.LocalizeCommon("go")

end

function UIEventNewYearGoldenTimeLayout:InitButtonListener()
    self.layoutConfig.buttonGo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonGo()
    end)
end

function UIEventNewYearGoldenTimeLayout:OnClickButtonGo()
    FeatureMapping.GoToFeature(FeatureType.CAMPAIGN, false, function()
        PopupMgr.HidePopup(UIPopupName.UIEventNewYear)
    end)
end

function UIEventNewYearGoldenTimeLayout:InitItemShow()
    for i = 1, self.layoutConfig.rewardAnchor.childCount do
        --- @type UnityEngine_Transform
        local child = self.layoutConfig.rewardAnchor:GetChild(i - 1)
        local itemShow = ItemShowWithNameAndType(child)
        self.listPoolItemShow:Add(itemShow)
    end
end

function UIEventNewYearGoldenTimeLayout:OnShow()
    UIEventNewYearLayout.OnShow(self)
    self:ShowDropTime()
    self:ShowIdleReward()
end


function UIEventNewYearGoldenTimeLayout:ShowDropTime()
    self.layoutConfig.textDropTime.resizeTextMaxSize = 29
    self.layoutConfig.textDropTime.text = LanguageUtils.LocalizeCommon("drop_time_new_year")
    self.layoutConfig.textDropInfo.text =
    string.format(LanguageUtils.LocalizeCommon("new_year_golden_time_drop_info"),
            self.eventConfig:GetGoldenTimeConfig().intervalTime:Get(1))

end

function UIEventNewYearGoldenTimeLayout:ShowIdleReward()
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
function UIEventNewYearGoldenTimeLayout:GetItemShowByChildIndex(index)
    if index > self.listPoolItemShow:Count() then
        local prefab = self.layoutConfig.rewardAnchor:GetChild(0).gameObject
        --- @type UnityEngine_GameObject
        local clone = U_GameObject.Instantiate(prefab, self.layoutConfig.rewardAnchor)
        local itemShow = ItemShowWithNameAndType(clone.transform)
        self.listPoolItemShow:Add(itemShow)
    end
    return self.listPoolItemShow:Get(index)
end

function UIEventNewYearGoldenTimeLayout:OnHide()
    UIEventNewYearLayout.OnHide(self)
    self:HideRewards()
end

function UIEventNewYearGoldenTimeLayout:OnClickButtonGo()
    FeatureMapping.GoToFeature(FeatureType.CAMPAIGN, false, function()
        PopupMgr.HidePopup(UIPopupName.UIEventNewYear)
    end)
end

function UIEventNewYearGoldenTimeLayout:HideRewards()
    for i = 1, self.listPoolItemShow:Count() do
        --- @type ItemShowWithNameAndType
        local itemShow = self.listPoolItemShow:Get(i)
        itemShow:OnHide()
    end
end






