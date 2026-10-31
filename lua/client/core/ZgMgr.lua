--- @class ZgMgr
ZgMgr = Class(ZgMgr)
ZgMgr.targetFrameRate = 50

local U_Width = U_Screen.width
local U_Height = U_Screen.height

--- @return void
function ZgMgr:Ctor()
    --- @type boolean
    self.canPlayPVEMode = (zgUnity.IsPVE or zgUnity.IsBossFight) and IS_EDITOR_PLATFORM
    --- @type boolean
    self.isInitTrackingCompleted = false
end

--- @return void
function ZgMgr:Run()
    print("ZgMgr:Run")
    self:LoadClientData()
    self:InitMgr()
    self:InitLibs()
    self:LaunchGame()
end

--- @return void
function ZgMgr:LoadClientData()
    require "lua.client.data.Player.PlayerSetting"
    if PlayerSetting.IsSavedData() then
        PlayerSetting.LoadData()
    end
    self:SetClientGraphic(nil)
end

-- @return void
function ZgMgr:InitMgr()
    require "lua.client.core.SceneMgr"
    self.sceneMgr = SceneMgr()
    require "lua.client.core.audio.AudioMgr"
    self.audioMgr = AudioMgr()
    require "lua.client.core.LanguageMgr"
    self.languageMgr = LanguageMgr()
    require "lua.client.scene.ui.manager.PopupMgr"
    self.popupMgr = PopupMgr()
end

function ZgMgr:InitMore()
    require "lua.client.core.ClientRequire"
    require "lua.logicBattle._gen._LuaRequire"
    require "lua.client.core.network.OpCode"
    require "lua.client.core.ResourceMgr"
    require "lua.client.core.event.NetDispatcherMgr"
    self.netDispatcherMgr = NetDispatcherMgr()
    require "lua.client.core.TimeMgr"
    self.timeMgr = TimeMgr()
    require "lua.client.core.BattleMgr"
    self.battleMgr = BattleMgr()
    require "lua.client.core.network.NetworkMgr"
    self.networkMgr = NetworkMgr()
    require "lua.client.battleShow.BattleEffectMgr"
    self.battleEffectMgr = BattleEffectMgr()
    require "lua.client.core.iap.IAPMgr"
    self.iapMgr = IAPMgr()
    require "lua.client.data.Player.PlayerData"
    self.playerData = PlayerData()
    require "lua.client.core.main.AssetBundleMgr"
    self.assetBundleMgr = AssetBundleMgr()

    require("lua.client.log.ServerLogger")
    serverLog:InitListenLogMessage()

    self:InitMediationAds()
    self:InitPause()
end

--- @return void
function ZgMgr:InitLibs()
    require "lua.client.utils.tracking.TrackingUtils"
    require "lua.client.utils.tracking.MktTracking"

    local initTracking = function()
        zgUnity.appsflyer = CS.AppsflyerUtils("Ge7ssp4Hs6ZKXqQ2UU6yeD", self:GetAppsFlyerId(), false)
        self.isInitTrackingCompleted = true
    end

    if IS_EDITOR_PLATFORM == false then
        local status, message = pcall(function()
            local onGetRemoteConfigFirebaseSuccess = function()
                local loginAlready = PlayerSettingData.playerId ~= nil
                if (loginAlready) then
                    zg.playerData:SetABTestValFromFireBase()
                    RemoteConfigSetOutBound.UpdateABTest()
                end
            end
            zgUnity.firebase = CS.FirebaseUtils(false, onGetRemoteConfigFirebaseSuccess)
        end)
        if status == false then
            XDebug.Error("Cannot init firebase remote config on legacy version")
            zgUnity.firebase = CS.FirebaseUtils(false)
        end

        Coroutine.start(function()
            while zgUnity.firebase.Initialized == false do
                coroutine.waitforendofframe()
            end
            initTracking()
            TrackingUtils.AddFirebasePendingEvent()
        end)
        TrackingUtils.AddFirebaseAssetDownloaded(AssetDownloadedStep.Init)
    else
        initTracking()
    end

    if IS_ANDROID_PLATFORM then
        local status, message = pcall(function()
            zgUnity.googleReviewUtils = CS.GoogleReviewUtils()
        end)
        if status == false then
            XDebug.Error(message)
        end
    end
end

