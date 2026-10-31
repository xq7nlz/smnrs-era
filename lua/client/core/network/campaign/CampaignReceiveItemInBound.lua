--- @class CampaignReceiveItemInBound
CampaignReceiveItemInBound = Class(CampaignReceiveItemInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function CampaignReceiveItemInBound:Ctor(buffer)
    --- @type List
    self.listItem = NetworkUtils.GetRewardInBoundList(buffer)
end

--- @return void
function CampaignReceiveItemInBound:ToString()
    return LogUtils.ToDetail(self)
end