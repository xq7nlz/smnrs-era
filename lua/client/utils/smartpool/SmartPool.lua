require "lua.client.utils.smartPool.SmartPoolUtils"

--- @class GeneralEffectPoolType
GeneralEffectPoolType = {}

--- @class HeroEffectPoolType
HeroEffectPoolType = {}

--- @class UIPoolType
UIPoolType = {}

--- @class EffectPoolType
EffectPoolType = {
    SummonCardGlow = 'summon_card_glow',
    SummonIconBottom = 'fx_summon_icon_bottom',
    SummonIconBottomNormal = 'fx_summon_icon_bottom_normal',
    SummonIconTop = 'fx_summon_icon_top',
    SummonIconTopNormal = 'fx_summon_icon_top_normal',
    SummonIconBottomTierA = 'fx_summon_icon_bottom_rare',
    SummonIconTopTierA = 'fx_summon_icon_top_rare',
    ItemIconBottom = 'fx_item_icon_bottom',
    ItemIconTop = 'fx_item_icon_top',
    BlackSmithIconBottom1 = 'fx_ui_blacksmith_popup1',
    Upgrade = 'fx_icon_upartifact_arrow',
    Unlock = 'fx_icon_upartifact',
    PopupReward = 'fx_ui_blacksmith_popup',
    AddTavern = 'fx_tarven_add',
    RefreshTavern = 'fx_tarven_refresh',
    StartTavern = 'fx_tarven_startfill',
    StageIdle = 'fx_button_selectmap',
    SpeedUpTavern = 'fx_tarven_speedUp',
    EffectHeroTraining = 'fx_ui_trainning_hero',
    EffectSpin = 'effect_spin_hero',
    EffectRose = 'fx_ui_8_3_open_card',
    --EffectExchange = 'fx_ui_item_exchange_item_effect',
    EffectTouch = "fx_tap_button_ux",
    EffectGlow = "fx_bg_item_glow",
    --ItemExchangeBase1 = "fx_ui_item_exchange_icon_base_1",
    --ItemExchangeBase2 = "fx_ui_item_exchange_icon_base_2",
    --ItemExchangeBase3 = "fx_ui_item_exchange_icon_base_3",
    OpenCard = "fx_ui_valentine_open_card",
    ResetItem = "dice_reset_effect",
    StarHeroCard = "fx_ui_icon_star_heroes_card",
    StarHeroInfo = "fx_ui_icon_star_heroes_info",
    HeroCardWater = "fx_ui_icon_heroes_card_1",
    HeroCardFire = "fx_ui_icon_heroes_card_2",
    HeroCardAbyss = "fx_ui_icon_heroes_card_3",
    HeroCardNature = "fx_ui_icon_heroes_card_4",
    HeroCardLight = "fx_ui_icon_heroes_card_5",
    HeroCardDark = "fx_ui_icon_heroes_card_6",

    HeroInfoWater = "fx_ui_icon_heroes_info_1",
    HeroInfoFire = "fx_ui_icon_heroes_info_2",
    HeroInfoAbyss = "fx_ui_icon_heroes_info_3",
    HeroInfoNature = "fx_ui_icon_heroes_info_4",
    HeroInfoLight = "fx_ui_icon_heroes_info_5",
    HeroInfoDark = "fx_ui_icon_heroes_info_6",
    AvatarEffect = "avatar_fx_"
}

local GarbageDict = {}

local lruDict = {}

--- @class SmartPool
SmartPool = Class(SmartPool)

----------------------------------------------------------------------------
---------------------CONSTRUCTOR--------------------------
----------------------------------------------------------------------------

--- @return void
function SmartPool:Ctor()
    --- @type UnityEngine_GameObject
    self._cacheTransRoot = nil
    --- @type Dictionary Lua + GameObject Pool
    self._objectPool = Dictionary()
    --- @type Dictionary Prefab Object Pool
    self._prefabDict = Dictionary()

    self:_Init()
end

