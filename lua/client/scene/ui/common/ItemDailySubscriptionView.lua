--- @class ItemDailySubscriptionView : IconView
ItemDailySubscriptionView = Class(ItemDailySubscriptionView, IconView)

--- @return void
function ItemDailySubscriptionView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function ItemDailySubscriptionView:SetPrefabName()
    self.prefabName = 'item_daily_subscription_view'
    self.uiPoolType = UIPoolType.ItemDailySubscriptionView
end

--- @return void
--- @param transform UnityEngine_Transform
function ItemDailySubscriptionView:SetConfig(transform)
    ---@type ItemDailySubscriptionViewConfig
    self.config = UIBaseConfig(transform)
end

--- @param rewardInBound RewardInBound
function ItemDailySubscriptionView:SetIconData(rewardInBound)
    self.rewardInBound = rewardInBound

    self.config.iconCurrency.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconCurrenciesEffect,
            tostring(rewardInBound.id), ComponentName.UnityEngine_Sprite)
    self.config.iconCurrency:SetNativeSize()

    self.config.value.text = tostring(rewardInBound.number)

    self.config.info.text = LanguageUtils.LocalizeCommon("claim_daily")
end

function ItemDailySubscriptionView:OverrideVisual(icon, value, info)
    self.config.iconCurrency.sprite = icon
    self.config.iconCurrency:SetNativeSize()

    self.config.value.text = value

    self.config.info.text = info
end

--- @return void
---@param func function
function ItemDailySubscriptionView:AddListener(func)
    self:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

--- @return void
function ItemDailySubscriptionView:RemoveAllListeners()
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
function ItemDailySubscriptionView:ShowInfo()
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview,
            { ["data1"] = { ["type"] = self.rewardInBound.type, ["id"] = self.rewardInBound.id } })
end

return ItemDailySubscriptionView