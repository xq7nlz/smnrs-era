--- @class UIInventoryMoneyView
UIInventoryMoneyView = Class(UIInventoryMoneyView)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIInventoryView
function UIInventoryMoneyView:Ctor(view, transform, model)
    --- @type UIInventoryView
    self.view = view
    ---@type UIInventoryModel
    self.model = model
    ---@type List --<id>
    self.itemDic = List()

    ---@type List --<id>
    self.quickBattleTicket = List()

    ---@type Dictionary
    self.eventItemDictConfig = Dictionary()

    -- UI
    ---@type UIInventoryMoneyConfig
    ---@type UIInventoryMoneyConfig
    self.config = UIBaseConfig(transform)

    --- @param obj RootIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        if index < self.itemDic:Count() then
            local type = ResourceType.Money
            local id = self.itemDic:Get(index + 1)
            local number = InventoryUtils.Get(type, id)

            self.eventItemDictConfig = ClientConfigUtils.GetEventItemConfig()
            if self.eventItemDictConfig:IsContainKey(id) then
                local value = self.eventItemDictConfig:Get(id)
                local eventModel = zg.playerData:GetEvents():GetEvent(value)
                if value ~= nil and zg.playerData:GetEvents():GetEvent(value) ~= nil then
                    if not eventModel:IsOpening() then
                        obj.config.gameObject:SetActive(false)
                    end
                else
                    obj.config.gameObject:SetActive(true)
                end
            end
            obj:SetIconData(ItemIconData.CreateInstance(type, id, number))
            if id == MoneyType.EVENT_CHRISTMAS_BOX then
                obj:RemoveAllListeners()
                obj:ActiveNotification(true)
                obj:AddListener(function()
                    self:UseBoxXmas(number)
                end)
            elseif ClientConfigUtils.IsEventSeasonalChest(id) then
                obj:RemoveAllListeners()
                obj:ActiveNotification(true)
                obj:AddListener(function()
                    self:UseEventSeasonalChest(id, number)
                end)
            elseif ClientConfigUtils.IsDomainChestMoney(id) then
                obj:RemoveAllListeners()
                obj:ActiveNotification(true)
                obj:AddListener(function()
                    self:UseDomainChest(id, number)
                end)
            elseif ClientConfigUtils.IsDomainArenaChestMoney(id) then
                obj:RemoveAllListeners()
                obj:ActiveNotification(true)
                obj:AddListener(function()
                    self:UseDomainArenaChest(id, number)
                end)
            elseif ClientConfigUtils.IsHeroSelectionChestMoney(id) then
                obj:RemoveAllListeners()
                obj:ActiveNotification(true)
                obj:AddListener(function()
                    self:UseHeroSelectionChest(id)
                end)
            elseif ClientConfigUtils.IsArtifactSelectionChestMoney(id) then
                obj:RemoveAllListeners()
                obj:ActiveNotification(true)
                obj:AddListener(function()
                    self:UseArtifactSelectionChest(id)
                end)
            else
                obj:RegisterShowInfo()
            end
        else
            ---@type HeroFood
            local heroFood = zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD).listHeroFood
                               :Get(index - self.itemDic:Count() + 1)
            obj:SetIconData(ItemIconData.CreateBuyHeroFood(heroFood.heroFoodType, heroFood.star, heroFood.number))
            obj:RegisterShowInfo()
        end
    end
    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem, onCreateItem)
end

--- @return void
function UIInventoryMoneyView:Show()
    local currencyCollectionConfig = ResourceMgr.GetCurrencyCollectionConfig()
    local listIgnoreBuyEvent = ResourceMgr.GetCurrencyEventConfig():GetListCurrencyIgnore()
    self.itemDic:Clear()
    ---@type List
    local moneyList = InventoryUtils.GetListResource(ResourceType.Money)
    for _, v in pairs(moneyList:GetItems()) do
        if currencyCollectionConfig:IsContainMoneyType(v) and listIgnoreBuyEvent:IsContainValue(v) == false then
            self.itemDic:Add(v)
        end
    end

    local itemCount = self.itemDic:Count() + zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD).listHeroFood:Count()
    self.uiScroll:Resize(itemCount)
    self.view:EnableEmpty(itemCount == 0)
end

