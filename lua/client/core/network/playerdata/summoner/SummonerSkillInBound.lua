--- @class SummonerSkillInBound
SummonerSkillInBound = Class(SummonerSkillInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SummonerSkillInBound:Ctor(buffer)
    ---@type Dictionary  --<skillId, skillTier>
    self.skillTiers = Dictionary()
    if buffer ~= nil then
        ---@type number
        local size = buffer:GetByte()
        for i = 1, size do
            self.skillTiers:Add(buffer:GetByte(), buffer:GetByte())
        end
        --XDebug.Log("SummonerSkillInBound" .. LogUtils.ToDetail(self.skillTiers:GetItems()))
    end
end

--- @return void
function SummonerSkillInBound:ToString()
    return LogUtils.ToDetail(self)
end