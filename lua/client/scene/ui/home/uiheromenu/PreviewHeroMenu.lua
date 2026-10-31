--- @class PreviewHeroMenu : BgWorldView
PreviewHeroMenu = Class(PreviewHeroMenu, BgWorldView)
--- @type UnityEngine_Quaternion
local U_Quaternion = UnityEngine.Quaternion

function PreviewHeroMenu:Ctor()
    --- @type UnityEngine_Transform
    self._bgHeroInfo = nil
    --- @type string
    self._bgName = nil
    self:SetPrefabName()
    self:SetConfig(self:GetTransform())

    BgWorldView.Ctor(self, self.config.transform)
end

function PreviewHeroMenu:SetPrefabName()
    self.prefabName = 'preview_hero_menu'
end

function PreviewHeroMenu:SetConfig(transform)
    self:InitConfig(transform)
end

function PreviewHeroMenu:InitConfig(transform)
    --- @type PreviewHeroMenuConfig
    self.config = UIBaseConfig(transform)
    --- @type PreviewHero
    self.previewHero = PreviewHero(self.config.heroAnchor)
end

function PreviewHeroMenu:GetScale(heroResource)
    self.previewHero:GetScale(heroResource)
end

function PreviewHeroMenu:PlayAttackAnimation()
    self.previewHero:PlayAttackAnimation()
end

function PreviewHeroMenu:LevelUp()
    self:PlayParticle(self.config.fxLevelUp)
end

function PreviewHeroMenu:LevelUpMax()
    self:PlayParticle(self.config.fxLevelUpMax)
end

function PreviewHeroMenu:Evolve()
    self:PlayParticle(self.config.fxEvolve)
end

function PreviewHeroMenu:Awaken()
    self:PlayParticle(self.config.fxAwaken)
end

--- @param particle UnityEngine_ParticleSystem
function PreviewHeroMenu:PlayParticle(particle)
    if particle.isPlaying == true then
        particle:Stop()
    end
    particle:Play()
end

function PreviewHeroMenu:OnShow()
    self:SetActive(true)
    --- fix scale trong prefab
    --self.config.heroAnchor.localScale = U_Vector3(2,2,1)
end

function PreviewHeroMenu:OnHide()
    BgWorldView.OnHide(self)
    self.previewHero:DespawnHero()
    self:DeSpawnBg()
    self:SetDefaultHeroScale()
    self:DespawnFxChangeHero()
end

function PreviewHeroMenu:DeSpawnBg()
    if self._bgHeroInfo ~= nil and self._bgName ~= nil then
        SmartPool.Instance:DespawnGameObject(AssetType.Background, self._bgName, self._bgHeroInfo)
        self._bgHeroInfo = nil
        self._bgName = nil
    end
end

--- @param heroId number
function PreviewHeroMenu:ShowFxChangeSkin(heroId)
    local factionId = ClientConfigUtils.GetFactionIdByHeroId(heroId)
    self:DespawnFxChangeHero()
    self.fxFactionHeroName = "vfx_heroinfo_" .. factionId
    self.fxFactionHero = SmartPool.Instance:SpawnTransform(AssetType.UI, self.fxFactionHeroName)
    self.fxFactionHero.position = self.config.transform.position
end

function PreviewHeroMenu:DespawnFxChangeHero()
    if self.fxFactionHero ~= nil and self.fxFactionHeroName ~= nil then
        SmartPool.Instance:DespawnGameObject(AssetType.UI, self.fxFactionHeroName, self.fxFactionHero)
        self.fxFactionHero = nil
        self.fxFactionHeroName = nil
    end
end

--- @param heroResource HeroResource
--- @param heroModelType HeroModelType
function PreviewHeroMenu:PreviewHero(heroResource, heroModelType, onFinish)
    self.previewHero:PreviewHeroAsync(heroResource, heroModelType, onFinish)
    --self:SetPreviewHeroScale(ResourceMgr.GetHeroMenuConfig().heroScaleDict:Get(heroResource.heroId))
end

--- @param heroResource HeroResource
--- @param heroModelType HeroModelType
function PreviewHeroMenu:PreviewHeroNormal(heroResource, heroModelType, onFinish)
    self.previewHero:PreviewHero(heroResource, heroModelType, onFinish)
    --self:SetPreviewHeroScale(ResourceMgr.GetHeroMenuConfig().heroScaleDict:Get(heroResource.heroId))
end

