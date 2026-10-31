require "lua.client.battleShow.BattleView.VideoPlayer.VideoPlayerConfig"

--- @class VideoPlayerView
VideoPlayerView = Class(VideoPlayerView)

VideoPlayerView.DefaultClipSize = U_Vector2(1280, 720)

--- @param transform UnityEngine_Transform
--- @param renderTexture UnityEngine_RenderTexture
--- @param videoClip UnityEngine_Video_VideoClip
function VideoPlayerView:Ctor(transform, renderTexture, videoClip)
    --- @type VideoPlayerConfig
    self.config = UIBaseConfig(transform)
    --- @type number
    self.fadeDuration = 0

    self.fadeTweener = nil

    self:_Init(renderTexture, videoClip)
end

--- @param renderTexture UnityEngine_RenderTexture
--- @param videoClip UnityEngine_Video_VideoClip
function VideoPlayerView:_Init(renderTexture, videoClip)
    local screenSize = uiCanvas.config.canvas:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta
    local screenRatio = screenSize.x / screenSize.y

    local videoRatio = VideoPlayerView.DefaultClipSize.x / VideoPlayerView.DefaultClipSize.y

    self.config.videoPlayer.targetTexture = renderTexture
    self.config.renderTexture.texture = renderTexture
    self.config.videoPlayer.clip = videoClip

    local sizeDelta = screenSize
    if screenRatio >= videoRatio then
        local mul = screenSize.x / VideoPlayerView.DefaultClipSize.x
        sizeDelta.y = VideoPlayerView.DefaultClipSize.y * mul
    else
        local mul = screenSize.y / VideoPlayerView.DefaultClipSize.y
        screenSize.x = VideoPlayerView.DefaultClipSize.x * mul
    end
    self.config.renderRect.sizeDelta = sizeDelta
    self.config.renderRect.pivot = U_Vector2(0.5, 0.5)

    self:PrepareVideo()
end

function VideoPlayerView:PrepareVideo()
    self.config.videoPlayer:Prepare()
end

--- @return boolean
function VideoPlayerView:IsVideoPrepared()
    return self.config.videoPlayer.isPrepared
end

--- @param onStartFadeOut function
--- @param fadeInDuration number
--- @param fadeOutDuration number
function VideoPlayerView:PlayVideo(onStartFadeOut, fadeInDuration, fadeOutDuration)
    fadeInDuration = fadeInDuration or self.fadeDuration
    fadeOutDuration = fadeOutDuration or self.fadeDuration

    if fadeInDuration > 0 then
        self:_SetRendererAlpha(0)
        self.config.renderTexture:DOFade(1, fadeInDuration)
    else
        self:_SetRendererAlpha(1)
    end
    self.config.canvas.enabled = true
    self.config.videoPlayer:Play()

    if fadeOutDuration >= 0 then
        self.fadeTweener = self.config.renderTexture:DOFade(0, fadeOutDuration)
                               :SetDelay(self.config.videoPlayer.clip.length - fadeOutDuration)
                               :OnStart(function()
            if onStartFadeOut ~= nil then
                onStartFadeOut()
            end
        end)                   :OnComplete(function()
            self.config.canvas.enabled = false
            self.config.videoPlayer:Pause()
            self.config.videoPlayer.time = 0.05
        end)
    else

    end
end

function VideoPlayerView:ReturnPool()
    if self.fadeTweener ~= nil then
        self.fadeTweener:Kill()
        self.fadeTweener = nil
    end

    self:Stop()

    SmartPool.Instance:DespawnGameObject(AssetType.Battle, "video_player_view", self.config.transform)
end

--- @param isFlipHorizontal boolean
function VideoPlayerView:AdjustRenderRect(isFlipHorizontal)
    local scale = self.config.renderRect.localScale
    if isFlipHorizontal then
        scale.x = -1
        --self.config.renderRect.anchorMin = U_Vector2(1, 0.5)
        --self.config.renderRect.anchorMax = U_Vector2(1, 0.5)
    else
        scale.x = 1
        --self.config.renderRect.anchorMin = U_Vector2(0, 0.5)
        --self.config.renderRect.anchorMax = U_Vector2(0, 0.5)
    end
    self.config.renderRect.anchorMin = U_Vector2(0.5, 0.5)
    self.config.renderRect.anchorMax = U_Vector2(0.5, 0.5)

    self.config.renderRect.anchoredPosition3D = U_Vector3.zero
    self.config.renderRect.localScale = scale
end

--- @param timeScale number
function VideoPlayerView:AdjustPlayBackSpeed(timeScale)
    self.config.videoPlayer.playbackSpeed = timeScale
end

function VideoPlayerView:_SetRendererAlpha(alpha)
    local color = self.config.renderTexture.color
    color.a = alpha
    self.config.renderTexture.color = color
end

function VideoPlayerView:PlayLoop()
    self.config.videoPlayer:Play()
end

function VideoPlayerView:Stop()
    self.config.videoPlayer:Stop()
    self.config.videoPlayer.clip = nil
    self.config.videoPlayer.targetTexture = nil
end