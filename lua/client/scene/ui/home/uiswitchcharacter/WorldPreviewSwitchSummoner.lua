---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiSwitchCharacter.WorldPreviewSwitchSummonerConfig"

--- @class WorldPreviewSwitchSummoner : BgWorldView
WorldPreviewSwitchSummoner = Class(WorldPreviewSwitchSummoner, BgWorldView)

--- @param transform UnityEngine_Transform
function WorldPreviewSwitchSummoner:Ctor(transform)
    BgWorldView.Ctor(self, transform)
end

function WorldPreviewSwitchSummoner:InitConfig(transform)
    --- @type WorldPreviewSwitchSummonerConfig
    ---@type WorldPreviewSwitchSummonerConfig
    self.config = UIBaseConfig(transform)
    --- @type PreviewHero
    self.previewHero = PreviewHero(self.config.summonerAnchor)
end

function WorldPreviewSwitchSummoner:OnShow()
    self:SetActive(true)
end

--- @param heroId number
--- @param star number
function WorldPreviewSwitchSummoner:ShowHero(heroId, star)
    local heroResource = HeroResource()
    heroResource.heroId = heroId
    heroResource.heroStar = star

    self.previewHero:PreviewHero(heroResource)
end

function WorldPreviewSwitchSummoner:OnHide()
    self:SetActive(false)
    self.previewHero:OnHide()
end