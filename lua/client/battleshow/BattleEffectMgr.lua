require "lua.client.scene.ui.battle.uiBattleTextLog.UIBattleTextLog"
require "lua.client.battleShow.BondLink.BondLink"
require "lua.client.battleShow.ClientEffect.ClientEffect"
require "lua.client.battleShow.ClientEffect.SpineClientEffect"
require "lua.client.battleShow.BattleView.VideoPlayer.VideoPlayerView"

--- @class BattleEffectManager
BattleEffectMgr = Class(BattleEffectMgr)

function BattleEffectMgr:Ctor()
    --- @type List -- UIBattleTextLog
    self.activeBattleTextLog = List()
    --- @type List -- <ClientEffect>
    self.activeClientEffect = List()
    --- @type List -- <UIBattleEffectIcon>
    self.activeBattleEffectIcon = List()
    --- @type List -- <UIBattleMarkIcon>
    self.activeBattleMarkIcon = List()

    --- @type Dictionary -- <string, UnityEngine_Shader>
    self.shaderDict = Dictionary()

    --- @type UnityEngine_Camera
    self._mainCamera = nil

    self._shakeTweener = nil

    --- @type Dictionary -- <UnityEngine_GameObject, BondLink>
    self._bondLinkDictionary = Dictionary()

    --- @type Dictionary -- {string, UnityEngine_Video_VideoClip}
    self.loadedVideo = Dictionary()

    --- @type Dictionary -- {string, VideoPlayerView}
    self.videoPlayerDict = Dictionary()
end

--- @param videoClip UnityEngine_Video_VideoClip
--- @param onFinished function
function BattleEffectMgr:GetVideoPlayer(videoClip, onFinished)
    local videoRenderTexture = U_RenderTexture(VideoPlayerView.DefaultClipSize.x, VideoPlayerView.DefaultClipSize.y, 24, U_RenderTextureFormat.ARGB32)
    local onSpawned = function(gameObject)
        local videoPlayerView = VideoPlayerView(gameObject.transform, videoRenderTexture, videoClip)
        if onFinished then
            onFinished(videoPlayerView)
        end
    end
    SmartPool.Instance:SpawnGameObjectAsync(AssetType.Battle, "video_player_view", onSpawned)
end

--- @return UIBattleTextLog
function BattleEffectMgr:GetUIBattleTextLog()
    --- @type UIBattleTextLog
    local uiBattleTextLog = SmartPool.Instance:SpawnClientEffectByPoolType(AssetType.GeneralBattleEffect, GeneralEffectPoolType.BattleTextLog, "battle_text_log")
    self.activeBattleTextLog:Add(uiBattleTextLog)
    return uiBattleTextLog
end

--- @return UIBattleEffectIcon
function BattleEffectMgr:GetUIBattleEffectIcon()
    --- @type UIBattleEffectIcon
    local uiBattleEffectIcon = SmartPool.Instance:SpawnClientEffectByPoolType(AssetType.GeneralBattleEffect, GeneralEffectPoolType.BattleEffectIcon)
    self.activeBattleEffectIcon:Add(uiBattleEffectIcon)
    return uiBattleEffectIcon
end

--- @return UIBattleMarkIcon
--- @param effectLogType EffectLogType
function BattleEffectMgr:GetUIBattleMarkIcon(effectLogType)
    --- @type UIBattleMarkIcon
    local uiBattleMarkIcon = SmartPool.Instance:SpawnClientEffectByPoolType(AssetType.GeneralBattleEffect, GeneralEffectPoolType.BattleMarkIcon)
    uiBattleMarkIcon:SetIconByType(effectLogType)
    self.activeBattleMarkIcon:Add(uiBattleMarkIcon)
    return uiBattleMarkIcon
end

--- @param battleTextLog UIBattleTextLog
function BattleEffectMgr:ReleaseBattleTextLog(battleTextLog)
    self.activeBattleTextLog:RemoveByReference(battleTextLog)
end

--- @param uiBattleEffectIcon UIBattleEffectIcon
function BattleEffectMgr:ReleaseUIBattleEffectIcon(uiBattleEffectIcon)
    self.activeBattleEffectIcon:RemoveByReference(uiBattleEffectIcon)
end

--- @param uiBattleMarkIcon UIBattleMarkIcon
function BattleEffectMgr:ReleaseUIBattleMarkIcon(uiBattleMarkIcon)
    self.activeBattleMarkIcon:RemoveByReference(uiBattleMarkIcon)
end

--- @return BondLink
--- @param gameObject UnityEngine_GameObject
function BattleEffectMgr:GetBondLink(gameObject)
    if self._bondLinkDictionary:IsContainKey(gameObject) == false then
        local bondLink = BondLink(gameObject)
        self._bondLinkDictionary:Add(gameObject, bondLink)
        return bondLink
    end
    return self._bondLinkDictionary:Get(gameObject)
