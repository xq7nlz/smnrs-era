require "lua.client.scene.ui.home.uiDungeonMain.uiPreviewHeroDungeon.NpcDungeonMgr"

--- @class UIPreviewHeroDungeon : BgWorldView
UIPreviewHeroDungeon = Class(UIPreviewHeroDungeon, BgWorldView)

--- @param transform UnityEngine_Transform
function UIPreviewHeroDungeon:Ctor(transform)
    --- @type UIPreviewHeroDungeonConfig
    self.config = nil
    --- @type UIHeroStatusBar
    self.uiAttackerStatusBar = nil
    --- @type NpcDungeonMgr
    self.npcDungeonMgr = nil
    --- @type List
    self.currentEffectList = List()

    BgWorldView.Ctor(self, transform)
end

function UIPreviewHeroDungeon:InitConfig(transform)
    BgWorldView.InitConfig(self, transform)

    --- @type PreviewHero
    self.uiPreviewAttacker = PreviewHero(self.config.attackerAnchor)
    self.uiPreviewDefender = PreviewHero(self.config.defenderAnchor)
    self:InitStatusBar()
end

function UIPreviewHeroDungeon:InitStatusBar()
    local statusBar = SmartPool.Instance:SpawnGameObject(AssetType.Battle, "status_bar")
    --- @type UnityEngine_RectTransform
    local rectStatusBar = statusBar:GetComponent(ComponentName.UnityEngine_RectTransform)
    rectStatusBar:SetParent(self.config.attackerAnchor)
    rectStatusBar.anchoredPosition3D = U_Vector3(0, 3.5)
    rectStatusBar.localScale = U_Vector3.one * 0.01

    --- @type UIHeroStatusBar
    self.uiAttackerStatusBar = UIHeroStatusBar(rectStatusBar)
    self.uiAttackerStatusBar:InitCanvas(nil, self.config.camera)
    self:SetActiveStatusBar(false)
end

function UIPreviewHeroDungeon:OnCreated()
    BgWorldView.OnCreated(self)
    self.config.transform.position = U_Vector3.up * 20
end

function UIPreviewHeroDungeon:UpdateView()
    BgWorldView.UpdateView(self)
    self.config.cameraEffect.orthographicSize = self.config.camera.orthographicSize
end

