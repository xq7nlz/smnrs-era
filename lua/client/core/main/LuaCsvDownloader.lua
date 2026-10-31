--- @type string
local LUA = "lua"
local CSV = "csv"
local DOWNLOAD_SUCCESS = 2
--- @type CS_GoogleScript
local server
--- @type {build:string, patch:number,lua:number,csv:number}
local client
--- @class LuaCsvDownloader
local LuaCsvDownloader = { }
--- @type boolean
local isShowingDisconnect = false
--- @type boolean
local needReloadLua = false

local function ShowDisconnect(folder)
    if isShowingDisconnect == false then
        isShowingDisconnect = true
        TrackingUtils.AddFirebaseAssetDownloaded(AssetDownloadedStep.ShowFailedLuaCsv)
        local logicCode = folder == LUA and DisconnectReason.CANT_DOWNLOAD_LUA_ZIP or DisconnectReason.CANT_DOWNLOAD_CSV_ZIP
        PopupUtils.ShowPopupDisconnect(logicCode, function()
            isShowingDisconnect = false
            LuaCsvDownloader.CheckDownload()
        end)
    end
end

--- @return CS_BundleManifest
local function GetLocalLuaCsvVersion()
    if U_PlayerPrefs.HasKey(PlayerPrefsKey.LUA_CSV_VERSION) then
        return json.decode(U_PlayerPrefs.GetString(PlayerPrefsKey.LUA_CSV_VERSION))
    end
    return { patch = 0, lua = 0, csv = 0 }
end

--- @return void
local function SaveLuaCsvVersion()
    if client ~= nil then
        print("SaveLuaCsvVersion")
        U_PlayerPrefs.SetString(PlayerPrefsKey.LUA_CSV_VERSION, json.encode(client))
    end
end

--- @return string
--- @param folder string
local function GetDownloadPath(folder)
    assert(server.patch ~= 0)
    local storage = NetConfig.googleStorage
    return string.format("%s/%s/patch_%d/%s.zip", storage, VERSION, server.patch, folder)
end

local function CheckDownloadZip(folder, localVersion, serverVersion, onSuccessDownloadZip)
    print(string.format("url: %s, folder: %s, localVersion: %d, serverVersion: %d", zgUnity.UrlLua, folder, localVersion, serverVersion))
    local decompressPath = string.format("%s%s/", zgUnity.UrlLua, folder)

    local onSuccess = function()
        onSuccessDownloadZip(folder)
    end

    local triggerReload = function()
        if folder == LUA then
            needReloadLua = true
        end
    end

    if serverVersion ~= 0 and (localVersion ~= serverVersion) then
        triggerReload()
        local MAX_RETRY = 5
        local localZipPath = string.format("%s%s.zip", zgUnity.UrlLua, folder)
        local numberCheck = 0
        local onFailed

        onFailed = function(error)
            numberCheck = numberCheck + 1
            print(string.format("[LuaCsvDownloader]lua csv check download: retry %d =>", numberCheck, error))
            if numberCheck < MAX_RETRY then
                U_GameUtils.DownloadZip(GetDownloadPath(folder), localZipPath, decompressPath, onSuccess, onFailed)
            else
                ShowDisconnect(folder)
            end
        end
        if IS_MOBILE_PLATFORM then
            U_GameUtils.SafeClearDir(decompressPath)
        end

        local serverZipPath = GetDownloadPath(folder, numberCheck)
        U_GameUtils.DownloadZip(serverZipPath, localZipPath, decompressPath, onSuccess, onFailed)
        print(string.format("server[%s]\n local[%s]\n decompress[%s]", serverZipPath, localZipPath, decompressPath))
    else
        if serverVersion == 0 then
            triggerReload()
            U_GameUtils.DeleteDirectory(decompressPath)
        end
        onSuccess()
    end
end

--- @param isReset boolean
local function OnDownloadSuccess(isReset)
    LuaCsvDownloader.onSuccess(isReset, GOOGLE_SCRIPT.patch)
end

local function DownloadLuaCsv()
    local countSuccessDownload = 0

    print(string.format("local version => build: %s, patch: %s, lua: %s, csv: %s", VERSION, client.patch, client.lua, client.csv))
    if server.patch == 0 then
        client.lua = 0
        client.csv = 0
    end

    local onSuccess = function(type)
        client[type] = server[type]
        countSuccessDownload = countSuccessDownload + 1
        if countSuccessDownload == DOWNLOAD_SUCCESS then
            client.patch = server.patch
            if needReloadLua then
                SaveLuaCsvVersion()
                OnDownloadSuccess(true)
            else
                OnDownloadSuccess(false)
            end
        end
        SaveLuaCsvVersion()
    end

    CheckDownloadZip(LUA, client.lua, server.lua, onSuccess)
    CheckDownloadZip(CSV, client.csv, server.csv, onSuccess)
end

local function FakeDownload()
    OnDownloadSuccess(false)
end

--- @type Subject
LuaCsvDownloader.onSuccess = nil

LuaCsvDownloader.CheckDownload = function()
    if IS_MOBILE_PLATFORM then
        needReloadLua = false
        client = GetLocalLuaCsvVersion()
        server = GOOGLE_SCRIPT
        print("lua csv check download")
        if server.patch ~= client.patch then
            DownloadLuaCsv()
        else
            OnDownloadSuccess(false)
        end
    else
        FakeDownload()
    end
end

return LuaCsvDownloader