require "lua.client.data.Purchase.LevelPass.GrowthPackLineConfig"
local GROWTH_PACK_BASIC = "csv/purchase/growth_pack/line_%d/growth_pack_basic_line.csv"
local GROWTH_PACK_PREMIUM = "csv/purchase/growth_pack/line_%d/growth_pack_premium_line.csv"

--- @class LevelPassConfig
LevelPassConfig = Class(LevelPassConfig)

function LevelPassConfig:Ctor()
    --- @type Dictionary
    self.lineConfig = Dictionary()
end

--- @return GrowthPackLineConfig
--- @param line number
function LevelPassConfig:GetGrowthPackConfigByLine(line)
    if self.lineConfig:IsContainKey(line) == false then
        self:_InitLineConfig(line)
    end
    return self.lineConfig:Get(line)
end

--- @param line number
function LevelPassConfig:_InitLineConfig(line)
    local growthPackLineConfig = GrowthPackLineConfig(line, GROWTH_PACK_BASIC, GROWTH_PACK_PREMIUM, "level")
    self.lineConfig:Add(line, growthPackLineConfig)
end

return LevelPassConfig