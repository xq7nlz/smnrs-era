---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiGuildDailyBoss.guildDailyBossMilestoneReward.GuildDailyBossMilestoneRewardConfig"

--- @class GuildDailyBossMilestoneReward : IconView
GuildDailyBossMilestoneReward = Class(GuildDailyBossMilestoneReward, IconView)

function GuildDailyBossMilestoneReward:Ctor()
    IconView.Ctor(self)
end

function GuildDailyBossMilestoneReward:SetPrefabName()
    self.prefabName = 'guild_daily_boss_reward_milestone'
    self.uiPoolType = UIPoolType.GuildDailyBossMilestoneReward
end

--- @param transform UnityEngine_Transform
function GuildDailyBossMilestoneReward:SetConfig(transform)
    --- @type GuildDailyBossMilestoneRewardConfig
    ---@type GuildDailyBossMilestoneRewardConfig
    self.config = UIBaseConfig(transform)
end

--- @param tier number
--- @param minDamage number
function GuildDailyBossMilestoneReward:SetData(tier, minDamage)
    self.config.textValue.text = ClientConfigUtils.FormatNumber(minDamage)
    local sprite = ResourceLoadUtils.LoadChestIcon(tier)
    if sprite ~= nil then
        self.config.iconChest.sprite = sprite
    end
end

--- @param isEnable boolean
function GuildDailyBossMilestoneReward:EnableHighlight(isEnable)
    self.config.on:SetActive(isEnable)
end

--- @param func function
function GuildDailyBossMilestoneReward:AddSelectListener(func)
    self.config.chestMilestone.onClick:RemoveAllListeners()
    self.config.chestMilestone.onClick:AddListener(function ()
        if func ~= nil then
            func()
        end
    end)
end

return GuildDailyBossMilestoneReward