end

function BattleEffectMgr:OnHide()
    self:ReturnPool()
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function BattleEffectMgr:GetClientEffect(effectType, effectName, initEffect)
    --- @type ClientEffect
    local clientEffect
    if effectType == AssetType.GeneralBattleEffect then
        clientEffect = SmartPool.Instance:SpawnClientEffectByPoolType(AssetType.GeneralBattleEffect, GeneralEffectPoolType.ClientEffect, effectName)
    elseif effectType == AssetType.HeroBattleEffect then
        clientEffect = SmartPool.Instance:SpawnClientEffectByPoolType(AssetType.HeroBattleEffect, GeneralEffectPoolType.ClientEffect, effectName)
    elseif effectType == AssetType.DefenseBattleEffect then
        clientEffect = SmartPool.Instance:SpawnClientEffectByPoolType(AssetType.DefenseBattleEffect, GeneralEffectPoolType.ClientEffect, effectName)
    end
    if clientEffect ~= nil then
        self.activeClientEffect:Add(clientEffect)
    end
    clientEffect.isActive = true
    if initEffect == true then
        if clientEffect.isInited == false then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            clientEffect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            clientEffect.isInited = true

        end
    end
    return clientEffect
end

--- @param clientEffect ClientEffect
function BattleEffectMgr:ReleaseClientEffect(clientEffect)
    self.activeClientEffect:RemoveByReference(clientEffect)
end

function BattleEffectMgr:ReturnPool()
    self:ReturnPoolActiveClientEffect()
    self:ReturnPoolActiveBattleTextLog()
    self:ReturnPoolActiveBattleEffectIcon()
    self:ReturnPoolVideoPlayer()
end

function BattleEffectMgr:ReturnPoolActiveClientEffect()
    for i = self.activeClientEffect:Count(), 1, -1 do
        self.activeClientEffect:Get(i):ReturnPool()
    end
    self.activeClientEffect = List()
end

function BattleEffectMgr:ReturnPoolActiveBattleTextLog()
    for i = self.activeBattleTextLog:Count(), 1, -1 do
        self.activeBattleTextLog:Get(i):ReturnPool()
    end
end

function BattleEffectMgr:ReturnPoolActiveBattleEffectIcon()
    for i = self.activeBattleEffectIcon:Count(), 1, -1 do
        self.activeBattleEffectIcon:Get(i):ReturnPool()
    end
end

function BattleEffectMgr:ReturnPoolVideoPlayer()
    for _, v in pairs(self.videoPlayerDict:GetItems()) do
        --- @type VideoPlayerView
        local videoPlayerView = v
        videoPlayerView:ReturnPool()
    end
    self.videoPlayerDict = Dictionary()
    self.loadedVideo = Dictionary()
end

--- @param videoClipName string
function BattleEffectMgr:PreloadVideoClip(videoClipName)
    if self.loadedVideo:IsContainKey(videoClipName) == false then
        local videoClip = ResourceLoadUtils.LoadVideoClip(videoClipName)
        self.loadedVideo:Add(videoClipName, videoClip)
    end
    if self.videoPlayerDict:IsContainKey(videoClipName) == false then
        --- @param videoPlayerView VideoPlayerView
        local onSpawned = function(videoPlayerView)
            videoPlayerView:AdjustPlayBackSpeed(U_Time.timeScale)
            self.videoPlayerDict:Add(videoClipName, videoPlayerView)
        end
        self:GetVideoPlayer(self.loadedVideo:Get(videoClipName), onSpawned)
    end
end

--- @param videoClipName string
--- @param isFlipHorizontal boolean
function BattleEffectMgr:ShowVideoCutScene(videoClipName, isFlipHorizontal, fadeOutDuration, fadeInDuration, onStartPlayVideo, onStartFadeOut)
    if self.videoPlayerDict:IsContainKey(videoClipName) == false then
        XDebug.Error(string.format("[%s] wasn't loaded", videoClipName))
        return
    end
    --- @type VideoPlayerView
    local videoPlayerView = self.videoPlayerDict:Get(videoClipName)
    if videoPlayerView:IsVideoPrepared() == false then
        XDebug.Warning(string.format("Error Video not prepared %s", videoClipName))
        return
    end
    onStartPlayVideo()
    videoPlayerView:PlayVideo(function ()
        onStartFadeOut()
    end, fadeOutDuration, fadeInDuration)
    videoPlayerView:AdjustRenderRect(isFlipHorizontal)
end

--- @param timeScale number
function BattleEffectMgr:AdjustVideoSpeed(timeScale)
    for _, v in pairs(self.videoPlayerDict:GetItems()) do
        --- @type VideoPlayerView
        local videoPlayerView = v
        videoPlayerView:AdjustPlayBackSpeed(timeScale)
    end
end