--- @class PreviewReplaceHero : BgWorldView
PreviewReplaceHero = Class(PreviewReplaceHero, BgWorldView)

--- @param transform UnityEngine_Transform
function PreviewReplaceHero:Ctor(transform)
    BgWorldView.Ctor(self, transform)
    self:InitView()
end

function PreviewReplaceHero:InitConfig(transform)
    ---@type PreviewReplaceHeroConfig
    self.config = UIBaseConfig(transform)
end

function PreviewReplaceHero:InitView()
    --- @type PreviewHero
    self.previewHeroSource = PreviewHero(self.config.sourceAnchor.transform)
    --- @type PreviewHero
    self.previewHeroReplaced = PreviewHero(self.config.replacedAnchor.transform)
end

--- @param heroResource HeroResource
function PreviewReplaceHero:ShowSourceHero(heroResource)
    local onSpawned = function()
        if self.config.fxShowSource.isPlaying == true then
            self.config.fxShowSource:Stop()
        end
        self.config.fxShowSource:Play()
        zg.audioMgr:PlaySfxUi(SfxUiType.PROPHET_TREE_SELECT_HERO)
    end
    self:_ShowHero(true, heroResource, onSpawned)
end

--- @param heroResource HeroResource
function PreviewReplaceHero:ShowReplacedHero(heroResource)
    local onSpawned = function()
        if self.config.fxReplace.isPlaying == true then
            self.config.fxReplace:Stop()
        end
        self.config.fxReplace:Play()
        zg.audioMgr:PlaySfxUi(SfxUiType.PROPHET_TREE_SELECT_HERO)
    end
    self:_ShowHero(false, heroResource, onSpawned)
end

--- @param heroResource HeroResource
--- @param isSource boolean
function PreviewReplaceHero:_ShowHero(isSource, heroResource, onFinish)
    if isSource then
        self:RemoveSourceHero()
        self.previewHeroSource:PreviewHeroAsync(heroResource, nil, onFinish)
    else
        self:RemoveReplacedHero()
        self.previewHeroReplaced:PreviewHeroAsync(heroResource, nil, onFinish)
    end
end

--- @return void
function PreviewReplaceHero:OnShow()
    self:SetActive(true)
end

--- @return void
function PreviewReplaceHero:OnHide()
    self:RemoveSourceHero()
    self:RemoveReplacedHero()
    self:SetActive(false)
end

function PreviewReplaceHero:RemoveSourceHero()
    self.previewHeroSource:DespawnHero()
end

function PreviewReplaceHero:RemoveReplacedHero()
    self.previewHeroReplaced:DespawnHero()
end
