---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.DonateHelpItemConfig"

--- @class DonateHelpItemView : IconView
DonateHelpItemView = Class(DonateHelpItemView , IconView)

function DonateHelpItemView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function DonateHelpItemView:SetPrefabName()
    self.prefabName = 'donate_help_item_view'
    self.uiPoolType = UIPoolType.DonateHelpItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function DonateHelpItemView:SetConfig(transform)
    assert(transform)
    --- @type DonateHelpItemConfig
    ---@type DonateHelpItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData QuestRewardActivity
function DonateHelpItemView:SetIconData(iconData, moneyType)
    self.config.iconReward.sprite = ResourceLoadUtils.LoadMoneyIcon(moneyType)
    ---@type RewardInBound
    local reward = iconData.questElementConfig._listReward:Get(1)
    self.config.textValue.text = reward.number
    local money = iconData:GetMoneyTpe()
    local feature = iconData:GetFeatureType()
    self.config.icon:SetActive(false)
    self.config.iconMoney.gameObject:SetActive(false)
    self.config.iconFeature.gameObject:SetActive(false)
    if money ~= nil then
        self.config.iconMoney.gameObject:SetActive(true)
        self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(money)
        self.config.iconMoney:SetNativeSize()
        self.config.icon:SetActive(true)
    elseif feature ~= nil then
        self.config.iconFeature.gameObject:SetActive(true)
        self.config.iconFeature.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFeature, feature)
        self.config.iconFeature:SetNativeSize()
        self.config.icon:SetActive(true)
    end
    self.config.textContent.text = LanguageUtils.LocalizeGuildQuestDescription(iconData.questElementConfig)
end

return DonateHelpItemView