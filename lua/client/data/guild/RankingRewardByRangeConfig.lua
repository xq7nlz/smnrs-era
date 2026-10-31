--- @class RankingRewardByRangeConfig
RankingRewardByRangeConfig = Class(RankingRewardByRangeConfig)

--- @param minRank number
--- @param maxRank number
function RankingRewardByRangeConfig:Ctor(minRank, maxRank)
    --- @type number
    self.minRank = minRank
    --- @type number
    self.maxRank = maxRank
    --- @type List<RewardInBound>
    self.listRewardConfig = List()
    --- @type Dictionary
    self.dicGuildRoleRewards = Dictionary()
end

--- @param rewardData RewardInBound
function RankingRewardByRangeConfig:AddRewardToList(rewardData,guildRole)

    if (guildRole ~= nil) then
        local guildRoleNumber = tonumber(guildRole)
        --XDebug.Log("ADD DIC " .. guildRole)
        if (self.dicGuildRoleRewards:IsContainKey(guildRoleNumber)) then
            self.dicGuildRoleRewards:Get(guildRoleNumber):Add(rewardData)
        else
            local listRewards = List()
            listRewards:Add(rewardData)
            self.dicGuildRoleRewards:Add(guildRoleNumber, listRewards)
        end
    end
    self.listRewardConfig:Add(rewardData)
end

--- @return List<ItemIconData>
function RankingRewardByRangeConfig:GetListRewardItemIconByGuildRole(guildRole)
    local guildRoleNumber = tonumber(guildRole)
    local listRewards = self.dicGuildRoleRewards:Get(guildRoleNumber)
    if ( listRewards == nil) then
        XDebug.Log("list nil " .. guildRoleNumber)

    end
   -- XDebug.Log("LIST COUNT " .. listRewards:Count() .. " ROLE  " .. guildRole)

    local listIconData = List()
    for i = 1, listRewards:Count() do
        listIconData:Add(listRewards:Get(i):GetIconData())
    end
    return listIconData
end

--- @return List<ItemIconData>
function RankingRewardByRangeConfig:GetListRewardItemIcon()
    local listIconData = List()
    for i = 1, self.listRewardConfig:Count() do
        listIconData:Add(self.listRewardConfig:Get(i):GetIconData())
    end
    return listIconData
end

function RankingRewardByRangeConfig:IsFitRank(rankValue)
    return self.minRank <= rankValue and (rankValue <= self.maxRank or self.maxRank == -1)
end