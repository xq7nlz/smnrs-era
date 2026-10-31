---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.DamageStatItemConfig"
require "lua.client.scene.ui.common.UIBarPercentView"

--- @class DamageStatItemView : IconView
DamageStatItemView = Class(DamageStatItemView, IconView)

--- @return void
function DamageStatItemView:Ctor()
    ---@type VipIconView
    self.heroIconView = nil
    ---@type BossStatistics
    self.bossStatistics = nil
    ---@type number
    self.index = nil
    ---@type number
    self.maxDamage = nil
    ---@type UIBarPercentView
    self.barPercent = nil
    IconView.Ctor(self)
end

--- @return void
function DamageStatItemView:SetPrefabName()
    self.prefabName = 'damage_stat_item_view'
    self.uiPoolType = UIPoolType.DamageStatItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function DamageStatItemView:SetConfig(transform)
    --- @type DamageStatItemConfig
    ---@type DamageStatItemConfig
    self.config = UIBaseConfig(transform)
    self.barPercent = UIBarPercentView(self.config.progressAnchor)
end

--- @param rank number
--- @param playerName string
--- @param playerAvatar number
--- @param playerLevel number
--- @param damage number
--- @param maxDamage number
function DamageStatItemView:SetData(rank, playerName, playerAvatar, playerLevel, damage, maxDamage)
    self.config.textLeaderBoardTop.text = tostring(rank)
    self.config.textUserName.text = playerName
    self:SetIconHero(playerAvatar, playerLevel)
    self:SetIconLeaderBoard(rank)
    self:UpdatePercentBar(damage, maxDamage)
end

function DamageStatItemView:SetIconHero(playerAvatar, playerLevel)
    if self.heroIconView == nil then
        self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.heroSlot)
    end
    self.heroIconView:SetData2(playerAvatar, playerLevel)
    self.heroIconView:RemoveAllListeners()
end

function DamageStatItemView:UpdatePercentBar(damage, maxDamage)
    local percent = 0
    if maxDamage > 0 then
        percent = damage / maxDamage
    end

    self.barPercent:SetPercent(percent)
    local content = string.format("%s/%s (%s)", UIUtils.SetColorString(UIUtils.white, damage),
            maxDamage,
            string.format("%.1f%s", percent * 100, "%"))
    self.barPercent:SetText(content)
end

function DamageStatItemView:SetIconLeaderBoard(rank)
    if rank <= 3 then
        self.config.iconLeaderBoardTop1.sprite = ResourceLoadUtils.LoadTopRankingIcon(rank)
        self.config.iconLeaderBoardTop1.gameObject:SetActive(true)
        self.config.iconLeaderBoardTop1:SetNativeSize()
    else
        self.config.iconLeaderBoardTop1.gameObject:SetActive(false)
    end
end

--- @return void
---@param guildDungeonStatisticsInBound GuildDungeonStatisticsInBound
function DamageStatItemView:SetGuildDungeonStatisticData(guildDungeonStatisticsInBound, index, maxDamage)
    self.index = index
    self.maxDamage = maxDamage
    self:UpdateUI(guildDungeonStatisticsInBound.playerName, guildDungeonStatisticsInBound.playerAvatar,
            guildDungeonStatisticsInBound.playerLevel, guildDungeonStatisticsInBound.playerScore)
end

--- @return void
function DamageStatItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
end

return DamageStatItemView