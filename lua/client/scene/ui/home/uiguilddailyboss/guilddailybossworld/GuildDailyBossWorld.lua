---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiGuildDailyBoss.guildDailyBossWorld.GuildDailyBossWorldConfig"

--- @class GuildDailyBossWorld : BgWorldView
GuildDailyBossWorld = Class(GuildDailyBossWorld, BgWorldView)

--- @param transform UnityEngine_Transform
--- @param view UIGuildDailyBossView
function GuildDailyBossWorld:Ctor(transform, view)
    BgWorldView.Ctor(self, transform)
    --- @type UIGuildDailyBossView
    self.view = view
end

--- @param transform UnityEngine_Transform
function GuildDailyBossWorld:InitConfig(transform)
    --- @type GuildDailyBossWorldConfig
    ---@type GuildDailyBossWorldConfig
    self.config = UIBaseConfig(transform)
    self.previewHero = PreviewHero(self.config.heroAnchor)
end

function GuildDailyBossWorld:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

function GuildDailyBossWorld:Show()
    self:SetActive(true)
end

--- @param heroResource HeroResource
function GuildDailyBossWorld:SetData(heroResource)
    if heroResource == nil then
        self.previewHero:DespawnHero()
    else
        self.previewHero:PreviewHero(heroResource)
    end
end

function GuildDailyBossWorld:Hide()
    self:SetActive(false)
    self.previewHero:DespawnHero()
end