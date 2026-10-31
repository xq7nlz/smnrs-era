--- @class GuildDungeonBossStand
GuildDungeonBossStand = Class(GuildDungeonBossStand)

function GuildDungeonBossStand:Ctor()
    --- @type number
    self.stageStatus = nil
    --- @type HeroResource
    self.heroResource = nil
    self:InitConfig()
end

function GuildDungeonBossStand:InitConfig()
    self.prefabName = 'guild_dungeon_boss_stand'
    self.uiPoolType = UIPoolType.GuildDungeonBossStand
    self.gameObject = SmartPool.Instance:CreateGameObject(AssetType.UIPool, self.prefabName, zgUnity.transform)

    self:SetConfig(self.gameObject.transform)
    self.previewHero = PreviewHero(self.config.heroAnchor)
end

--- @param transform UnityEngine_Transform
function GuildDungeonBossStand:SetConfig(transform)
    --- @type GuildDungeonBossStandConfig
    self.config = UIBaseConfig(transform)
    self.config.canvas.sortingLayerID = ClientConfigUtils.BATTLE_LAYER_ID
end

function GuildDungeonBossStand:SetActive(isActive)
    self.gameObject:SetActive(isActive)
end

function GuildDungeonBossStand:ReturnPool()
    self.heroResource = nil
    self:SetActive(false)
    self.previewHero:OnHide()
    SmartPool.Instance:DespawnLuaGameObject(AssetType.UIPool, UIPoolType.GuildDungeonBossStand, self)
end

--- @param stage number
--- @param status number
function GuildDungeonBossStand:SetStageStatus(stage, status)
    self.status = status
    self.config.textStage.text = string.format("%s %d", LanguageUtils.LocalizeCommon("stage"), stage)
    for i = 1, self.config.statusIcon.childCount do
        self.config.statusIcon:GetChild(i - 1).gameObject:SetActive(status == i - 1)
    end
end

--- @param heroResource HeroResource
function GuildDungeonBossStand:ShowHero(heroResource)
    if heroResource == nil then
        self.previewHero:DespawnHero()
        self.config.mystery.gameObject:SetActive(true)
        return
    end
    self.config.mystery.gameObject:SetActive(false)
    self.heroResource = heroResource
    local onSpawned = function()
        local clientHero = self.previewHero:GetClientHero()
        if clientHero ~= nil then
            clientHero:ChangeSortingLayerId(self.config.base.sortingLayerID)
            if self.status == GuildDungeonWorldView.STAGE_PASS then
                clientHero:OnCompleteGettingFreezed(EffectLogType.PETRIFY)
            end
        end
    end
    self.previewHero:PreviewHeroAsync(heroResource, nil, onSpawned)
end

--- @param orderInLayer number
function GuildDungeonBossStand:ChangeHeroLayer(orderInLayer)
    self.previewHero:UpdateLayerByAxisY(0, orderInLayer)
end

--- @param pos UnityEngine_Vector3
function GuildDungeonBossStand:SetPosition(pos)
    self.config.transform.position = pos
    self:SetScaleByPosX(pos.x)
end

function GuildDungeonBossStand:SetScaleByPosX(x)
    if math.abs(x) < 4.5 then
        self.config.transform.localScale = (1.2 - 0.2 * math.abs(x) / 4.5) * U_Vector3.one
    else
        self.config.transform.localScale = U_Vector3.one
    end
end

--- @param fromPos UnityEngine_Vector3
--- @param endPos UnityEngine_Vector3
--- @param onEndMove function
function GuildDungeonBossStand:DoMove(fromPos, endPos, time, onEndMove)
    self:SetPosition(fromPos)
    self.config.transform:DOMove(endPos, time):OnComplete(function()
        if onEndMove ~= nil then
            onEndMove()
        end
    end):OnUpdate(function()
        self:SetScaleByPosX(self.config.transform.position.x)
    end)
end

function GuildDungeonBossStand:SetForegroundLayer()
    self:_SetElementLayer(ClientConfigUtils.FRONT_BATTLE_LAYER_ID)
end

function GuildDungeonBossStand:SetBackgroundLayer()
    self:_SetElementLayer(ClientConfigUtils.BATTLE_LAYER_ID)
end

--- @param sortingLayerId number
function GuildDungeonBossStand:_SetElementLayer(sortingLayerId)
    self.config.base.sortingLayerID = sortingLayerId
    self.config.mystery.sortingLayerID = sortingLayerId
    --- @type ClientHero
    local clientHero = self.previewHero:GetClientHero()
    if clientHero ~= nil then
        clientHero:ChangeSortingLayerId(sortingLayerId)
    end
    for i = 1, self.config.statusIcon.childCount do
        local child = self.config.statusIcon:GetChild(i - 1)
        if child.gameObject.activeSelf then
            --- @type UnityEngine_SpriteRenderer
            local sprite = child:GetComponent(ComponentName.UnityEngine_SpriteRenderer)
            sprite.sortingLayerID = sortingLayerId
            break
        end
    end
    self.config.canvas.sortingLayerID = sortingLayerId
end

return GuildDungeonBossStand