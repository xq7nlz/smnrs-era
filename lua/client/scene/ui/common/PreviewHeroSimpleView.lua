--- @class PreviewHeroSimpleView : UIPrefabView
PreviewHeroSimpleView = Class(PreviewHeroSimpleView, UIPrefabView)

function PreviewHeroSimpleView:Ctor()
    ---@type PreviewHeroSimpleConfig
    self.config = nil
    --- @type WorldSpaceHeroView
    self.worldSpaceHeroView = nil

    UIPrefabView.Ctor(self)
end
--- @return void
function PreviewHeroSimpleView:SetPrefabName()
    self.prefabName = 'preview_hero_simple'
    self.uiPoolType = UIPoolType.PreviewHeroSimpleView
end
--- @return void
--- @param transform UnityEngine_Transform
function PreviewHeroSimpleView:SetConfig(transform)
    --- @type LineupItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param heroId number
--- @param isSkinId boolean
function PreviewHeroSimpleView:SetHeroData(heroId, isSkinId)
    local skinId = nil
    if isSkinId then
        skinId = heroId
        heroId = ClientConfigUtils.GetHeroIdBySkinId(heroId)
    end
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        self.worldSpaceHeroView:SetSizeCamera(5)
        local renderTexture = U_RenderTexture(2000, 2000, 24, U_RenderTextureFormat.ARGB32)
        self.config.rawImageHero.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    local heroResource = HeroResource()
    heroResource:SetData(-1, heroId, 1, 1)
    if skinId ~= nil then
        heroResource.heroItem:Add(HeroItemSlot.SKIN, skinId)
    end
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(99000 - heroId, 99000, 0)
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView.config.bg:SetActive(false)
    end
end

--- @return void
function PreviewHeroSimpleView:Show()
    UIPrefabView.Show(self)
end

--- @return void
function PreviewHeroSimpleView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

return PreviewHeroSimpleView