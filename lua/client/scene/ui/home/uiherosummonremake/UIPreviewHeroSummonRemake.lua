--- @class UIPreviewHeroSummonRemake : BgWorldView
UIPreviewHeroSummonRemake = Class(UIPreviewHeroSummonRemake, BgWorldView)

--- @param transform UnityEngine_Transform
function UIPreviewHeroSummonRemake:Ctor(transform)
    BgWorldView.Ctor(self, transform)

    --- @type UnityEngine_GameObject
    self._heroObject = nil
    --- @type ClientHero
    self.clientHero = nil

    --- @type PreviewHero
    self.previewHero = PreviewHero(self.config.bookAnchor.transform)
end

--- @param transform UnityEngine_Transform
function UIPreviewHeroSummonRemake:InitConfig(transform)
    --- @type UIPreviewHeroSummonConfig
    self.config = UIBaseConfig(transform)
end

function UIPreviewHeroSummonRemake:PlayBeforeSummon()
    self:SetActive(true)
    self.config.scroll:SetActive(true)
    self.config.scrollAnim.AnimationState:SetAnimation(0, "idle_before_summon", true)
end

--- @param anim string
function UIPreviewHeroSummonRemake:PlaySummon(anim)
    self.config.scroll:SetActive(true)
    local trackEntry = self.config.scrollAnim.AnimationState:SetAnimation(0, anim, false)
    trackEntry:AddCompleteListenerFromLua(function()
        if uiCanvas.config.eventSystem.isActiveAndEnabled == true then
            self:_PlayAfterSummon()
        end
    end)
end

--- @return void
function UIPreviewHeroSummonRemake:_FadeBackground()
    DOTweenUtils.DOFade(self.config.bg, 1, 0.3, function()
        DOTweenUtils.DOFade(self.config.bg, 0, 0.7, nil)
    end)
end

function UIPreviewHeroSummonRemake:_PlayAfterSummon()
    self.config.scroll:SetActive(true)
    self.config.scrollAnim.AnimationState:SetAnimation(0, "idle_after_summon", true)
end

--- @param heroResource HeroResource
function UIPreviewHeroSummonRemake:ShowHero(heroResource)
    --XDebug.Log("SHOW")
    self:PlaySummonEffect()
    local onSpawned = function()
        local clientHero = self.previewHero:GetClientHero()
        if clientHero ~= nil then
            clientHero.components.transform.localPosition = U_Vector3.zero + U_Vector3.up * 0.4
            --XDebug.Log("Set pos")
        end
       -- self.previewHero.heroAnchor.localScale = U_Vector3(1.8,1.8,1)
    end

    self.previewHero:PreviewHeroAsync(heroResource, nil, onSpawned,1.8)

end

function UIPreviewHeroSummonRemake:OnShow()
    self.config.scroll:SetActive(false)
    self:SetActive(true)
end

--- @return void
function UIPreviewHeroSummonRemake:OnHide()
    self:ClearObjects()
    self.config.scroll:SetActive(false)
    self:SetActive(false)
    self.previewHero:OnHide()
end

function UIPreviewHeroSummonRemake:ClearObjects()
    self.previewHero:DespawnHero()
    self:DespawnEffects()
end

--- @param viewSize UnityEngine_Vector2
function UIPreviewHeroSummonRemake:_AdjustBackgroundSize(viewSize)
    if self.config.bgBlurSummon == nil
            or self.config.bg == nil then
        return
    end

    local spriteRenderer = self.config.bg
    local sprite = spriteRenderer.sprite
    local scaleSpriteX = (self.config.camera.orthographicSize * 2 * self.config.camera.pixelWidth / self.config.camera.pixelHeight) / sprite.bounds.size.x
    local scaleSpriteY = (self.config.camera.orthographicSize * 2 / sprite.bounds.size.y)

    if (sprite.bounds.size.x / sprite.bounds.size.y) > (self.config.camera.pixelWidth / self.config.camera.pixelHeight) then
        spriteRenderer.transform.localScale = U_Vector3(scaleSpriteY, scaleSpriteY, spriteRenderer.transform.localScale.z)
    else
        spriteRenderer.transform.localScale = U_Vector3(scaleSpriteX, scaleSpriteX, spriteRenderer.transform.localScale.z)
    end
end

function UIPreviewHeroSummonRemake:PlaySummonSpawnHero()
    self:ReactiveObject(self.config.summonSpawnHero)
end

---@param heroResource HeroResource
function UIPreviewHeroSummonRemake:PlayFxSummonOne(heroResource)
    if heroResource.heroStar == 5 then
        local heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroResource.heroId)
        if heroTier > 5 then
            self:ReactiveObject(self.config.fxSummonSpawnHero5Rare)
        else
            self:ReactiveObject(self.config.fxSummonOneSpecial)
        end
    else
        self:ReactiveObject(self.config.fxSummonOne)
    end
end

---@param heroResource HeroResource
function UIPreviewHeroSummonRemake:PlayFxSummon10(heroResource)
    if heroResource.heroStar == 5 then
        local heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroResource.heroId)
        if heroTier > 5 then
            self:ReactiveObject(self.config.fxSummon10Hero5Rare)
        else
            self:ReactiveObject(self.config.fxSummon10Special)
        end
    else
        self:ReactiveObject(self.config.fxSummon10)
    end
end

function UIPreviewHeroSummonRemake:PlaySummonEffect()
    self:ReactiveObject(self.config.fxSummonFront)
    self:ReactiveObject(self.config.fxSummonAfter)
end

function UIPreviewHeroSummonRemake:PlayChangeHeroEffect()
    self:ReactiveObject(self.config.changeHeroSummoned)
end

function UIPreviewHeroSummonRemake:DespawnEffects()
    self.config.summonSpawnHero:SetActive(false)
    self.config.fxSummonFront:SetActive(false)
    self.config.fxSummonAfter:SetActive(false)
    self.config.changeHeroSummoned:SetActive(false)
    self.config.fxSummon10:SetActive(false)
    self.config.fxSummon10Special:SetActive(false)

    self.config.fxSummonOne:SetActive(false)
    self.config.fxSummonOneSpecial:SetActive(false)

    self.config.fxSummon10Hero5Rare:SetActive(false)
    self.config.fxSummonSpawnHero5Rare:SetActive(false)
end

function UIPreviewHeroSummonRemake:DespawnHero()
    self.previewHero:DespawnHero()
end

function UIPreviewHeroSummonRemake:SetToDefaultState()
    self:DespawnHero()
    self.config.scroll:SetActive(false)
end

--- @param go UnityEngine_GameObject
function UIPreviewHeroSummonRemake:ReactiveObject(go)
    if go.activeSelf == true then
        go:SetActive(false)
    end
    go:SetActive(true)
end
