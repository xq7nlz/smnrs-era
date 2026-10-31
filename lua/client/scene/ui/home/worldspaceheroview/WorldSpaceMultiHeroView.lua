--- @class WorldSpaceMultiHeroView : WorldSpaceHeroView
WorldSpaceMultiHeroView = Class(WorldSpaceMultiHeroView, WorldSpaceHeroView)

--- @param transform UnityEngine_Transform
function WorldSpaceMultiHeroView:Ctor(transform)
    --- @type WorldSpaceMultiHeroViewConfig
    self.config = UIBaseConfig(transform)
    self.config.gameObject:SetActive(true)

    self.previewHeroDict = Dictionary()

    self:InitPreviewHeroDict()
end

function WorldSpaceMultiHeroView:InitPreviewHeroDict()
    self.previewHeroDict:Add(1, PreviewHero(self.config.heroAnchor1))
    self.previewHeroDict:Add(2, PreviewHero(self.config.heroAnchor2))
    self.previewHeroDict:Add(3, PreviewHero(self.config.heroAnchor3))
end

--- @return PreviewHero
function WorldSpaceMultiHeroView:GetPreviewHeroBySlot(index)
    return self.previewHeroDict:Get(index)
end

--- @param heroResource HeroResource
function WorldSpaceMultiHeroView:ShowHeroByIndex(index, heroResource)
    local previewHero = self:GetPreviewHeroBySlot(index)
    if previewHero and heroResource ~= nil then
        previewHero:PreviewHero(heroResource)
    end
end

function WorldSpaceMultiHeroView:OnHide()
    --- @param v PreviewHero
    for _, v in pairs(self.previewHeroDict:GetItems()) do
        v:OnHide()
    end
    SmartPool.Instance:DespawnGameObject(AssetType.Battle, "world_space_multi_hero_view", self.config.transform)
end

function WorldSpaceMultiHeroView:SetAnchorTransform(index, position, scale)
    local previewHero = self:GetPreviewHeroBySlot(index)
    if previewHero then
        previewHero:SetTransformStat(position, scale)
    end
end