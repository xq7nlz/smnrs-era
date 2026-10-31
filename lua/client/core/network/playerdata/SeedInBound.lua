--- @class SeedInBound
SeedInBound = Class(SeedInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SeedInBound:ReadBuffer(buffer)
    if buffer ~= nil then
        self.seed = buffer:GetInt()
        self.numberRandom = buffer:GetInt()
    end
end

--- @return void
function SeedInBound:Initialize()
    --XDebug.Log(string.format("Initialize: seed: %s, numberRandom: %s", self.seed, self.numberRandom))
    ClientMathUtils.randomHelper:SetSeed(self.seed)
end

--- @param buffer UnifiedNetwork_ByteBuf
function SeedInBound.CreateByBuffer(buffer)
    local inbound = SeedInBound()
    inbound:ReadBuffer(buffer)
    return inbound
end

--- @return void
function SeedInBound:ToString()
    return LogUtils.ToDetail(self)
end