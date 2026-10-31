--- @class UIEggCombineItemView : MotionIconView
UIEggCombineItemView = Class(UIEggCombineItemView, MotionIconView)

--- @return void
function UIEggCombineItemView:Ctor()
    MotionIconView.Ctor(self)
end

--- @return void
function UIEggCombineItemView:SetPrefabName()
    self.prefabName = 'egg_combine_tab'
    self.uiPoolType = UIPoolType.UIEggCombineItemView
end

--- @return void
function UIEggCombineItemView:InitLocalization()
    self.config.textCombine.text = LanguageUtils.LocalizeCommon("combine")
    --self.config.textItemOwned.text = LanguageUtils.LocalizeCommon("owned")
    --self.config.textItemExchange.text = LanguageUtils.LocalizeCommon("item_exchange")
end

--- @return void
--- @param transform UnityEngine_Transform
function UIEggCombineItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEggCombineItemConfig
    self.config = UIBaseConfig(transform)
    self.config.buttonCombine.onClick:AddListener(function ()
        self:OnClickCombine()
    end)
end

--- @return void
--- @param exchange ExchangeEventConfig
function UIEggCombineItemView:SetData(exchange)
    ---@type ExchangeEventConfig
    self.exchange = exchange
    self.config.textCurrencyOwned.text = LanguageUtils.LocalizeMoneyType(self.exchange.itemIconData.itemId)
    self.config.textItemOwned.text = LanguageUtils.LocalizeResourceType(self.exchange.itemIconData.type)
    ---@type RootIconView
    self.itemOwn = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.iconItemOwned)
    self.itemOwn:SetIconData(self.exchange.itemIconData)
    self.itemOwn:RegisterShowInfo()
    ---@type ItemIconData
    local reward = self.exchange.listRewardItem:Get(1)
    self.config.textCurrencyName.text = LanguageUtils.LocalizeMoneyType(reward.itemId)
    self.config.textItemExchange.text = LanguageUtils.LocalizeResourceType(reward.type)
    ---@type RootIconView
    self.itemExchange = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.iconItemExchange)
    self.itemExchange:SetIconData(reward)
    self.itemExchange:RegisterShowInfo()
end

--- @return void
function UIEggCombineItemView:OnClickCombine()
    if InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(self.exchange.itemIconData.type, self.exchange.itemIconData.itemId, self.exchange.itemIconData.quantity)) then
        local listReward = nil
        local onBufferReading = function(buffer)
            listReward = NetworkUtils.GetRewardInBoundList(buffer)
        end
        local onSuccess = function()
            PopupUtils.ClaimAndShowRewardList(listReward)
            self.exchange.itemIconData:SubToInventory()
        end
        NetworkUtils.RequestAndCallback(OpCode.EVENT_EASTER_EGG_EXCHANGE,
                UnknownOutBound.CreateInstance(PutMethod.Int, 1, PutMethod.Int, self.exchange.id),
                onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
    end
end

--- @return void
function UIEggCombineItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
end

return UIEggCombineItemView