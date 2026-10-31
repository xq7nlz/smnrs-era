---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.GuildDonateHistoryItemConfig"

--- @class GuildDonateHistoryItemView : IconView
GuildDonateHistoryItemView = Class(GuildDonateHistoryItemView , IconView)

function GuildDonateHistoryItemView:Ctor()
    ---@type VipIconView
    self.avatar = nil
    ---@type List
    self.listMoney = List()
    ---@type EventGuildQuestDonationBoardInBound
    self.iconData = nil
    IconView.Ctor(self)
end

--- @return void
function GuildDonateHistoryItemView:SetPrefabName()
    self.prefabName = 'guild_donate_history_item_view'
    self.uiPoolType = UIPoolType.GuildDonateHistoryItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function GuildDonateHistoryItemView:SetConfig(transform)
    assert(transform)
    --- @type GuildDonateHistoryItemConfig
    ---@type GuildDonateHistoryItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData EventGuildQuestDonationBoardInBound
function GuildDonateHistoryItemView:SetIconData(iconData)
    self.iconData = iconData
    self.config.name.text = self.iconData.playerName
    if self.avatar == nil then
        self.avatar = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.icon)
        self.avatar:SetData2(self.iconData.avatarData:GetOtherPlayerAvatar(), self.iconData.playerLevel)
    end
    for i, v in pairs(self.iconData.moneyDict:GetItems()) do
        ---@type MoneyIconView
        local money = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, self.config.donate)
        money:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, i, v))
        self.listMoney:Add(money)
    end
end

--- @return void
function GuildDonateHistoryItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.avatar ~= nil then
        self.avatar:ReturnPool()
        self.avatar = nil
    end
    ---@param v MoneyIconView
    for _, v in pairs(self.listMoney:GetItems()) do
        v:ReturnPool()
    end
    self.listMoney:Clear()
end

return GuildDonateHistoryItemView