--- @return void
function SmartPool:PreloadUIPool()
    --- @param uiPoolType UIPoolType
    local uiPreload = function(uiPoolType, quantity)
        for i = 1, quantity do
            --- @type UIPrefabView
            local ui = uiPoolType()
            ui:ReturnPool()
        end
    end
    uiPreload(UIPoolType.HeroIconView, 10)
    uiPreload(UIPoolType.ItemIconView, 10)
end

--- @return table
--- @param assetType AssetType
--- @param detailPoolType <UIPoolType or GeneralEffectPoolType or HeroEffectPoolType>
function SmartPool:SpawnLuaGameObject(assetType, detailPoolType)
    assert(assetType ~= nil and detailPoolType ~= nil)

    local luaObject = self:_TryGetObjectFromCache(assetType, detailPoolType)
    if luaObject == nil then
        luaObject = detailPoolType()
    end
    return luaObject
end

--- @return table
--- @param uiPoolType UIPoolType
--- @param parent UnityEngine_Transform
function SmartPool:SpawnLuaUIPool(uiPoolType, parent)
    assert(uiPoolType ~= nil, uiPoolType)
    --- @type IconView
    local ui = self:SpawnLuaGameObject(AssetType.UIPool, uiPoolType)
    ui:SetParent(parent)
    ui:Show()
    return ui
end

--- @return ClientEffect
--- @param assetType AssetType
--- @param detailPoolType GeneralEffectPoolType or HeroEffectPoolType
--- @param prefabName string
function SmartPool:SpawnClientEffectByPoolType(assetType, detailPoolType, prefabName)
    if assetType == AssetType.GeneralBattleEffect
            and detailPoolType ~= GeneralEffectPoolType.ClientEffect then
        return self:SpawnLuaGameObject(AssetType.GeneralBattleEffect, detailPoolType)
    else
        local clientEffect = self:_TryGetObjectFromCache(assetType, prefabName)
        if clientEffect == nil then
            return detailPoolType()
        else
            return clientEffect
        end
    end
end

----------------------------------------------------------------------------
---------------------SPAWN GAME OBJECT--------------------------
----------------------------------------------------------------------------

--- @return UnityEngine_GameObject
--- @param assetType AssetType
--- @param name string
function SmartPool:SpawnGameObject(assetType, name)
    assert(assetType ~= nil and name ~= nil)
    --- @type UnityEngine_Transform
    local transform = self:_TryGetObjectFromCache(assetType, name)
    if transform == nil then
        return self:CreateGameObject(assetType, name)
    else
        local prefab = self:_GetPrefab(assetType, name)
        self:CheckLRUCache(assetType, prefab)
        return transform.gameObject
    end
end

--- @param assetType AssetType
--- @param name string
function SmartPool:SpawnGameObjectAsync(assetType, name, onFinish)
    assert(assetType ~= nil and name ~= nil)
    --- @type UnityEngine_Transform
    local transform = self:_TryGetObjectFromCache(assetType, name)
    if transform == nil then
        self:CreateGameObjectAsync(assetType, name, nil, function(loadedTransform)
            onFinish(loadedTransform.gameObject)
        end)
    else
        onFinish(transform.gameObject)
    end
end

--- @return UnityEngine_Transform
--- @param assetType AssetType
--- @param name string
function SmartPool:SpawnTransform(assetType, name)
    local go = self:SpawnGameObject(assetType, name)
    if go ~= nil then
        return go.transform
    end
    return nil
end

--- @return UnityEngine_Transform
--- @param effectPoolType EffectPoolType
--- @param parent UnityEngine_RectTransform
function SmartPool:SpawnUIEffectPool(effectPoolType, parent)
    assert(effectPoolType ~= nil and parent ~= nil)
    --- @type UnityEngine_Transform
    local effect = self:SpawnTransform(AssetType.UIEffect, effectPoolType)
    if effect ~= nil then
        UIUtils.SetParent(effect, parent)
    end
    return effect
end

