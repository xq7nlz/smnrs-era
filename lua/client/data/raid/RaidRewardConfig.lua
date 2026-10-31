--- @class RaidRewardConfig
RaidRewardConfig = Class(RaidRewardConfig)

--- @return void
function RaidRewardConfig:Ctor()
    ---@type number
    self.stage = nil
    ----@type number
    self.levelRequired = nil
    ----@type List
    self.listRewardItem = List()
end

--- @return void
function RaidRewardConfig:ParseCsv(dataContent)
    self.stage = tonumber(dataContent["stage"])
    self.levelRequired = tonumber(dataContent["level_required"])
    self:AddReward(dataContent)
end

--- @return void
function RaidRewardConfig:AddReward(dataContent)
    self.listRewardItem:Add(ItemIconData.CreateInstance(tonumber(dataContent["res_type"]), tonumber(dataContent["res_id"]), tonumber(dataContent["res_number"])))
end