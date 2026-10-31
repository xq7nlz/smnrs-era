require "lua.client.utils.ResourceLoadUtils"

local assetPath = "%s/%s"

--- @class PrefabLoadUtils
PrefabLoadUtils = {}

local dict = {}

--- @type UnityEngine_GameObject
--- @param parent UnityEngine_Transform
PrefabLoadUtils.Instantiate = function(assetName, parent)
    local resourceLoadPath = string.format(assetPath, AssetType.Prefab, assetName)
    local obj = ResourceLoadUtils.LoadObject(resourceLoadPath, ComponentName.UnityEngine_GameObject)
    if obj == nil then
        return nil
    end
    if parent then
        return U_GameObject.Instantiate(obj, parent)
    else
        return U_GameObject.Instantiate(obj)
    end
end

PrefabLoadUtils.InstantiateAsync = function(assetName, onFinish, parent)
    local resourceLoadPath = string.format(assetPath, AssetType.Prefab, assetName)
    ResourceLoadUtils.LoadObjectAsync(resourceLoadPath, ComponentName.UnityEngine_GameObject, function(prefab)
        assert(prefab)
        onFinish(U_GameObject.Instantiate(prefab, parent))
    end)
    --onFinish(U_GameObject.Instantiate(ResourceLoadUtils.LoadObject(resourceLoadPath, ComponentName.UnityEngine_GameObject)))
end

--- @param parent UnityEngine_Transform
PrefabLoadUtils.Get = function(class, parent)
    local ins = dict[class]
    if ins == nil then
        ins = class()
        dict[class] = ins
    end
    ins:SetParent(parent)
    return ins
end

PrefabLoadUtils.Remove = function(class)
    dict[class] = nil
end

--- @type UnityEngine_GameObject
--- @param parent UnityEngine_Transform
PrefabLoadUtils.GetAvailablePrefab = function(assetName)
    local resourceLoadPath = string.format(assetPath, AssetType.Prefab, assetName)
    local obj = ResourceLoadUtils.LoadObject(resourceLoadPath, ComponentName.UnityEngine_GameObject)
    if obj == nil then
        return nil
    end
    if parent then
        return U_GameObject.Instantiate(obj, parent)
    else
        return U_GameObject.Instantiate(obj)
    end
end