--- @param assetType AssetType
function SmartPool:CheckLRUCache(assetType, prefab)
    if assetType == AssetType.Hero then
        --- @type LRUCache
        local lru = lruDict[assetType]
        local removePrefab = lru:Refer(prefab)
        if removePrefab then
            local dict = GarbageDict[assetType]
            if GarbageDict[assetType] == nil then
                dict = {}
                GarbageDict[assetType] = dict
            end
            dict[removePrefab.name] = removePrefab
        end

        if GarbageDict[assetType] and GarbageDict[assetType][prefab.name] then
            GarbageDict[assetType][prefab.name] = nil
        end
    end
end

--- @return UnityEngine_GameObject
--- @param assetType AssetType
--- @param name string
--- @param parent UnityEngine_Transform
function SmartPool:CreateGameObject(assetType, name, parent)
    local prefab = self:_GetPrefab(assetType, name)
    if prefab ~= nil then
        self:CheckLRUCache(assetType, prefab)
        if parent then
            return U_GameObject.Instantiate(prefab, parent)
        else
            return U_GameObject.Instantiate(prefab)
        end
    else
        return nil
    end
end

--- @return UnityEngine_GameObject
--- @param assetType AssetType
--- @param name string
--- @param parent UnityEngine_Transform
function SmartPool:CreateGameObjectAsync(assetType, name, parent, onFinish)
    self:_GetPrefabAsync(assetType, name, function(prefab)
        if prefab ~= nil then
            if parent then
                onFinish(U_GameObject.Instantiate(prefab, parent))
            else
                onFinish(U_GameObject.Instantiate(prefab))
            end
        else
            onFinish(nil)
        end
    end)
end

--- @return void
--- @param assetType AssetType
--- @param detailAssetType string
--- @param luaTable table
function SmartPool:DespawnLuaGameObject(assetType, detailAssetType, luaTable)
    assert(assetType and detailAssetType and luaTable)
    --- reset parent for GameObject Pool
    luaTable.config.transform:SetParent(self._cacheTransRoot)
    if detailAssetType == GeneralEffectPoolType.ClientEffect or detailAssetType == HeroEffectPoolType.ClientEffect then
        detailAssetType = luaTable.prefabName
    end
    self:_AddObjectList(assetType, detailAssetType, luaTable)
end

--- @return void
--- @param effectPoolType EffectPoolType
--- @param transform UnityEngine_RectTransform
function SmartPool:DespawnUIEffectPool(effectPoolType, transform)
    assert(effectPoolType and transform)
    self:DespawnGameObject(AssetType.UIEffect, effectPoolType, transform)
end

--- @return void
--- @param assetType AssetType
--- @param detailAssetType string
--- @param transform UnityEngine_Transform
function SmartPool:DespawnGameObject(assetType, detailAssetType, transform)
    transform.gameObject:SetActive(false)
    transform:SetParent(self._cacheTransRoot)
    self:_AddObjectList(assetType, detailAssetType, transform)
end

--- @return void
--- @param assetType AssetType
function SmartPool:DestroyGameObjectByPoolType(assetType)
    --- @type Dictionary
    local objectDict = self._objectPool:Get(assetType)
    for assetName, _ in pairs(objectDict:GetItems()) do
        self:DestroyGameObjectByPoolTypeAndName(assetType, assetName)
    end
end

--- @return void
--- @param assetType AssetType
function SmartPool:DestroyGameObjectByPoolTypeAndName(assetType, assetName)
    --XDebug.Log(string.format("Destroy: %s %s", tostring(assetType), LogUtils.ToDetail(assetName)))
    --- @type List
    local objectList = self._objectPool:Get(assetType):Get(assetName)
    if objectList then
        for i = 1, objectList:Count() do
            U_Object.Destroy(objectList:Get(i).gameObject)
        end
        objectList:Clear()
    end
end

--- @return void
function SmartPool:_Init()
    local newParent = U_GameObject("SmartPool")
    newParent.transform:SetParent(zgUnity.transform)
    self._cacheTransRoot = newParent.transform

    for k, v in pairs(AssetType) do
        self._prefabDict:Add(v, Dictionary())
        self._objectPool:Add(v, Dictionary())
    end

    lruDict[AssetType.Hero] = LRUCache(25)