--- @param factionType HeroFactionType
--- @param previewHeroBgAnchorType PreviewHeroBgAnchorType
function PreviewHeroMenu:UpdateFactionBackground(factionType, previewHeroBgAnchorType, useNewBg)
    local bgName = string.format("bg_hero_info_%d", factionType)
    if useNewBg == true then
        bgName = bgName .. "_new"
    end
    if bgName == self._bgName then
        return
    end
    self:DeSpawnBg()
    self:SetBgHeroMenuByName(bgName, previewHeroBgAnchorType)
end

-- ---@return U_Vector3
--- @param previewHeroBgAnchorType PreviewHeroBgAnchorType
------ @param dataId number
function PreviewHeroMenu.GetPreviewHeroPositionByType(previewHeroBgAnchorType, dataId)
    if (previewHeroBgAnchorType == PreviewHeroBgAnchorType.EventNewHeroSummon) then
        if (dataId ~= nil and dataId == 7) then --nero only
            return U_Vector3(0, -1.5, 0)
        elseif dataId == 2 then
            return U_Vector3(0, -3, 0)
        elseif dataId == 9 then
            return U_Vector3(0, -1.95, 0)
        else
            return U_Vector3(0, -2.46, 0)
        end
    elseif (previewHeroBgAnchorType == PreviewHeroBgAnchorType.HeroInfo) then
        return U_Vector3(0, -2.52, 0)
    elseif (previewHeroBgAnchorType == PreviewHeroBgAnchorType.HeroEvolve) then
        return U_Vector3(1.5, -2.6, 0)
    elseif (previewHeroBgAnchorType == PreviewHeroBgAnchorType.HeroSkin) then
        return U_Vector3(1.26, -2.84, 0)
    elseif (previewHeroBgAnchorType == PreviewHeroBgAnchorType.IdleEffect) then
        return U_Vector3(1.26, -2.84, 0)
    elseif (previewHeroBgAnchorType == PreviewHeroBgAnchorType.HeroSummon) then
        return U_Vector3(-5.27, -3.54, 0)
    elseif (previewHeroBgAnchorType == PreviewHeroBgAnchorType.RightCorner) then
        return U_Vector3(4.25, -1.25, 0)
    else
    end
end

--- @param scale number
--- Set scale of hero
function PreviewHeroMenu:SetPreviewHeroScale(scale)
    if (scale ~= nil) then
        self.previewHero:SetScale(scale)
    end
end

--- @param scale number
--- Set scale of hero
function PreviewHeroMenu:SetDefaultHeroScale()
    self.previewHero:SetDefaultHeroScale()
end

--- @param bgName string
--- @param previewHeroBgAnchorType PreviewHeroBgAnchorType
function PreviewHeroMenu:SetBgHeroMenuByName(bgName, previewHeroBgAnchorType, dataId)
    if bgName == self._bgName then
        return
    end
    --self.config.heroAnchor.localPosition = previewHeroBgAnchorType
    self.config.heroAnchor.localPosition = PreviewHeroMenu.GetPreviewHeroPositionByType(previewHeroBgAnchorType, dataId)
    self:DeSpawnBg()
    self._bgName = bgName
    self._bgHeroInfo = SmartPool.Instance:SpawnTransform(AssetType.Background, self._bgName)
    self._bgHeroInfo.position = self.config.transform.position
    self._bgHeroInfo.localScale = U_Vector3.one * 1.15
    self._bgHeroInfo:SetParent(zgUnity.transform)
    self._bgHeroInfo.gameObject:SetActive(true)
end

--- @param scale number
--- Set scale of background
function PreviewHeroMenu:SetPreviewHeroBackgroundScale(scale)
    self._bgHeroInfo.localScale = U_Vector3.one * scale
end

function PreviewHeroMenu:FlipHero()
    self.previewHero:FlipHero()
end

function PreviewHeroMenu:ResetHeroToDefault()
    self.previewHero:ResetHeroToDefault()
end

function PreviewHeroMenu:_DoTweenAnchor(targetPosition)
    self.previewHero:_DoTweenAnchor(targetPosition, 0.5)
end

--- @class PreviewHeroBgAnchorType
PreviewHeroBgAnchorType = {
    HeroInfo = U_Vector3(0, -2.52, 0),
    HeroEvolve = U_Vector3(1.5, -2.6, 0),
    HeroSkin = U_Vector3(1.26, -2.84, 0),
    IdleEffect = U_Vector3(1.26, -2.84, 0),
    HeroSummon = U_Vector3(-5.27, -3.54, 0),
    EventNewHeroSummon = U_Vector3(0, -2.46, 0),
    RightCorner = U_Vector3(2.1, -1, 0),
}