--- @return void
function ZgMgr:InitMediationAds()
    require("lua.client.core.network.videoRewarded.VideoRewardedUtils")
    VideoRewardedUtils.Init()
end

--- @return void
function ZgMgr:LaunchGame()
    print("launch game")
    if self.canPlayPVEMode then
        self:PlayPVEMode()
    else
        self.sceneMgr:ActiveScene(SceneConfig.HomeScene)
    end
end

--- @return void
function ZgMgr:PlayPVEMode()
    Coroutine.start(function()
        ComponentName.LoadMore()
        coroutine.waitforseconds(1)
        require "lua.client.core.ClientRequire"
        require "lua.logicBattle._gen._LuaRequire"
        require "lua.client.core.ResourceMgr"
        require "lua.client.core.BattleMgr"
        self.battleMgr = BattleMgr()
        require "lua.client.battleShow.BattleEffectMgr"
        self.battleEffectMgr = BattleEffectMgr()
        if zgUnity.IsBossFight then
            self.battleMgr:RunBossFightMode()
        else
            self.battleMgr:RunPVEMode()
        end
        self.sceneMgr:SwitchScene(SceneConfig.BattleTestScene)
        PopupMgr.ShowPopup(UIPopupName.UIBattleTestTool)
    end)
end

--- @return void
function ZgMgr:InitPause()
    require "lua.client.config.const.PauseStatus"
    --- @param status PauseStatus
    zgUnity.onPause = function(status)
        RxMgr.applicationPause:Next(status)
        if status == PauseStatus.PAUSE or (status == PauseStatus.UN_FOCUS and IS_EDITOR_PLATFORM) then
            self.timeMgr:SetPauseTime()
        elseif (status == PauseStatus.UN_PAUSE or (status == PauseStatus.FOCUS and IS_EDITOR_PLATFORM)) then
            if self:CanCheckOverTime() and self.timeMgr:PauseOverTime() then
                if SceneMgr.IsHomeScene() then
                    self:ShowOutGameLongTime()
                end
            else
                self.playerData.waitingPauseAction = false
                self.timeMgr:ContinueUpdateTime()
            end
        end
    end
end

function ZgMgr:ShowOutGameLongTime()
    PopupUtils.ShowTimeOut(function()
        SceneMgr.ShowOutGameLongTime()
    end)
end

function ZgMgr:CanCheckOverTime()
    return self.networkMgr.isConnected
            and self.playerData.waitingPauseAction == false
            and UIBaseView.IsActiveTutorial() == false
end

function ZgMgr:OnDestroy()
    self.popupMgr:OnDestroy()
    self.audioMgr:OnDestroy()
end

function ZgMgr:GetAppsFlyerId()
    return APPSFLYER_ID()
end

--- @param graphicQualityType GraphicQualityType
function ZgMgr:SetClientGraphic(graphicQualityType)
    if PlayerSettingData.graphicQuality == graphicQualityType
            and graphicQualityType ~= nil then
        return
    end
    graphicQualityType = graphicQualityType or PlayerSettingData.graphicQuality
    PlayerSettingData.graphicQuality = graphicQualityType
    PlayerSetting.SaveData()

    U_Application.targetFrameRate = TargetFrameRate:Get(graphicQualityType)

    if true then
        return
    end
    if graphicQualityType == nil or graphicQualityType == "" then
        if U_Width >= 1920 then
            self:SetClientGraphic(GraphicQualityType.HIGH)
        elseif U_Width >= 1280 then
            self:SetClientGraphic(GraphicQualityType.MEDIUM)
        else
            self:SetClientGraphic(GraphicQualityType.LOW)
        end
        return
    end

    local setResolution = function(width, height)
        local heightScale = U_Height / 1080
        local widthScale = U_Width / 1920

        if widthScale > heightScale then
            widthScale = widthScale / heightScale
            heightScale = 1
        else
            heightScale = heightScale / widthScale
            widthScale = 1
        end
        U_Screen.SetResolution(width * widthScale, U_Height, true)
        U_Screen.SetResolution(width * widthScale, height * heightScale, true)
    end

    if graphicQualityType == GraphicQualityType.LOW then
        setResolution(848, 480)
    elseif graphicQualityType == GraphicQualityType.MEDIUM then
        setResolution(1280, 720)
    else
        setResolution(1920, 1080)
    end
end