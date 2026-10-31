---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.QuickBattleItemConfig"

--- @class QuickBattleItemView : IconView
QuickBattleItemView = Class(QuickBattleItemView, IconView)

--- @return void
function QuickBattleItemView:Ctor()
    ---@type QuickBattleTicketData
    self.quickBattleTicketData = nil
    ---@type ItemIconView
    self.iconView = nil
    self.quantity = 0
    self.localizeUse = nil
    IconView.Ctor(self)
end

--- @return void
function QuickBattleItemView:SetPrefabName()
    self.prefabName = 'item_quick_battle'
    self.uiPoolType = UIPoolType.QuickBattleItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function QuickBattleItemView:SetConfig(transform)
    assert(transform)
    --- @type QuickBattleItemConfig
    ---@type QuickBattleItemConfig
    self.config = UIBaseConfig(transform)
    self.config.useButton.onClick:AddListener(function ()
        self:OnClickUse()
    end)
end

--- @return void
function QuickBattleItemView:InitLocalization()
    self.localizeUse = LanguageUtils.LocalizeCommon("use")
    self.config.textUse.text = self.localizeUse
    self.config.textNotEnough.text = LanguageUtils.LocalizeCommon("not_enough")
end

--- @return void
--- @param iconData QuickBattleTicketData
function QuickBattleItemView:SetIconData(iconData)
    assert(iconData)
    --- @type QuickBattleTicketData
    self.quickBattleTicketData = iconData
    self:UpdateView()
end

--- @return void
function QuickBattleItemView:UpdateView()
    self.config.textSpeedUpName.text = LanguageUtils.LocalizeQuickBattleTicket(self.quickBattleTicketData)
    if self.iconView == nil then
        self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView , self.config.item)
        self.iconView:RegisterShowInfo()
    end
    self.iconView:SetIconData(ItemIconData.CreateInstance(ResourceType.CampaignQuickBattleTicket, self.quickBattleTicketData.id, nil))
    self.quantity = InventoryUtils.Get(ResourceType.CampaignQuickBattleTicket, self.quickBattleTicketData.id)
    local color = nil
    if self.quantity > 0 then
        self.config.useButton.gameObject:SetActive(true)
        self.config.notEnough:SetActive(false)
        color = UIUtils.color2
    else
        self.config.useButton.gameObject:SetActive(false)
        self.config.notEnough:SetActive(true)
        color = UIUtils.color7
    end
    self.config.textSpeedUpOwnedValue.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("owned_x"),
            UIUtils.SetColorString(color, self.quantity))
end

--- @return void
function QuickBattleItemView:OnClickUse()
    ---@type PopupUseItemData
    local data ={}
    data.title = self.config.textSpeedUpName.text
    data.textButton = self.localizeUse
    data.minInput = 1
    data.maxInput = self.quantity
    if self.quantity > self.quickBattleTicketData.limitUse then
        data.maxInput = self.quickBattleTicketData.limitUse
    end
    data.createItem = function(transform)
        ---@type IconView
        local itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.QuickBattleTicketView, transform)
        itemView:SetIconData(ItemIconData.CreateInstance(ResourceType.CampaignQuickBattleTicket, self.quickBattleTicketData.id, nil))
        return itemView
    end
    data.callbackUse = function(number)
        self:RequestQuickBattleTicket(self.quickBattleTicketData.id, number)
    end
    PopupMgr.ShowPopup(UIPopupName.UIPopupUseItem, data)
end

--- @return void
function QuickBattleItemView:RequestQuickBattleTicket(id, number)
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
        self:UpdateView()
        PopupUtils.ShowRewardList(RewardInBound.GetItemIconDataList(listReward))
        ClientConfigUtils.CheckLevelUpAndUnlockFeature()
    end
    NetworkUtils.RequestAndCallback(OpCode.CAMPAIGN_QUICK_BATTLE_TICKET_USE,
            UnknownOutBound.CreateInstance(PutMethod.Int, id, PutMethod.Short, number),
            onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
end

--- @return void
function QuickBattleItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.iconView ~= nil then
        self.iconView:ReturnPool()
        self.iconView = nil
    end
    self.quickBattleTicketData = nil
end

return QuickBattleItemView

