require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventValentine2024GoldenTimeLayout : UIEventValentine2024Layout
UIEventValentine2024GoldenTimeLayout = Class(UIEventValentine2024GoldenTimeLayout, UIEventValentine2024Layout)

--- @param view UIEventValentine2024View
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventValentine2024GoldenTimeLayout:Ctor(view, halloweenTab, anchor)
    --- @type DiceLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.listPoolItemShow = List()
    UIEventValentine2024Layout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventValentine2024GoldenTimeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("valentine_2024_golden_time", self.anchor)
    UIEventValentine2024Layout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEventValentine2024GoldenTimeLayout:InitLocalization()
    UIEventValentine2024Layout.InitLocalization(self)
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("event_golden_time_valentine_2024_desc")
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_golden_time_valentine_2024_name")

    self:GetModelConfig()
    local goldTimeConfig = self.eventConfig:GetGoldenTimeConfig()
    local content = LanguageUtils.LocalizeCommon("golden_time_valentine_2024_drop_info")
    content = StringUtils.FormatLocalize(content,
            goldTimeConfig.intervalTime:Get(1), goldTimeConfig.intervalTime:Get(2))
    self.layoutConfig.textDropInfo.text = content
    self.layoutConfig.buttonGo.transform:Find("text_go")
            :GetComponent(ComponentName.UnityEngine_UI_Text).text = LanguageUtils.LocalizeCommon("go")
end

function UIEventValentine2024GoldenTimeLayout:InitButtonListener()
    self.layoutConfig.buttonGo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonGo()
    end)
end

function UIEventValentine2024GoldenTimeLayout:InitItemShow()
    for i = 1, self.layoutConfig.rewardAnchor.childCount do
        --- @type UnityEngine_Transform
        local child = self.layoutConfig.rewardAnchor:GetChild(i - 1)
        local itemShow = ItemShowWithNameAndType(child)
        self.listPoolItemShow:Add(itemShow)
    end
end

function UIEventValentine2024GoldenTimeLayout:OnShow()
    UIEventValentine2024Layout.OnShow(self)
    self:ShowDropTime()
    self:ShowIdleReward()
end

function UIEventValentine2024GoldenTimeLayout:ShowDropTime()
    self.layoutConfig.textDropTime.resizeTextMaxSize = 29
    self.layoutConfig.textDropTime.text = LanguageUtils.LocalizeCommon("drop_time_valentine_2024")
end

function UIEventValentine2024GoldenTimeLayout:ShowIdleReward()
    --- @type {listGoldenTimeReward : List, lastDuration : number}
    local goldTimeConfig = self.eventConfig:GetGoldenTimeConfig()
    local listRewardConfig = goldTimeConfig.listGoldenTimeReward
    for i = 1, listRewardConfig:Count() do
        --- @type RewardInBound
        local rewardInBound = listRewardConfig:Get(i)
        local itemShow = self:GetItemShowByChildIndex(i)
        local shop = LanguageUtils.LocalizeCommon("new_year_shop")
        local dailyPack = LanguageUtils.LocalizeCommon("daily_packs")
        local diceTitle = LanguageUtils.LocalizeCommon("thanks_giving_dice_title")
        local content = LanguageUtils.LocalizeCommon("source_money_type_" .. rewardInBound.id)
        content = StringUtils.FormatLocalize(content, nil,
                shop,
                dailyPack,
                diceTitle)
        itemShow:SetReward(rewardInBound, content)
    end
end

--- @return ItemShowWithNameAndType
function UIEventValentine2024GoldenTimeLayout:GetItemShowByChildIndex(index)
    if index > self.listPoolItemShow:Count() then
        local prefab = self.layoutConfig.rewardAnchor:GetChild(0).gameObject
        --- @type UnityEngine_GameObject
        local clone = U_GameObject.Instantiate(prefab, self.layoutConfig.rewardAnchor)
        local itemShow = ItemShowWithNameAndType(clone.transform)
        self.listPoolItemShow:Add(itemShow)
    end
    return self.listPoolItemShow:Get(index)
end

function UIEventValentine2024GoldenTimeLayout:OnHide()
    UIEventValentine2024Layout.OnHide(self)
    self:HideRewards()
end

function UIEventValentine2024GoldenTimeLayout:OnClickButtonGo()
    FeatureMapping.GoToFeature(FeatureType.CAMPAIGN, false, function()
        PopupMgr.HidePopup(UIPopupName.UIEventValentine2024)
    end)
end

function UIEventValentine2024GoldenTimeLayout:HideRewards()
    for i = 1, self.listPoolItemShow:Count() do
        --- @type ItemShowWithNameAndType
        local itemShow = self.listPoolItemShow:Get(i)
        itemShow:OnHide()
    end
end






