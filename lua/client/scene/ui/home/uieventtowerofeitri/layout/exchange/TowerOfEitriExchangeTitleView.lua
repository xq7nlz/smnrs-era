require "lua.client.scene.ui.common.UIPrefabView"
--- @class TowerOfEitriExchangeTitleView : UIPrefabView
TowerOfEitriExchangeTitleView = Class(TowerOfEitriExchangeTitleView, UIPrefabView)

function TowerOfEitriExchangeTitleView:Ctor()
    UIPrefabView.Ctor(self)
    --- @type List
    self.listRewardItem = List()
end

--- @return void
function TowerOfEitriExchangeTitleView:SetPrefabName()
    self.prefabName = 'event_tower_of_eitri_exchange_title'
    self.uiPoolType = UIPoolType.UIEventTowerOfEitriExchangeTitle
end

--- @return void
--- @param transform UnityEngine_RectTransform
function TowerOfEitriExchangeTitleView:SetConfig(transform)
    ---@type TowerOfEitriExchangeTitleConfig
    self.config = UIBaseConfig(transform)
end

--- @param stageId number
--- @param listItem List
--- @param func function(stageId,number)
function TowerOfEitriExchangeTitleView:SetData(stageId, listItem, func, model)
    --- @type EventTowerOfEitriModel
    self.eventModel = model
    self.stageId = stageId
    local canBuy = true
    UIUtils.SetActiveColorByMaterial(self.config.gameObject, canBuy, "ui_gray_mat")
    self:ReturnPoolItem()
    for i = 1, listItem:Count() do
        --- @type TowerOfEitriExchangeItemView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIEventTowerOfEitriExchangeItem, self.config.rewardAnchor)
        --- @type EventTowerOfEitriExchangeItemData
        local itemData = listItem:Get(i)
        itemData.buyTime = self.eventModel:GetNumberExchange(itemData.id)
        item:SetIconData(itemData)
        item:RegisterShowInfo()
        item:AddListener(function()
            func(stageId, itemData.id, itemData.price, item)
        end)
        self.listRewardItem:Add(item)
    end
    self:InitLocalization()
    self.config.conditionText.gameObject:SetActive(not canBuy)
end

--- @return void
function TowerOfEitriExchangeTitleView:InitLocalization()
    self.config.content.text = LanguageUtils.LocalizeCommon("star_reward_pool") .. " " .. self.stageId
    self.config.conditionText.text = LanguageUtils.LocalizeCommon("star_reward_pool_condition") .. " " .. (self.stageId - 1)
end

--- @return void
--- @param func function
function TowerOfEitriExchangeTitleView:AddListener(func)

end

--- @return void
--- @param func function
function TowerOfEitriExchangeTitleView:RemoveAllListeners(func)

end

--- @return void
function TowerOfEitriExchangeTitleView:Show()
    self.config.gameObject:SetActive(true)
end

--- @return void
function TowerOfEitriExchangeTitleView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self:ReturnPoolItem()
end

--- @return void
function TowerOfEitriExchangeTitleView:ReturnPoolItem()
    for i = 1, self.listRewardItem:Count() do
        self.listRewardItem:Get(i):ReturnPool()
    end
    self.listRewardItem:Clear()
end

--- @return void
function TowerOfEitriExchangeTitleView:ActiveEffectSelect(isActive)
    if self.iconView ~= nil then
        self.iconView:ActiveEffectSelect(isActive)
    end
end

return TowerOfEitriExchangeTitleView
