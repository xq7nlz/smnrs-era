require "lua.client.scene.ui.common.UIPrefabView"
--- @class ZodiacExchangePoolView : UIPrefabView
ZodiacExchangePoolView = Class(ZodiacExchangePoolView,UIPrefabView)

function ZodiacExchangePoolView:Ctor()
    UIPrefabView.Ctor(self)
    --- @type List
    self.listRewardItem = List()
end

--- @return void
function ZodiacExchangePoolView:SetPrefabName()
    self.prefabName = 'zodiac_exchange_pool'
    self.uiPoolType = UIPoolType.ZodiacExchangePoolView
end

--- @return void
--- @param transform UnityEngine_RectTransform
function ZodiacExchangePoolView:SetConfig(transform)

    self.config = {}
    --- @type UnityEngine_GameObject
    self.config.gameObject = transform.gameObject
    --- @type UnityEngine_Transform
    self.config.transform = transform.transform
    --- @type UnityEngine_UI_Text
    self.config.content = transform:Find("content/text_anchor/content"):GetComponent(ComponentName.UnityEngine_UI_Text)
    --- @type UnityEngine_RectTransform
    self.config.rewardAnchor = transform:Find("rewardAnchor"):GetComponent(ComponentName.UnityEngine_RectTransform)
    --- @type UnityEngine_UI_Text
    self.config.conditionText = transform:Find("content/text_anchor/condition_text"):GetComponent(ComponentName.UnityEngine_UI_Text)
end

----- @return void
----- @param parent UnityEngine_RectTransform
--function ZodiacExchangePoolView:SetParent(parent)
--    UIUtils.SetUIParent(self.config.transform, parent)
--end

--- @param stageId number
--- @param listItem List
--- @param func function(stageId,number)
function ZodiacExchangePoolView:SetData(stageId, listItem, func,model)
    --- @type EventZodiacModel
    self.eventModel = model
    self.stageId = stageId
    local canBuy = self.eventModel.exchangeStateMapServer:IsContainKey(stageId*3)
    UIUtils.SetActiveColorByMaterial(self.config.gameObject, canBuy, "ui_gray_mat")
    self:ReturnPoolItem()
    for i = 1, listItem:Count() do
        --- @type ZodiacExchangeItemView
        local item =  SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ZodiacExchangeItemView,self.config.rewardAnchor)
        --- @type ZodiacExchangeItemData
        local itemData = listItem:Get(i)
        itemData.buyTime = self.eventModel:GetNumberExchange(itemData.id)
        item:SetIconData(itemData)
        item:RegisterShowInfo()
        item:AddListener(function()
            func(stageId,itemData.id,itemData.price,item)
        end)
        self.listRewardItem:Add(item)
    end
    self:InitLocalization()
    self.config.conditionText.gameObject:SetActive(not canBuy)
end

--- @return void
function ZodiacExchangePoolView:InitLocalization()
    self.config.content.text = LanguageUtils.LocalizeCommon("star_reward_pool") .. " ".. self.stageId
    self.config.conditionText.text = LanguageUtils.LocalizeCommon("star_reward_pool_condition") .. " ".. (self.stageId - 1)
end

--- @return void
--- @param func function
function ZodiacExchangePoolView:AddListener(func)

end

--- @return void
--- @param func function
function ZodiacExchangePoolView:RemoveAllListeners(func)

end

--- @return void
function ZodiacExchangePoolView:Show()
    self.config.gameObject:SetActive(true)
end

--- @return void
function ZodiacExchangePoolView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self:ReturnPoolItem()
end


--- @return void
function ZodiacExchangePoolView:ReturnPoolItem()
    for i = 1, self.listRewardItem:Count() do
        self.listRewardItem:Get(i):ReturnPool()
    end
    self.listRewardItem:Clear()
end



--- @return void
function ZodiacExchangePoolView:ActiveEffectSelect(isActive)
    if self.iconView ~= nil then
        self.iconView:ActiveEffectSelect(isActive)
    end
end

return ZodiacExchangePoolView
