--- @class EventValentineOpenCardItem
EventValentineOpenCardItem = Class(EventValentineOpenCardItem)

--- @param data string
function EventValentineOpenCardItem:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)
    --- @type number
    self.stock = tonumber(data.stock)
    --- @type number
    self.rate = tonumber(data.rate)
    --- @type RewardInBound
    self.reward = RewardInBound.CreateByParams(data)
end

--- @class EventValentineOpenCardWish
EventValentineOpenCardWish = Class(EventValentineOpenCardWish)

--- @param data string
function EventValentineOpenCardWish:Ctor(data)
    --- @type number
    self.id = tonumber(data.id)
    --- @type number
    self.rate = tonumber(data.rate)
    --- @type RewardInBound
    self.reward = RewardInBound.CreateByParams(data)
    --- @type number
    self.round = math.floor(self.id / 1000)
end

--- @class EventValentineOpenCardConfig
EventValentineOpenCardConfig = Class(EventValentineOpenCardConfig)

--- @param path string
function EventValentineOpenCardConfig:Ctor(path)
    self.path = path

    --- @type number
    self.coinPrice = nil
    --- @type List
    self.gemPrice = nil

    --- @type List
    self.listCardItem = nil
    --- @type List
    self.listCardWish = nil
    --- @type List
    self.listRound = nil

    --- @type List
    self.listCardRewardId = nil

    self:GetCardPriceConfig()
    self:GetCardRewardConfig()
    self:GetCardWishConfig()
end

function EventValentineOpenCardConfig:GetCardPriceConfig()
    local path = string.format("%s/card/valentine_card_config.csv", self.path)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    self.coinPrice = tonumber(parsedData[1].coin_value)
    self.gemPrice = tonumber(parsedData[1].gem_value)
end

function EventValentineOpenCardConfig:GetCardRewardConfig()
    local path = string.format("%s/card/card_reward_rate.csv", self.path)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    self.listCardItem = List()
    self.listCardRewardId = List()
    for i = 1, #parsedData do
        local item = EventValentineOpenCardItem(parsedData[i])
        self.listCardItem:Add(item)
        for j = 1, item.stock do
            self.listCardRewardId:Add(item)
        end
    end
end

function EventValentineOpenCardConfig:GetCardWishConfig()
    local path = string.format("%s/card/card_wish_list.csv", self.path)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    self.listCardWish = List()
    self.listRound = List()
    for i = 1, #parsedData do
        ---@type EventValentineOpenCardWish
        local card = EventValentineOpenCardWish(parsedData[i])
        if self.listRound:IsContainValue(card.round) == false then
            self.listRound:Add(card.round)
        end
        self.listCardWish:Add(card)
    end
end

---@return List
function EventValentineOpenCardConfig:GetListCardWishByRound(round)
    local list = List()
    ---@param v EventValentineOpenCardWish
    for i, v in ipairs(self.listCardWish:GetItems()) do
        if v.round == round then
            list:Add(v)
        end
    end
    return list
end

---@return EventValentineOpenCardWish
function EventValentineOpenCardConfig:GetListCardWishById(id)
    ---@param v EventValentineOpenCardWish
    for i, v in ipairs(self.listCardWish:GetItems()) do
        if v.id == id then
            return v
        end
    end
    return nil
end

---@return EventValentineOpenCardItem
function EventValentineOpenCardConfig:GetListCardRewardById(id)
    ---@param v EventValentineOpenCardItem
    for i, v in ipairs(self.listCardItem:GetItems()) do
        if v.id == id then
            return v
        end
    end
    return nil
end