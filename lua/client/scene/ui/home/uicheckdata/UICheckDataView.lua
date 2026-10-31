require "lua.client.scene.ui.common.UIBarPercentView"

--- @class UICheckDataView : UIBaseView
UICheckDataView = Class(UICheckDataView, UIBaseView)

--- @return void
--- @param model UICheckDataModel
function UICheckDataView:Ctor(model)
    UIBaseView.Ctor(self, model)
    --- @type UICheckDataModel
    self.model = model
    --- @type boolean
    self.loadFromResources = true
    self.coroutineText = nil
    self.textContent = ""
    self.textCount = 0
end

--- @return void
function UICheckDataView:OnReadyCreate()
    ---@type UICheckDataConfig
    self.config = UIBaseConfig(self.uiTransform)

    self.barPercent = UIBarPercentView(self.config.loadingBar)
    self.barPercent:SetActive(false)

    uiCanvas:SetBackgroundSize(self.config.loadingScreen)

    self:InitCheckData()
end

function UICheckDataView:InitCheckData()
    --- @type GoogleScriptDownloader
    self.googleScript = require("lua.client.core.main.GoogleScriptDownloader")
    --- @type LuaCsvDownloader
    self.luaCsv = require("lua.client.core.main.LuaCsvDownloader")

    self.googleScript.onSuccess = function()
        self:SetCoroutineText(LanguageUtils.LocalizeCommon("check_game_logic"))
        self.luaCsv.CheckDownload()
    end

    self.luaCsv.onSuccess = function(isReset, patch)
        if isReset then
            self:StopCoroutine()
            Main.ResetGame()
        else
            self:CheckResourcesAndShowDownload()
        end
    end
end

--- @return void
function UICheckDataView:OnReadyShow(result)
    Coroutine.start(function()
        coroutine.waitforendofframe()
        ComponentName.LoadMore()
        coroutine.waitforendofframe()
        print("UICheckDataView:OnReadyShow")
        if zgUnity.IsResetGame ~= false then
            self:CheckResourcesAndShowDownload()
        else
            self:CheckGameVersion()
        end
    end)
end

function UICheckDataView:CheckResourcesAndShowDownload()

    self:SetCoroutineText(LanguageUtils.LocalizeCommon("check_game_resources"))

    zg:InitMore()

    zg.assetBundleMgr:ReadManifest()
    self:CheckAssetBundles()
end

function UICheckDataView:CheckGameVersion()
    self:SetCoroutineText(LanguageUtils.LocalizeCommon("check_game_version"))
    self.googleScript.CheckDownload()
end

function UICheckDataView:CheckAssetBundles()
    local totalSize, downloadDict = zg.assetBundleMgr:CheckDownload()

    if totalSize <= 0 or IS_EDITOR_PLATFORM then
        PopupMgr.ShowAndHidePopup(UIPopupName.UIDownload, nil, UIPopupName.UICheckData)
    else
        local data = {}
        data.totalSize = totalSize
        data.onClickYes = function()
            self:DownloadAssetBundles(totalSize, downloadDict)
        end
        PopupMgr.ShowPopup(UIPopupName.UIPopupConfirmDownloadAssetBundle, data)
    end
end

