--- @class DayRewardStateInBound
DayRewardStateInBound = Class(DayRewardStateInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function DayRewardStateInBound.CreateDictionaryFromBuffer(buffer, size)
    local dict = Dictionary()
    for _ = 1, size do
        local dayId = buffer:GetInt()
        local rewardState = buffer:GetInt()
        dict:Add(dayId, rewardState)
    end
    return dict
end