end

--- @return boolean
--- @param assetType AssetType
--- @param detailPoolType <UIPoolType or GeneralEffectPoolType or HeroEffectPoolType>
function SmartPool:_CheckObjectHasCached(assetType, detailPoolType)
    assert(assetType ~= nil and detailPoolType ~= nil)
    local objectList = self._objectPool:Get(assetType):Get(detailPoolType)
    return objectList ~= nil and objectList:Count() > 0
end

--- @return table
--- @param assetType AssetType
--- @param name string
function SmartPool:_TryGetObjectFromCache(assetType, name)
    assert(assetType ~= nil and name ~= nil)
    if not self:_CheckObjectHasCached(assetType, name) then
        return nil
    end

    local objectList = self._objectPool:Get(assetType):Get(name)
    local object = objectList:Get(objectList:Count())
    objectList:RemoveByIndex(objectList:Count())

    assert(not Main.IsNull(object), "Something wrong, there gameObject instance in cache is null!")
    --if object == nil  or type(object) ~= tostring(name)  then
    --    object = name()
    --end
    return object
end

--- @return UnityEngine_GameObject
--- @param assetType AssetType
--- @param name string
function SmartPool:_GetPrefab(assetType, name)
    if self:_CheckHasPrefab(assetType, name) then
        return self._prefabDict:Get(assetType):Get(name)
    else
        local prefab = ResourceLoadUtils.LoadAssetByType(assetType, name)

        if not Main.IsNull(prefab) then
            self._prefabDict:Get(assetType):Add(name, prefab)
        else
            XDebug.Log(string.format("prefab is invalid: %s", name))
        end
        return prefab
    end
end

--- @return UnityEngine_GameObject
--- @param assetType AssetType
--- @param name string
function SmartPool:_GetPrefabAsync(assetType, name, onFinish)
    if self:_CheckHasPrefab(assetType, name) then
        onFinish(self._prefabDict:Get(assetType):Get(name))
    else
        --if assetType == AssetType.Hero then
        --    name = string.match(name, "%d+") .. '/' .. name
        --end
        ResourceLoadUtils.LoadAssetByTypeAsync(assetType, name, function(prefab)
            if not Main.IsNull(prefab) then
                self._prefabDict:Get(assetType):Add(name, prefab)
            else
                XDebug.Log(string.format("prefab is invalid: %s", name))
            end
            onFinish(prefab)
        end)
    end
end

--- @return boolean
--- @param assetType AssetType
--- @param name string
function SmartPool:_CheckHasPrefab(assetType, name)
    local prefab = self._prefabDict:Get(assetType):Get(name)
    return not Main.IsNull(prefab)
end

--- @return List
--- @param assetType AssetType
--- @param detailAssetType string
function SmartPool:_GetObjectList(assetType, detailAssetType)
    --- @type List
    local objectList = self._objectPool:Get(assetType):Get(detailAssetType)
    if objectList == nil then
        objectList = List()
        self._objectPool:Get(assetType):Add(detailAssetType, objectList)
    end
    return objectList
end

----@return boolean
--- @param assetType AssetType
--- @param detailAssetType string
function SmartPool:CheckCanReturnObjectList(assetType, detailAssetType, object)
    assert(assetType and detailAssetType and object)
    --- @type List
    local objectList = self:_GetObjectList(assetType, detailAssetType)
    --XDebug.Log("CONTAIN CHECK ")
    return objectList:IsContainValue(object) == false
end

--- @param assetType AssetType
--- @param detailAssetType string
function SmartPool:_AddObjectList(assetType, detailAssetType, object)
    --- @type List
    local objectList = self:_GetObjectList(assetType, detailAssetType)
    if objectList:IsContainValue(object) == false then
        objectList:Add(object)
        --return true
    else
        --return false
        print(debug.traceback())
        XDebug.Error(string.format("OBJECT [%s|%s] HAD IN POOL.)", assetType, LogUtils.ToDetail(detailAssetType)))
    end
end

--- @type SmartPool
SmartPool.Instance = SmartPool()
