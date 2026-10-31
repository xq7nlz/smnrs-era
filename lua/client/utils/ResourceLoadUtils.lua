--- @class ResourceLoadUtils
ResourceLoadUtils = Class(ResourceLoadUtils)

require "lua.client.utils.SpriteLoadUtils"

local assetPath = "%s/%s"

--- @return void
function ResourceLoadUtils.InitLoadResource()
    Coroutine.start(function()
        RxMgr.finishLoading:Next()
        coroutine.waitforseconds(0.1)
        SmartPool.Instance:PreloadUIPool()
        coroutine.waitforseconds(0.1)
        --local spawnList = {UIPopupName.UISelectMapPVE, UIPopupName.UIHeroSummonRemake, UIPopupName.UIFormation, UIPopupName.UIMarket,
        --                   UIPopupName.UIHeroCollection, UIPopupName.UIHeroMenu2,UIPopupName.UIMainArea}
        local spawnList = {}
        for _, v in ipairs(spawnList) do
            local popupInfo = zg.popupMgr:Spawn(v)
            popupInfo:Preload()
            coroutine.waitforseconds(0.1)
        end
        coroutine.waitforseconds(0.1)
        PopupMgr.ShowPopup(UIPopupName.UIMainArea)
    end)
end

--- @return UnityEngine_GameObject
--- @param assetName string
--- @param loadFromResources boolean
function ResourceLoadUtils.LoadUI(assetName, loadFromResources)
    local resourceLoadPath = string.format(assetPath, AssetType.UI, assetName)
    return U_GameObject.Instantiate(ResourceLoadUtils.LoadObject(resourceLoadPath, ComponentName.UnityEngine_GameObject, loadFromResources))
end

--- @return UnityEngine_GameObject
--- @param assetType AssetType
--- @param assetName string
function ResourceLoadUtils.LoadAssetByType(assetType, assetName)
    local resourceLoadPath = ResourceLoadUtils.GetResourceLoadPath(assetType, assetName)
    return ResourceLoadUtils.LoadObject(resourceLoadPath, ComponentName.UnityEngine_GameObject, assetType)
end

--- @return UnityEngine_GameObject
--- @param assetType AssetType
--- @param assetName string
function ResourceLoadUtils.LoadAssetByTypeAsync(assetType, assetName, onFinish)
    local resourceLoadPath = ResourceLoadUtils.GetResourceLoadPath(assetType, assetName)
    ResourceLoadUtils.LoadObjectAsync(resourceLoadPath, ComponentName.UnityEngine_GameObject, onFinish, assetType)
end

function ResourceLoadUtils.GetResourceLoadPath(assetType, assetName)
    local resourceLoadPath = string.format(assetPath, assetType, assetName)
    return resourceLoadPath
end


--- @return UnityEngine_GameObject
--- @param name string
--- @param parent UnityEngine_Transform
function ResourceLoadUtils.LoadUIEffect(name, parent)
    local object = ResourceLoadUtils.LoadAssetByType(AssetType.UIEffect, name)
    ---@type UnityEngine_GameObject
    local gameObject = U_GameObject.Instantiate(object)
    if parent ~= nil then
        UIUtils.SetParent(gameObject.transform, parent)
    end
    return gameObject
end

--- @return UnityEngine_GameObject
--- @param assetName string
function ResourceLoadUtils.LoadConfig(assetName, onConfigLoaded)
    local resourceLoadPath = string.format(assetPath, AssetType.Config, assetName)
    ResourceLoadUtils.LoadObjectAsync(resourceLoadPath, ComponentName.UnityEngine_DataAnimationCurve, onConfigLoaded)
end

--- @return System_Object
--- @param name string
function ResourceLoadUtils.LoadFontAsset(name)
    local resourceLoadPath = string.format("Fonts/Battle/ItalicNotoSan/%s", name)
    return ResourceLoadUtils.LoadObject(resourceLoadPath, ComponentName.TMPro_TMP_FontAsset)
end

--- @return UnityEngine_AudioClip
function ResourceLoadUtils.LoadAsyncBundleAudioClip(folder, assetName, onAudioLoaded)
    local resourceLoadPath = string.format("Audio/%s/%s", folder, assetName)
    ResourceLoadUtils.LoadObjectAsync(resourceLoadPath, ComponentName.UnityEngine_AudioClip, onAudioLoaded)
end

local videoDictionary = Dictionary()
--- @return UnityEngine_Video_VideoClip
function ResourceLoadUtils.LoadVideoClip(assetName)
    if videoDictionary:IsContainKey(assetName) then
        return videoDictionary:Get(assetName)
    end

    local resourceLoadPath = string.format(assetPath, AssetType.Video, assetName)
    local video = ResourceLoadUtils.LoadFromResources(resourceLoadPath, ComponentName.UnityEngine_VideoClip)
    videoDictionary:Add(assetName, video)

    return video
end

--- @return UnityEngine_Material
--- @param assetName string
function ResourceLoadUtils.LoadMaterial(assetName)
    local resourceLoadPath = string.format(assetPath, AssetType.Material, assetName)
    return ResourceLoadUtils.LoadObject(resourceLoadPath, ComponentName.UnityEngine_Material)
end

--- @return UnityEngine_Object
--- @param resourceLoadPath string
--- @param componentName ComponentName
--- @param loadFromResources boolean
function ResourceLoadUtils.LoadObject(resourceLoadPath, componentName, loadFromResources)

    assert(resourceLoadPath)

    local object
    if loadFromResources == true then
        object = ResourceLoadUtils.LoadFromResources(resourceLoadPath, componentName)
    else
        if IS_EDITOR_PLATFORM then
            object = zgUnity.assetBundleMgr:LoadObject(resourceLoadPath, componentName)
        else
            if zg.assetBundleMgr ~= nil then
                object = zg.assetBundleMgr:GetAsset(resourceLoadPath, componentName)
            else
                return nil
            end
        end
    end

    if object == nil then
        XDebug.Error(string.format("Missing: resourceLoadPath: %s", resourceLoadPath))
    end
    return object
end

--- @return UnityEngine_Object
--- @param resourceLoadPath string
--- @param componentName ComponentName
function ResourceLoadUtils.UnloadObject(resourceLoadPath, componentName, unloadAllLoadedObjects)
    -- do nothing now
end

--- @return UnityEngine_Object
--- @param resourceLoadPath string
--- @param componentName ComponentName
--- @param assetType AssetType
function ResourceLoadUtils.LoadObjectAsync(resourceLoadPath, componentName, onFinish, assetType)
    assert(resourceLoadPath)
    onFinish(ResourceLoadUtils.LoadObject(resourceLoadPath, componentName, assetType))
end

--- @return UnityEngine_Object
function ResourceLoadUtils.LoadFromResources(resourceLoadPath, componentName)
    return U_Resources.Load("AssetBundles/" .. resourceLoadPath, componentName)
end