--- @return void
function UIInventoryMoneyView:UseQuickBattle(id, number)
    local localizeUse = LanguageUtils.LocalizeCommon("use")
    local buttonUse = { ["name"] = localizeUse, ["callback"] = function()
        ---@type PopupUseItemData
        local data = {}
        data.textButton = localizeUse
        data.minInput = 1
        data.maxInput = number
        data.createItem = function(transform)
            ---@type IconView
            local itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.QuickBattleTicketView, transform)
            itemView:SetIconData(ItemIconData.CreateInstance(ResourceType.CampaignQuickBattleTicket, id, nil))
            return itemView
        end
        data.callbackUse = function(number)
            self:RequestQuickBattleTicket(id, number)
        end
        PopupMgr.HidePopup(UIPopupName.UIItemPreview)
        PopupMgr.ShowPopup(UIPopupName.UIPopupUseItem, data)
    end }
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = ResourceType.CampaignQuickBattleTicket, ["id"] = id, ["button2"] = buttonUse } })
end

--- @return void
function UIInventoryMoneyView:RequestQuickBattleTicket(id, number)
    ---@type List --<RewardInBound>
    local listReward = nil
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        listReward = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupUseItem)
        InventoryUtils.Sub(ResourceType.CampaignQuickBattleTicket, id, number)
        ---@param v RewardInBound
        for _, v in pairs(listReward:GetItems()) do
            v:AddToInventory()
        end
        self:Show()
        PopupUtils.ShowRewardList(RewardInBound.GetItemIconDataList(listReward))
        ClientConfigUtils.CheckLevelUpAndUnlockFeature()
    end
    NetworkUtils.RequestAndCallback(OpCode.CAMPAIGN_QUICK_BATTLE_TICKET_USE,
            UnknownOutBound.CreateInstance(PutMethod.Int, id, PutMethod.Short, number),
            onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
end

--- @return void
function UIInventoryMoneyView:UseBoxXmas(number)
    local localizeUse = LanguageUtils.LocalizeCommon("use")
    local buttonUse = { ["name"] = localizeUse, ["callback"] = function()
        ---@type PopupUseItemData
        local data = {}
        data.title = LanguageUtils.LocalizeMoneyType(MoneyType.EVENT_CHRISTMAS_BOX)
        data.textButton = localizeUse
        data.minInput = 1
        data.maxInput = number
        data.createItem = function(transform)
            ---@type IconView
            local itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, transform)
            itemView:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_BOX, nil))
            return itemView
        end
        data.callbackUse = function(number)
            self:RequestBoxXmas(number)
        end
        PopupMgr.HidePopup(UIPopupName.UIItemPreview)
        PopupMgr.ShowPopup(UIPopupName.UIPopupUseItem, data)
    end }
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = ResourceType.Money, ["id"] = MoneyType.EVENT_CHRISTMAS_BOX, ["button2"] = buttonUse } })
end

--- @return void
function UIInventoryMoneyView:RequestBoxXmas(number)
    ---@type List --<RewardInBound>
    local listReward = nil
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        listReward = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupUseItem)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_BOX, number)
        ---@param v RewardInBound
        for _, v in pairs(listReward:GetItems()) do
            v:AddToInventory()
        end
        self:Show()
        PopupUtils.ShowRewardList(RewardInBound.GetItemIconDataList(listReward))
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_CHRISTMAS_BOX_OPEN,
            UnknownOutBound.CreateInstance(PutMethod.Int, number),
            onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
end

--- @return void
function UIInventoryMoneyView:UseEventSeasonalChest(id, number)
    local localizeUse = LanguageUtils.LocalizeCommon("use")
    local buttonUse = { ["name"] = localizeUse, ["callback"] = function()
        ---@type PopupUseItemData
        local data = {}
        data.title = LanguageUtils.LocalizeMoneyType(id)
        data.textButton = localizeUse
        data.minInput = 1
        data.maxInput = number
        data.createItem = function(transform)
            ---@type IconView
            local itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, transform)
            itemView:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, id, nil))
            return itemView
        end
        data.callbackUse = function(number)
            self:RequestOpenChestSeasonal(id, number)
        end
        PopupMgr.HidePopup(UIPopupName.UIItemPreview)
        PopupMgr.ShowPopup(UIPopupName.UIPopupUseItem, data)
    end }
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = ResourceType.Money, ["id"] = id, ["button2"] = buttonUse } })
end

