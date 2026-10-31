--- @class CustomizeProduct : ProductConfig
CustomizeProduct = Class(CustomizeProduct, ProductConfig)

function CustomizeProduct:Ctor()
    ProductConfig.Ctor(self)
    self.opCode = OpCode.CUSTOMIZE_BUNDLE_PURCHASE

    --- @type List<RewardInBound>
    self.listSelectReward = nil
    --- @type List<RewardInBound>
    self.listDefaultReward = List()
    --- @type number
    self.numberSelection = nil
end

--- @return void
function CustomizeProduct:ParseCsv(data)
    if data.id ~= nil then
        ProductConfig.ParseCsv(self, data)
        --- @type number
        self.stock = tonumber(data['stock'])
        --- @type LimitedPackResetType
        self.resetType = tonumber(data['reset_type'])
        self.isHot = MathUtils.ToBoolean(data['is_hot'])
        self.numberSelection = tonumber(data['number_selection'])
    end

    --- @type RewardInBound
    local reward = RewardInBound()
    reward.id = tonumber(data['selection_res_id'])
    reward.data = data['selection_res_data']
    if reward.data == nil then
        reward.data = 0
    else
        reward.data = tonumber(reward.data)
    end
    reward.number = tonumber(data['selection_res_number'])
    reward.type = tonumber(data['selection_res_type'])

    if data['res_id'] ~= nil then
        local reward = RewardInBound()
        reward.id = tonumber(data['res_id'])
        reward.type = tonumber(data['res_type'])
        reward.number = tonumber(data['res_number'])
        reward.data = 0
        self.listDefaultReward:Add(reward)
    end

    --print(string.format("%s %s %s %s", reward.id, reward.data, reward.number, reward.type))
    self.rewardList:Add(reward)
end

function CustomizeProduct:ClaimAndShowRewardList()
    ---@type List <RewardInBound>
    local reward = List()
    if self.listSelectReward ~= nil then
        for i, v in ipairs(self.listSelectReward:GetItems()) do
            reward:Add(v)
        end
    end

    if self.listDefaultReward ~= nil then
        for i, v in ipairs(self.listDefaultReward:GetItems()) do
            reward:Add(v)
        end
    end

    PopupUtils.ClaimAndShowRewardList(reward)
end