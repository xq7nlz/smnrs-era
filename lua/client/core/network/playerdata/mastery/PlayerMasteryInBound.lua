--- @class PlayerMasteryInBound
PlayerMasteryInBound = Class(PlayerMasteryInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerMasteryInBound:ReadBuffer(buffer)
    ---@type Dictionary  --<classType, List<mastery>>
    self.classDict = NetworkUtils.GetDictMastery(buffer)
end

--- @return Dictionary
function PlayerMasteryInBound:Clone()
    local dict = Dictionary()
    for key, data in pairs(self.classDict:GetItems()) do
        local list = List()
        for i, v in ipairs(data:GetItems()) do
            list:Add(v)
        end
        dict:Add(key, list)
    end
    return dict
end
