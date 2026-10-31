--- @class EventHeroTrialHistory
EventHeroTrialHistory = Class(EventHeroTrialHistory)

--- @param buffer UnifiedNetwork_ByteBuf
function EventHeroTrialHistory:Ctor(buffer, size)
    if buffer then
        self:ReadBuffer(buffer, size)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventHeroTrialHistory:ReadBuffer(buffer, size)
    ---@type Dictionary
    self.historyDict = Dictionary()
    local size = size or buffer:GetByte()
    for i = 1, size do
        local data = {}
        data.difficulty = buffer:GetInt()
        data.isWin = buffer:GetBool()
        data.summonerId = buffer:GetInt()
        data.summonerStar = buffer:GetInt()
        data.createdTime = buffer:GetLong()
        ---@type DetailTeamFormation
        data.teamFormation = DetailTeamFormation.CreateByBuffer(buffer)
        ---@type List
        data.listReward = List()
        for k = 1, buffer:GetByte() do
            local rewardInBound = RewardInBound.CreateByBuffer(buffer)
            if rewardInBound then
                data.listReward:Add(rewardInBound)
            end
        end
        self.historyDict:Add(i, data)
    end
    return self.historyDict
end