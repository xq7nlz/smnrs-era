--- @class VideoRewardedInBound
VideoRewardedInBound = Class(VideoRewardedInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function VideoRewardedInBound:ReadBuffer(buffer)
    self.numberVideoView = buffer:GetInt()
    --self.lastNumberVideoViewResetTime = buffer:GetLong()
    self.totalNumberVideoView = buffer:GetInt()

    self:SetTracking()
end

function VideoRewardedInBound:SetTracking()
    TrackingUtils.AddFirebaseProperty(FBProperties.REWARDED_VIDEO_COUNT, self.totalNumberVideoView)
end

function VideoRewardedInBound:CanWatch()
    return self.numberVideoView < ResourceMgr.GetVideoRewardedConfig():GetLimit()
end

function VideoRewardedInBound:IncreaseView()
    self.numberVideoView = self.numberVideoView + 1
    RxMgr.notificationWatchAds:Next()
end