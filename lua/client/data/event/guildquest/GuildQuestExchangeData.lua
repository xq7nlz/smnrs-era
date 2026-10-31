--- @class GuildQuestExchangeData
GuildQuestExchangeData = Class(GuildQuestExchangeData)

--- @return void
function GuildQuestExchangeData:Ctor()
    self.id = nil
    ---@type List --<ItemIconData>
    self.listMoney = List()
    ---@type List --<RewardInBound>
    self.listReward = List()

    ---@type number
    self.numberApple = 0
    ---@type number
    self.numberPear = 0
end

--- @return void
function GuildQuestExchangeData:ParsedData(data)
    self.id = tonumber(data.id)
    self:AddData(data)
end

--- @return void
function GuildQuestExchangeData:AddData(data)
    if data.money_type ~= nil then
        local itemData = ItemIconData.CreateInstance(ResourceType.Money, tonumber(data.money_type), tonumber(data.money_value))
        self.listMoney:Add(itemData)
        if itemData.itemId == MoneyType.EVENT_GUILD_QUEST_APPLE then
            self.numberApple = itemData.quantity
        elseif itemData.itemId == MoneyType.EVENT_GUILD_QUEST_PEAR then
            self.numberPear = itemData.quantity
        end
    end
    if data.res_type ~= nil then
        self.listReward:Add(RewardInBound.CreateByParams(data))
    end
end