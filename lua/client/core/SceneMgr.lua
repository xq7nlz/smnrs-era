require "lua.client.scene.ui.UIBaseConfig"
require "lua.client.scene.config.ComponentName"
require "lua.client.core.unity.UnityCanvas"
require "lua.client.core.waiting.TouchObject"
require "lua.client.core.waiting.TouchUtils"

--- @class SceneMgr
SceneMgr = Class(SceneMgr)

--- @return void
function SceneMgr:Ctor()
    --- @type GameMode
    self.gameMode = GameMode.CHECK_DATA
    --- @type BaseScene
    self.currentScene = nil
    --- @type Dictionary
    self.sceneDict = Dictionary()
    --- @type UnityCanvas
    uiCanvas = UnityCanvas()
end

-------------------------ACTIVE SCENE -----------------------------
--- @return void
--- @param sceneName SceneConfig
function SceneMgr:SwitchScene(sceneName, data)
    self:DeActiveCurrentScene()
    self:ActiveScene(sceneName, data)
end

--- @return void
function SceneMgr:DeActiveCurrentScene()
    if self.currentScene ~= nil then
        self.currentScene:DeactiveScene()
    end
end

--- @return void
--- @param sceneName SceneConfig
function SceneMgr:ActiveScene(sceneName, data)
    if self.sceneDict:IsContainKey(sceneName) then
        self.currentScene = self.sceneDict:Get(sceneName)
    else
        self.currentScene = self:GetScene(sceneName)
        self.sceneDict:Add(sceneName, self.currentScene)
    end
    self.currentScene:ActiveScene(data)

    RxMgr.switchScene:Next(sceneName)
    RxMgr.finishLoading:Next()
end

--- @return BaseScene
--- @param sceneName string
function SceneMgr:GetScene(sceneName)
    local scenePath = string.format("lua.client.scene.%s", sceneName)
    local scene = require(scenePath)
    return scene(self)
end

function SceneMgr.RequestAndResetToMainArea()
    zg.netDispatcherMgr:Reset()
    zg.timeMgr:SyncClockTime()
    NetworkUtils.Reset()
    NetworkUtils.RequestPlayerData(function ()
        SceneMgr.ResetToMainArea()
        PlayerSetting.SaveData()
    end)
end

function SceneMgr.ResetToMainArea()
    zg.sceneMgr.gameMode = GameMode.MAIN_AREA
    zg.sceneMgr:SwitchScene(SceneConfig.HomeScene)
end

function SceneMgr.ResetToDownloadView()
    zg.audioMgr:StopMusic(MusicCtrl.mainMenuMusic)
    zg.sceneMgr.gameMode = GameMode.DOWNLOAD
    zg.sceneMgr:SwitchScene(SceneConfig.HomeScene)
end

function SceneMgr.ShowOutGameLongTime()
    zg.netDispatcherMgr:Reset()
    zg.timeMgr:SyncClockTime()
    NetworkUtils.Reset()
    NetworkUtils.RequestPlayerData(function()
        zg.sceneMgr.gameMode = GameMode.OUT_GAME_LONG_TIME
        zg.sceneMgr:SwitchScene(SceneConfig.HomeScene)
    end)
end

--- @return boolean
function SceneMgr.IsHomeScene()
    return zg.sceneMgr.currentScene.sceneName == SceneConfig.HomeScene
end
