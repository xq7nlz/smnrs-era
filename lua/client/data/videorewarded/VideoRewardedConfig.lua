require("lua.client.scene.ui.home.uiFreeGemPopup.UIFreeGemPopupView")

--- @class VideoRewardedConfig
VideoRewardedConfig = Class(VideoRewardedConfig)

--- @return void
function VideoRewardedConfig:Ctor()
    self.limit = nil
    --- @type List<List<RewardInBound>>
    self.prizeList = nil

    self.dataAB = -1
end

--- @return List RewardInBound
function VideoRewardedConfig:Init()
    self.prizeList = nil
    if self.prizeList == nil then
        self.prizeList = List()

        local parsedData = nil
        self.dataAB = UIFreeGemPopupView.GetWatchAdConfigID()
        if self.dataAB == -1 then
            parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.VIDEO_REWARDED_PRIZE_PATH)
        else
            parsedData = CsvReaderUtils.ReadAndParseLocalFile(
                    string.format(CsvPathConstants.VIDEO_REWARDED_PRIZE_PATH_AB, self.dataAB))
        end
        --- @type List
        local rewardList
        for i = 1, #parsedData do
            local data = parsedData[i]
            if data['view_number'] ~= nil then
                rewardList = List()
                self.prizeList:Add(rewardList)
            end

            if self.dataAB == 1 and i == 5 then
                data['res_number'] = 20
                rewardList:Add(RewardInBound.CreateByParams(data))
                data['view_number'] = 6
                data['res_number'] = 100
            end
            rewardList:Add(RewardInBound.CreateByParams(data))
        end
    end
    return self.prizeList
end

--- @return List RewardInBound
--- @param viewNumber number
function VideoRewardedConfig:GetPrize(viewNumber)
    self:Init()
    return self.prizeList:Get(viewNumber)
end

--- @return number
function VideoRewardedConfig:GetLimit()
    if self.limit == nil then
        self:Init()
        self.limit = self.prizeList:Count()
        --local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.VIDEO_REWARDED_CONFIG_PATH)
        --self.limit = tonumber(parsedData[1]["limit"])
    end
    return self.limit
end

return VideoRewardedConfig