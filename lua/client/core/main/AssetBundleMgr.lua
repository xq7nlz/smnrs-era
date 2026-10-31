--- @class AssetBundleMgr
AssetBundleMgr = Class(AssetBundleMgr)

--- @return void
function AssetBundleMgr:Ctor()
    ---@type Dictionary
    self.assetBundleDict = Dictionary()
    ---@type Dictionary
    self.assetDict = Dictionary()
    ---@type Dictionary
    self.loadedAssetBundleDict = Dictionary()
    --- @type Dictionary
    self.assetExtensionDict = Dictionary()

    self:InitExtension()
end

function AssetBundleMgr:InitExtension()
    self.assetExtensionDict:Add(ComponentName.UnityEngine_GameObject, ".prefab")
    self.assetExtensionDict:Add(ComponentName.UnityEngine_AudioClip, ".mp3")
    self.assetExtensionDict:Add(ComponentName.UnityEngine_U2D_SpriteAtlas, ".spriteatlas")
    self.assetExtensionDict:Add(ComponentName.UnityEngine_Texture, ".png")
    self.assetExtensionDict:Add(ComponentName.TMPro_TMP_FontAsset, ".asset")
    self.assetExtensionDict:Add(ComponentName.UnityEngine_Sprite, ".png")
    self.assetExtensionDict:Add(ComponentName.UnityEngine_Material, ".mat")
    self.assetExtensionDict:Add(ComponentName.UnityEngine_DataAnimationCurve, ".asset")
end

--- @return void
function AssetBundleMgr:ReadManifest()
    local manifestPath
    if IS_IOS_PLATFORM then
        manifestPath = "csv/client/manifest/ios_manifest.json"
    else
        manifestPath = "csv/client/manifest/android_manifest.json"
    end
    local decodeData = CsvReaderUtils.ReadAndParseLocalFile(manifestPath, nil, true)
    local hash = decodeData["hash"]
    XDebug.Log("hash: " .. hash)
    local bundleList = decodeData["bundleList"]
    for _, assetBundleInfo in pairs(bundleList) do
        local rid = tonumber(assetBundleInfo["rid"])
        self.assetBundleDict:Add(rid, assetBundleInfo)
        for _, assetInfo in pairs(assetBundleInfo["assets"]) do
            self.assetDict:Add(assetInfo, rid)
        end
    end
end

--- @return {totalSize: number, downloadDict: Dictionary}
function AssetBundleMgr:CheckDownload()
    local totalSize = 0
    local downloadDict = Dictionary()
    local cloudUrl
    if IS_IOS_PLATFORM then
        cloudUrl = "http://35.201.99.208/release_4.x.x/iOS/"
    else
        cloudUrl = "http://35.201.99.208/release_4.x.x/Android/"
    end

    zgUnity.assetBundleMgr:Initialize(U_GameUtils.PrivateFolder() .. "/asset_bundles/", cloudUrl)

    for _, assetBundleInfo in pairs(self.assetBundleDict:GetItems()) do
        if zgUnity.assetBundleMgr:IsFileExist(assetBundleInfo.name, assetBundleInfo.hash) ~= true then
            downloadDict:Add(assetBundleInfo.name, assetBundleInfo.size)
            totalSize = totalSize + assetBundleInfo.size
        end
    end

    XDebug.Log("total size: " .. tostring(totalSize))
    XDebug.Log("download size: " .. tostring(downloadDict:Count()))

    return totalSize, downloadDict
end

--- @param assetPath string
--- @param componentName ComponentName
--- @return UnityEngine_GameObject
function AssetBundleMgr:GetAsset(assetPath, componentName)
    local rid = self.assetDict:Get(assetPath)
    if rid == nil then
        XDebug.Error("rid is nil: " .. assetPath)
        return nil
    end

    local assetBundle = self:GetAssetBundle(rid)

    if assetBundle == nil then
        XDebug.Error("assetBundle is nil: " .. assetPath)
        return nil
    end

    local extension = self.assetExtensionDict:Get(componentName)

    local asset = assetBundle:LoadAsset("Assets/AssetBundles/" .. assetPath .. extension, componentName)


    if asset == nil then
        XDebug.Error("asset is nil: " .. assetPath)
        return nil
    end

    return asset
end

--- @return UnityEngine_AssetBundle
--- @param rid number
function AssetBundleMgr:GetAssetBundle(rid)
    if self.loadedAssetBundleDict:IsContainKey(rid) then
        return self.loadedAssetBundleDict:Get(rid)
    end

    local ridList = List()
    self:LoadDependencies(rid, ridList)

    for _, v in ipairs(ridList:GetItems()) do

        local assetBundleInfo = self.assetBundleDict:Get(v)

        local assetBundle = zgUnity.assetBundleMgr:LoadAssetBundleFromLocal(assetBundleInfo.name)

        if assetBundle == nil then
            XDebug.Error("AssetBundle can't be nil: " .. assetBundleInfo.name)
            return
        else
            --XDebug.Log(LogUtils.ToDetail(assetBundle))
        end

        self.loadedAssetBundleDict:Add(v, assetBundle)
    end

    return self.loadedAssetBundleDict:Get(rid)
end

--- @param rid number
--- @param ridList List
function AssetBundleMgr:LoadDependencies(rid, ridList)
    local assetBundleInfo = self.assetBundleDict:Get(rid)
    if assetBundleInfo == nil then
        XDebug.Log("nil rid: " .. tostring(rid))
        return
    end

    self.loadedAssetBundleDict:Add(rid, true)

    local dependencies = assetBundleInfo.dependencyRids
    for _, key in pairs(dependencies) do
        if self.loadedAssetBundleDict:IsContainKey(key) == false then
            self:LoadDependencies(key, ridList)
        end
    end

    ridList:Add(assetBundleInfo.rid)
end