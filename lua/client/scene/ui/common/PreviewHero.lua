--- @class PreviewHero
PreviewHero = Class(PreviewHero)

--- @param heroAnchor UnityEngine_Transform
function PreviewHero:Ctor(heroAnchor)
    --- @type UnityEngine_Transform
    self.heroAnchor = heroAnchor
    --- @type string
    self.prefabName = nil
    --- @type ClientHero
    self.clientHero = nil
    --- @type number
    self.defaultScale = 1.3

end

function PreviewHero:SetScale(scaleX)
    self.heroAnchor.localScale = U_Vector3(scaleX,scaleX,1)
end

function PreviewHero:SetDefaultHeroScale()
    self.heroAnchor.localScale = U_Vector3.one * self.defaultScale
end

function PreviewHero:FlipHero()
    self.heroAnchor.localEulerAngles = U_Vector3(0, 180, 0)
end

function PreviewHero:ResetHeroToDefault()
    self.heroAnchor.localEulerAngles = U_Vector3.zero
    self.heroAnchor.localScale = U_Vector3.one * 2
end

function PreviewHero:_DoTweenAnchor(targetPosition)
    self.heroAnchor:DOLocalMove(targetPosition, 0.5)
end


--- @param heroResource HeroResource
--- @param heroModelType HeroModelType
function PreviewHero:PreviewHero(heroResource, heroModelType,scaleX,disableIdleEffect)
    self:DespawnHero()
    local skinName = ClientConfigUtils.GetSkinNameByHeroResource(heroResource)
    self.prefabName = string.format("hero_%d_%s", heroResource.heroId, skinName)
    self:_SpawnHeroObject(heroResource, heroModelType,scaleX,disableIdleEffect)
    --self:GetScale(heroResource)
end

function PreviewHero:PreviewHeroAsync(heroResource, heroModelType, onFinish,scaleX)
    self:DespawnHero()
    local skinName = ClientConfigUtils.GetSkinNameByHeroResource(heroResource)
    self.prefabName = string.format("hero_%d_%s", heroResource.heroId, skinName)
    local onSpawned = function()
        if onFinish then
            onFinish()
        end
    end
    self:_SpawnHeroObjectAsync(heroResource, heroModelType, onSpawned,scaleX)
end

function PreviewHero:_SpawnHeroObject(heroResource, heroModelType,scaleX,disableIdleEffect)
    local gameObject = SmartPool.Instance:SpawnGameObject(AssetType.Hero, self.prefabName)
    self:_OnHeroObjectLoaded(gameObject, heroResource, heroModelType,scaleX,disableIdleEffect)
end

--- @param heroResource HeroResource
--- @param heroModelType HeroModelType
function PreviewHero:_SpawnHeroObjectAsync(heroResource, heroModelType, onFinish,scaleX)
    local touchObject = TouchUtils.Spawn("PreviewHero:_SpawnHeroObjectAsync")
    local onSpawned = function(gameObject)
        self:_OnHeroObjectLoaded(gameObject, heroResource, heroModelType,scaleX)
        touchObject:Enable()
        if onFinish then
            onFinish()
        end
    end
    SmartPool.Instance:SpawnGameObjectAsync(AssetType.Hero, self.prefabName, onSpawned)
end