--- @return void
function UIInventoryMoneyView:RequestOpenChestSeasonal(id, number)
    ---@type List --<RewardInBound>
    local listReward = List()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        listReward = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupUseItem)
        InventoryUtils.Sub(ResourceType.Money, id, number)
        ---@param v RewardInBound
        for _, v in pairs(listReward:GetItems()) do
            v:AddToInventory()
        end
        self:Show()
        PopupUtils.ShowRewardList(RewardInBound.GetItemIconDataList(listReward))
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_GIFT_BOX_OPEN, UnknownOutBound.CreateInstance(PutMethod.Int, number), onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
end

--- @return void
function UIInventoryMoneyView:Hide()
    self.uiScroll:Hide()
end

--- @return void
function UIInventoryMoneyView:UseDomainChest(moneyType, number)
    local localizeUse = LanguageUtils.LocalizeCommon("use")
    local buttonUse = { ["name"] = localizeUse, ["callback"] = function()
        ---@type PopupUseItemData
        local data = {}
        data.title = LanguageUtils.LocalizeMoneyType(moneyType)
        data.textButton = localizeUse
        data.minInput = 1
        data.maxInput = number
        data.createItem = function(transform)
            ---@type IconView
            local itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, transform)
            itemView:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, moneyType, nil))
            return itemView
        end
        data.callbackUse = function(number)
            self:RequestBoxDomainChest(moneyType, number)
        end
        PopupMgr.HidePopup(UIPopupName.UIItemPreview)
        PopupMgr.ShowPopup(UIPopupName.UIPopupUseItem, data)
    end }
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = ResourceType.Money, ["id"] = moneyType, ["button2"] = buttonUse } })
end

--- @return void
function UIInventoryMoneyView:UseDomainArenaChest(moneyType, number)
    local localizeUse = LanguageUtils.LocalizeCommon("use")
    local buttonUse = { ["name"] = localizeUse, ["callback"] = function()
        ---@type PopupUseItemData
        local data = {}
        data.title = LanguageUtils.LocalizeMoneyType(moneyType)
        data.textButton = localizeUse
        data.minInput = 1
        data.maxInput = number
        data.createItem = function(transform)
            ---@type IconView
            local itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, transform)
            itemView:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, moneyType, nil))
            return itemView
        end
        data.callbackUse = function(number)
            self:OpenBoxArenaChestChooseReward(moneyType, number)
        end
        PopupMgr.HidePopup(UIPopupName.UIItemPreview)
        PopupMgr.ShowPopup(UIPopupName.UIPopupUseItem, data)
    end }
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = ResourceType.Money, ["id"] = moneyType, ["button2"] = buttonUse } })
end

--- @return void
function UIInventoryMoneyView:RequestBoxDomainChest(moneyType, number)
    ---@type List --<RewardInBound>
    local listReward = nil
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        listReward = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupUseItem)
        InventoryUtils.Sub(ResourceType.Money, moneyType, number)
        ---@param v RewardInBound
        for _, v in pairs(listReward:GetItems()) do
            v:AddToInventory()
        end
        self:Show()
        PopupUtils.ShowRewardList(RewardInBound.GetItemIconDataList(listReward))
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_OPEN_CHEST,
            UnknownOutBound.CreateInstance(PutMethod.Int, moneyType, PutMethod.Int, number),
            onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
end

