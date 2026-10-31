--- @class EventNewHeroSpinReward
EventNewHeroSpinReward = Class(EventNewHeroSpinReward)

function EventNewHeroSpinReward:Ctor(data)
    --- @type number
    self.id = tonumber(data.slot_id)
    --- @type RewardInBound
    self.reward = RewardInBound.CreateByParams(data)
    --- @type number
    self.rate = tonumber(data.rate)
end

function EventNewHeroSpinReward:GetLayer()
    return math.floor(self.id / 100)
end

function EventNewHeroSpinReward.GetLayerBySlot(slot)
    return math.floor(slot / 100)
end

function EventNewHeroSpinReward:GetIndex()
    return math.floor(self.id % 100)
end

--- @return number
---@param x EventNewHeroSpinReward
---@param y EventNewHeroSpinReward
function EventNewHeroSpinReward.SortId(x, y)
    if y.id > x.id then
        return -1
    else
        return 1
    end
end