---@param heroResource HeroResource
function PreviewHero:_OnHeroObjectLoaded(gameObject, heroResource, heroModelType,scaleX,disableIdleEffect)
    UIUtils.SetParent(gameObject.transform, self.heroAnchor)
    gameObject:SetActive(true)
    local luaRequire = ClientConfigUtils.GetClientHeroLuaRequire(heroResource.heroId)
    self.clientHero = require(luaRequire):CreateInstance(heroModelType)
    self.clientHero.gameObject = gameObject
    self.clientHero.components = HeroComponents(gameObject)
    self.clientHero.gameObject:SetActive(true)
    self.clientHero:SetSkinByBaseHero(self:CreatePreviewBaseHero(heroResource))
    self.clientHero:InitAnimationComponent()
    self.clientHero.animation:SetFlipByTeamId(BattleConstants.ATTACKER_TEAM_ID)
    self.clientHero:InitSkill()
    self.clientHero:PlayStartAnimation()
    if heroModelType ~= nil and heroModelType > HeroModelType.Dummy then
        --- @type PlayAnimEffectByFrame
        self.clientHero.playAnimEffectByFrame = PlayAnimEffectByFrame(self.clientHero)
        self.clientHero.playAnimEffectByFrame:CreateConfig(heroResource.heroId, ClientConfigUtils.GetSkinNameByHeroResource(heroResource))
        --- @type PlaySoundEffectByFrame
        self.clientHero.playSoundEffectByFrame = PlaySoundEffectByFrame(self.clientHero)
        self.clientHero.playSoundEffectByFrame:CreateConfig(heroResource.heroId, ClientConfigUtils.GetSkinNameByHeroResource(heroResource))
    end
    self.clientHero:SetPrefabName(self.prefabName)
    if (scaleX ~= nil) then
        --XDebug.Log("SCALE X " .. tostring(scaleX))
        self.heroAnchor.localScale = U_Vector3(scaleX,scaleX,1)
    end
    zg.battleMgr.previewHeroMgr:AddPreviewHeroInfo(self.prefabName)

    --XDebug.Log("hero id " .. heroResource.heroId .. " IDLE EFFECT " .. tostring(idIdleEffect))
    if (not disableIdleEffect) then
        local idIdleEffect = heroResource:GetIdleEffectEquip()
        self.clientHero:SetEffectInUI(idIdleEffect)
    end

end

function PreviewHero:DespawnHero()
    if self.clientHero ~= nil then
        self.clientHero:ReturnPool()
        self.clientHero = nil
    end
end

--- @param heroResource HeroResource
function PreviewHero:GetScale(heroResource)
    if (ResourceMgr.GetHeroMenuConfig().heroScaleDict:IsContainKey(heroResource.heroId)) then
        self:SetScale(ResourceMgr.GetHeroMenuConfig().heroScaleDict:Get(heroResource.heroId))
    else
        self:SetDefaultHeroScale()
    end
end


function PreviewHero:OnShow()

end

function PreviewHero:OnHide()
    self:DespawnHero()
    self:SetDefaultHeroScale()
end

--- @return boolean
function PreviewHero:IsHasHero()
    return self.clientHero ~= nil
end

--- @return ClientHero
function PreviewHero:GetClientHero()
    return self.clientHero
end

function PreviewHero:UpdateLayerByAxisY(heightY, orderInLayer)
    if self.clientHero == nil then
        return
    end
    heightY = heightY or self.clientHero.components.transform.position.y
    self.clientHero.animation:UpdateLayer(heightY, orderInLayer)
end

function PreviewHero:PlayAttackAnimation()
    if self.clientHero ~= nil then
        self.clientHero:DoBasicAttack()
    end
end

--- @return BaseHero
--- @param heroResource HeroResource
function PreviewHero:CreatePreviewBaseHero(heroResource)
    local baseHero = BaseHero()
    baseHero.isDummy = false
    baseHero.id = heroResource.heroId
    baseHero.star = heroResource.heroStar
    --XDebug.Log("STAR " .. tostring(baseHero.star))
    baseHero.level = heroResource.heroLevel
    baseHero.equipmentController = EquipmentController(baseHero)
    baseHero.equipmentController.equipments = heroResource.heroItem or Dictionary()
    baseHero.equipmentController.isHideSkin = heroResource.isHideSkin
    return baseHero
end

function PreviewHero:SetTransformStat(localPosition, localScale)
    self.heroAnchor.localPosition = localPosition
    self.heroAnchor.localScale = localScale
end