--- @param totalSize number
--- @param downloadDict Dictionary
function UICheckDataView:DownloadAssetBundles(totalSize, downloadDict)
    print("UICheckDataView:CheckAssetBundle")
    print("Start Asset Bundle Download")
    TrackingUtils.AddFireBaseAssetBundleDownloadEvent(FBEvents.START_ASSET_BUNDLE_DOWNLOAD, "download_size" , (totalSize) / 1024^2)

    local assetBundleMgr = zgUnity.assetBundleMgr

    self:StopCoroutine()
    self:SetText(LanguageUtils.LocalizeCommon("check_resources_config"))
    self.barPercent:SetPercent(0)
    self.barPercent:SetActive(true)

    local downloadIndex = 0
    local downloadedSize = 0
    local totalFileDownloadAtRuntime = 0
    local downloadList = List()
    local inDownloadProcessing = true

    assetBundleMgr.onDownloadComplete = function(result, assetBundleName)
        if inDownloadProcessing == false then
            return
        end

        if result == false then
            inDownloadProcessing = false
            PopupUtils.ShowPopupDisconnect(DisconnectReason.CANT_DOWNLOAD_BUNDLE_ASSET, function()
                self:CheckAssetBundles()
            end)
        else
            --self:SetText(assetBundleName)

            downloadedSize = downloadedSize + downloadDict:Get(assetBundleName)
            self:SetViewPercent(downloadedSize / totalSize)

            local percent = (downloadedSize / totalSize) * 100

            if percent >= 0 and percent < 10 then
                self:SetText(LanguageUtils.LocalizeCommon("check_resources_config"))
            elseif percent >= 10 and percent < 20 then
                self:SetText(LanguageUtils.LocalizeCommon("check_game_resources"))
            elseif percent >= 20 and percent < 30 then
                self:SetText(LanguageUtils.LocalizeCommon("connecting_server"))
            elseif percent >= 30 and percent < 40 then
                self:SetText(LanguageUtils.LocalizeCommon("init_service"))
            elseif percent >= 40 and percent < 50 then
                self:SetText(LanguageUtils.LocalizeCommon("init_data_request"))
            elseif percent >= 50 and percent < 60 then
                self:SetText(LanguageUtils.LocalizeCommon("init_resource_request"))
            elseif percent >= 60 and percent < 70 then
                self:SetText(LanguageUtils.LocalizeCommon("download_asset_bundle"))
            elseif percent >= 70 and percent < 80 then
                self:SetText(LanguageUtils.LocalizeCommon("preload_resources"))
            elseif percent >= 80 and percent < 90 then
                self:SetText(LanguageUtils.LocalizeCommon("load_user_data"))
            elseif percent >= 90 then
                self:SetText(LanguageUtils.LocalizeCommon("start_game"))
            end

            downloadDict:Add(assetBundleName, 0)

            if downloadDict:Count() == downloadIndex then
                PopupMgr.ShowAndHidePopup(UIPopupName.UIDownload, nil, UIPopupName.UICheckData)
                TrackingUtils.AddFireBaseAssetBundleDownloadEvent(FBEvents.END_ASSET_BUNDLE_DOWNLOAD)
                print("End Asset Bundle Download")
            else
                --- @type string
                local assetBundleName = downloadList:Get(downloadIndex + 1)
                assetBundleMgr:DownloadAssetBundle(assetBundleName)
                downloadIndex = downloadIndex + 1
            end
        end
    end


    for assetBundleName, size in pairs(downloadDict:GetItems()) do
        --XDebug.Log(assetBundleName .. " => " .. tostring(size))
        --assetBundleMgr:DownloadAssetBundle(assetBundleName)
        downloadList:Add(assetBundleName)
        if totalFileDownloadAtRuntime < 1 then
            assetBundleMgr:DownloadAssetBundle(assetBundleName)
            downloadIndex = downloadIndex + 1
            totalFileDownloadAtRuntime = totalFileDownloadAtRuntime + 1
        end
    end
end

function UICheckDataView:SetCoroutineText(content)
    self.textCount = 0
    self.textContent = content
    self:StarCoroutineText()
end

function UICheckDataView:SetText(content)
    self.config.textGuide.text = content
end

function UICheckDataView:StarCoroutineText()
    self:StopCoroutine()
    local timeDelay = 3
    self.coroutineText = Coroutine.start(function()
        while true do
            if Main.IsNull(self.config.textGuide) then
                self:StopCoroutine()
                break
            end
            if self.textCount == 0 then
                self:SetText(self.textContent)
            elseif self.textCount == 1 then
                self:SetText(self.textContent .. " .")
            elseif self.textCount == 2 then
                self:SetText(self.textContent .. " ..")
            elseif self.textCount == 3 then
                self:SetText(self.textContent .. " ...")
            end
            coroutine.waitforseconds(timeDelay)
            timeDelay = 1
            self.textCount = self.textCount + 1
            if self.textCount == 4 then
                self.textCount = 0
            end
        end
    end)
end

function UICheckDataView:StopCoroutine()
    if self.coroutineText ~= nil then
        Coroutine.stop(self.coroutineText)
        self.coroutineText = nil
    end
end

function UICheckDataView:SetViewPercent(percent)
    self.barPercent:SetPercent(percent)
end

function UICheckDataView:Hide()
    UIBaseView.Hide(self)
    self:StopCoroutine()
end

