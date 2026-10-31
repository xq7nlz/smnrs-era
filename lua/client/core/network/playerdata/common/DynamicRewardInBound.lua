require "lua.client.core.network.playerData.common.RewardInBound"

--- @class DynamicRewardInBound : RewardInBound
DynamicRewardInBound = Class(DynamicRewardInBound, RewardInBound)

function DynamicRewardInBound:Ctor()
    --- @type string
    self.formula = nil
    RewardInBound.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function DynamicRewardInBound:ReadBuffer(buffer)
    RewardInBound.ReadBuffer(self, buffer)
    self.formula = buffer:GetString(false)
end

--- @return RewardInBound
--- @param json table
function DynamicRewardInBound.CreateByJson(json)
    local ins = DynamicRewardInBound()
    ins.type = tonumber(json['0'])
    ins.id = tonumber(json['1'])
    ins.number = tonumber(json['2'])
    ins.data = json['3']
    ins.data = json['4']
    return ins
end

--- @return number
function DynamicRewardInBound:GetNumber()
    if self.formula ~= nil and string.len(self.formula) > 0 then
        return ClientMathUtils.ConvertingCalculation(self.formula)
    else
        return RewardInBound.GetNumber(self)
    end
end

--- @return DynamicRewardInBound
--- @param buffer UnifiedNetwork_ByteBuf
function DynamicRewardInBound.CreateByBuffer(buffer)
    local data = DynamicRewardInBound()
    data:ReadBuffer(buffer)
    return data
end