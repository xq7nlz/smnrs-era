--- @class GoogleScriptDownloader
local GoogleScriptDownloader = {}

local function GetUrl(backUpIp, backUpPort)
    local ip = backUpIp or NetConfig.loadBalancerIP
    local port = backUpPort or NetConfig.loadBalancerPort

    local version = VERSION_CLIENT_BUILD
    if zgUnity.IsTest then
        version = string.format("%s-%d", version, U_PlayerPrefs.GetInt(PlayerPrefsKey.PATCH_TEST, 0))
    end
    return string.format(NetConfig.REMOTE_URL, ip, port, version)
end

local function ParseContent(content)
    print(string.format("[GoogleScriptDownloader]download success [%s] len[%d]", content, string.len(content)))
    if string.len(content) > 0 then
        GOOGLE_SCRIPT = json.decode(content)
        if GOOGLE_SCRIPT.version ~= nil then
            VERSION = GOOGLE_SCRIPT.version
        end
        GoogleScriptDownloader.onSuccess()
    else
        PopupUtils.ShowPopupGoToStore()
    end
end

local function DownloadConfigBackUp()
    local onSuccess = function(content)
        ParseContent(content)
    end
    local onFailed = function()
        TrackingUtils.AddFirebaseAssetDownloaded(AssetDownloadedStep.ShowFailedGoogleScript)
        PopupUtils.ShowPopupDisconnect(DisconnectReason.CANT_DOWNLOAD_GOOGLE_SCRIPT, GoogleScriptDownloader.CheckDownload)
    end
    NetworkUtils.TryRequestData(5, GetUrl(NetConfig.backUpRemoteConfigIp), onSuccess, onFailed)
end

local function DownloadConfig()
    local onSuccess = function(content)
        ParseContent(content)
    end
    local onFailed = function()
        DownloadConfigBackUp()
    end
    NetworkUtils.TryRequestData(5, GetUrl(), onSuccess, onFailed)
end

local function FakeDownloadConfig()
    local content = "{\"isVnReview\":true,\"patch\":5,\"numberFiles\":2159,\"hash\":\"f3206a44267a26637122fc7ebe810491bfa77cf48866199b2c7c1a801b2ea647\",\"lua\":5,\"csv\":5}"
    ParseContent(content)
end

GoogleScriptDownloader.onSuccess = nil

function GoogleScriptDownloader.CheckDownload()
    if IS_MOBILE_PLATFORM then
        DownloadConfig()
    else
        FakeDownloadConfig()
    end
end

return GoogleScriptDownloader