--- @return ClientEffect
--- @param buffData ActiveBuffDataEntry | PassiveBuffDataEntry
--- @param useOnHero boolean
function UIPreviewHeroDungeon:GetFlyingPotionEffect(buffData, useOnHero)
    local effectName
    if useOnHero then
        --- @type DungeonBuffType
        local buffType = buffData.type
        effectName = string.format("fx_dungeon_stat_%d", buffType)
        if buffType == DungeonBuffType.ACTIVE_BUFF_NORMAL then
            if buffData.hpPercent > 0 then
                effectName = string.format("%s_heal", effectName)
            else
                effectName = string.format("%s_power", effectName)
            end
        end
    else
        local rarity = buffData.rarity
        effectName = string.format("fx_dungeon_stat_choose_%d", rarity)
    end
    local clientEffect = SmartPool.Instance:SpawnClientEffectByPoolType(AssetType.UIEffect, GeneralEffectPoolType.ClientEffect, effectName)
    if clientEffect ~= nil then
        if clientEffect.isInited == false then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            clientEffect:InitRef(AssetType.UIEffect, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            clientEffect:AddConfigField("originSpeed", 0)
            clientEffect:AddConfigField("deltaSpeed", 40)
            clientEffect:AddConfigField("rotationSpeed", 20)
            clientEffect.isInited = true
        end
        clientEffect:Play()
        clientEffect:SetParent(self.config.worldCanvas)
    end
    return clientEffect
end

--- @param buffData ActiveBuffDataEntry | PassiveBuffDataEntry
--- @param sourcePos UnityEngine_Vector3
--- @param destPos UnityEngine_Vector3
--- @param callback function
function UIPreviewHeroDungeon:PlayFlyingPotionEffect(buffData, sourcePos, destPos, useOnHero, callback)
    local potionEffect = self:GetFlyingPotionEffect(buffData, useOnHero)
    if potionEffect ~= nil then
        self.currentEffectList:Add(potionEffect)
        potionEffect:SetPosition(sourcePos)
        potionEffect:DoCurveMoveBetweenPosition(sourcePos, destPos, function()
            self.currentEffectList:RemoveByReference(potionEffect)
            potionEffect:Release()
            if callback ~= nil then
                callback()
            end
        end)
    else
        if callback ~= nil then
            callback()
        end
        XDebug.Log("PlayFlyingPotionEffect is missing")
    end
end

--- @param hero DungeonBindingHeroInBound
function UIPreviewHeroDungeon:PreviewAttacker(hero)
    local onSpawned = function()
        self:SetActiveStatusBar(hero:IsAlive())
        local clientHero = self.uiPreviewAttacker.clientHero
        self.uiAttackerStatusBar:InitStatusBar(hero.heroResource.heroLevel, ClientConfigUtils.GetFactionIdByHeroId(hero.heroResource.heroId))
        self:UpdateAttackerHealth(hero.hpPercent)
        self:UpdateAttackerPower(hero.power / HeroConstants.MAX_HERO_POWER)
        self.uiAttackerStatusBar:SetPosition(clientHero.components:GetHeroAnchor(ClientConfigUtils.HEAD_ANCHOR).position)
    end
    self.uiPreviewAttacker:PreviewHeroAsync(hero.heroResource, HeroModelType.Basic, onSpawned)
end

function UIPreviewHeroDungeon:UpdateAttackerHealth(hpPercent)
    self.uiAttackerStatusBar:UpdateHealth(hpPercent)
end

function UIPreviewHeroDungeon:UpdateAttackerPower(powerPercent)
    self.uiAttackerStatusBar:UpdatePower(powerPercent)
end

--- @param heroResource HeroResource
function UIPreviewHeroDungeon:PreviewDefender(heroResource)
    if ResourceMgr.GetHeroMenuConfig().listHeroCollection:IsContainValue(heroResource.heroId) == false then
        XDebug.Error(string.format("There is no hero with id [%d] in client", heroResource.heroId))
        heroResource.heroId = 10002
    end
    self.uiPreviewDefender:PreviewHero(heroResource, nil)
    self.config.fxDungeonSpawn:Play()
end

--- @param shopType number
function UIPreviewHeroDungeon:PreviewSeller(shopType)
    self.uiPreviewDefender:OnHide()

    --- @type NpcDungeonSeller
    if self.npcDungeonMgr == nil then
        self.npcDungeonMgr = NpcDungeonMgr(self.config.itemAnchor)
    end
    self.npcDungeonMgr:OnShow(shopType)
end

--- @return UnityEngine_Vector3
--- @param screenPosition UnityEngine_Vector3
function UIPreviewHeroDungeon:ScreenToWorldPoint(screenPosition)
    local worldPosition = uiCanvas.camUI:WorldToScreenPoint(screenPosition)
    worldPosition = self.config.camera:ScreenToWorldPoint(worldPosition)
    worldPosition = U_Vector3(worldPosition.x, worldPosition.y, 0)
    return worldPosition
end

function UIPreviewHeroDungeon:OnShow()
    if self.config.gameObject ~= nil then
        self.config.gameObject:SetActive(true)
    end
    self.uiPreviewAttacker:OnShow()
    self.uiPreviewDefender:OnShow()
end

function UIPreviewHeroDungeon:OnHide()
    if self.config.gameObject ~= nil then
        self.config.gameObject:SetActive(false)
    end

    if self.currentEffectList:Count() > 0 then
        --- @param v ClientEffect
        for _, v in ipairs(self.currentEffectList:GetItems()) do
            v:ReturnPool()
        end
        self.currentEffectList:Clear()
    end

    self.uiPreviewAttacker:OnHide()
    self.uiPreviewDefender:OnHide()

    self:HideSeller()
end

function UIPreviewHeroDungeon:HideSeller()
    if self.npcDungeonMgr ~= nil then
        self.npcDungeonMgr:OnHide()
    end
end

function UIPreviewHeroDungeon:SetActiveStatusBar(isActive)
    self.uiAttackerStatusBar:SetActive(isActive)
end

function UIPreviewHeroDungeon:ReturnPoolStatusBar()
    SmartPool.Instance:DespawnGameObject(AssetType.Battle, "status_bar", self.uiAttackerStatusBar.elements.transform)
end

--- @return UnityEngine_Vector3
function UIPreviewHeroDungeon:GetAttackerPosition()
    local attacker = self.uiPreviewAttacker:GetClientHero()
    if attacker ~= nil then
        return attacker.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    end
    return self:GetAttackerAnchor().position
end

--- @return UnityEngine_Transform
function UIPreviewHeroDungeon:GetAttackerAnchor()
    return self.config.attackerAnchor
end