--- @class UIGuildApplyModel : UIBaseModel
UIGuildApplyModel = Class(UIGuildApplyModel, UIBaseModel)

UIGuildApplyModel.DELAY_REQUEST = 20

--- @return void
function UIGuildApplyModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIGuildApply, "guild_apply")
    --- @type MoneyType
    self.foundMoneyType = MoneyType.GEM
    --- @type List
    self.currentListGuildInfo = nil
    --- @type number
    self.lastTimeRequestRecommendedGuild = nil
end

--- @return GuildSearchInfo
--- @param index number
function UIGuildApplyModel:GetGuildInfoByIndex(index)
    if self.currentListGuildInfo ~= nil then
        return self.currentListGuildInfo:Get(index)
    end
    return nil
end

--- @return number
function UIGuildApplyModel:IsAvailableTimeRequestRecommend()
    local guildData = zg.playerData:GetGuildData()
    return guildData.listGuildRecommendedInfo == nil
            or self.lastTimeRequestRecommendedGuild == nil
            or (zg.timeMgr:GetServerTime() - self.lastTimeRequestRecommendedGuild > UIGuildApplyModel.DELAY_REQUEST)
end

return UIGuildApplyModel