--- @return void
function UIInventoryMoneyView:OpenBoxArenaChestChooseReward(moneyType, number)

    local data = {}
    data.chestNumber = number
    ---@type List --<RewardInBound>
    data.listReward = List()
    data.listReward = ResourceMgr.GetArenaRewardRankingConfig():GetArenaChestRewardConfig(moneyType)
    ---@type List --<RewardInBound>
    local listReward = nil
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        listReward = NetworkUtils.GetRewardInBoundList(buffer)
    end
    local numberSelection = 0
    local onSuccess = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupUseItem)
        PopupMgr.HidePopup(UIPopupName.UIChooseRewardChestArena)
        ---@param v RewardInBound
        for _, v in pairs(listReward:GetItems()) do
            v:AddToInventory()
        end
        InventoryUtils.Sub(ResourceType.Money, moneyType, numberSelection)
        self:Show()
        PopupUtils.ShowRewardList(RewardInBound.GetItemIconDataList(listReward))
    end
    data.onClaimClick = function(rewardDict)
        for k, v in pairs(rewardDict:GetItems()) do
            numberSelection = numberSelection + v
        end
        require("lua.client.core.network.event.ArenaChestOpenOutBound")
        NetworkUtils.RequestAndCallback(OpCode.ARENA_CHEST_OPEN,
                ArenaChestOpenOutBound(moneyType, numberSelection, rewardDict),
                onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
    end
    PopupMgr.ShowPopup(UIPopupName.UIChooseRewardChestArena, data)
end

--- @return void
function UIInventoryMoneyView:UseHeroSelectionChest(moneyType)
    local localizeUse = LanguageUtils.LocalizeCommon("use")
    local buttonUse = { ["name"] = localizeUse, ["callback"] = function()
        ---@type PopupUseItemData
        local data = {}
        data.textItemPool = LanguageUtils.LocalizeCommon("select_hero_pool")
        data.listItem = List()
        data.listItem = ResourceMgr.GetHeroChestRewardConfig():GetChestNormalHeroRewardConfig(moneyType)
        data.minSelect = 1
        data.maxSelect = 1
        data.callbackSelect = function(listItemSelected)
            self:RequestHeroSelectionChest(moneyType, listItemSelected)
        end
        PopupMgr.HidePopup(UIPopupName.UIItemPreview)
        PopupMgr.ShowPopup(UIPopupName.UISelectItemPool, data)
    end }
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = ResourceType.Money, ["id"] = moneyType, ["button2"] = buttonUse } })
end

--- @return void
function UIInventoryMoneyView:RequestHeroSelectionChest(moneyType, listItemSelected)
    ---@type List --<RewardInBound>
    local listReward = nil
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        listReward = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        PopupMgr.HidePopup(UIPopupName.UISelectItemPool)
        InventoryUtils.Sub(ResourceType.Money, moneyType, 1)
        ---@param v RewardInBound
        for _, v in pairs(listReward:GetItems()) do
            v:AddToInventory()
        end
        self:Show()
        PopupUtils.ShowRewardList(RewardInBound.GetItemIconDataList(listReward))
    end
    require "lua.client.data.Item.HeroChest.HeroChestRewardOutBound"
    NetworkUtils.RequestAndCallback(OpCode.HERO_SELECTION_CHEST,
            HeroChestRewardOutbound(moneyType, 1, listItemSelected),
            onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
end

--- @return void
function UIInventoryMoneyView:UseArtifactSelectionChest(moneyType)
    local localizeUse = LanguageUtils.LocalizeCommon("use")
    local buttonUse = { ["name"] = localizeUse, ["callback"] = function()
        ---@type PopupUseItemData
        local data = {}
        data.textItemPool = LanguageUtils.LocalizeCommon("select_artifact_pool")
        data.listItem = List()
        data.listItem = ResourceMgr.GetArtifactChestRewardConfig():GetChestArtifactRewardConfig(moneyType)
        data.minSelect = 1
        data.maxSelect = 1
        data.callbackSelect = function(listItemSelected)
            self:RequestArtifactSelectionChest(moneyType, listItemSelected)
        end
        PopupMgr.HidePopup(UIPopupName.UIItemPreview)
        PopupMgr.ShowPopup(UIPopupName.UISelectItemPool, data)
    end }
    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = ResourceType.Money, ["id"] = moneyType, ["button2"] = buttonUse } })
end

--- @return void
function UIInventoryMoneyView:RequestArtifactSelectionChest(moneyType, listItemSelected)
    ---@type List --<RewardInBound>
    local listReward = nil
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        listReward = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        PopupMgr.HidePopup(UIPopupName.UISelectItemPool)
        InventoryUtils.Sub(ResourceType.Money, moneyType, 1)
        ---@param v RewardInBound
        for _, v in pairs(listReward:GetItems()) do
            v:AddToInventory()
        end
        self:Show()
        PopupUtils.ShowRewardList(RewardInBound.GetItemIconDataList(listReward))
    end
    require "lua.client.data.Item.ArtifactChest.ArtifactChestRewardOutBound"
    NetworkUtils.RequestAndCallback(OpCode.ARTIFACT_SELECTION_CHEST,
            ArtifactChestRewardOutbound(moneyType, 1, listItemSelected),
            onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
end