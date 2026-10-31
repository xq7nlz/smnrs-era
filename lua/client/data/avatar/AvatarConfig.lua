--- @class AvatarConfig
AvatarConfig = Class(AvatarConfig)

local PATH = "csv/avatar/avatar.csv"
local FRAMEPATH = "csv/avatar/avatar_frame.csv"

function AvatarConfig:Ctor()
    --- @type Dictionary
    self.avatarItemDict = Dictionary()
    --- @type Dictionary
    self.frameItemDict = Dictionary()
    self:InitAvatar()
    self:InitFrame()
end
function AvatarConfig:InitFrame()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(FRAMEPATH)
    for i = 1, #parsedData do
        local data = parsedData[i]
        local id = tonumber(data.id)
        self.frameItemDict:Add(id, FrameItemConfig(id, data))
    end
end

function AvatarConfig:InitAvatar()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(PATH)
    for i = 1, #parsedData do
        local data = parsedData[i]
        local id = tonumber(data.id)
        self.avatarItemDict:Add(id, AvatarItemConfig(id, data))
    end
end

--- @return AvatarItemConfig
function AvatarConfig:GetAvatarItemConfig(id)
    return self.avatarItemDict:Get(id)
end

--- @return FrameItemConfig
function AvatarConfig:GetFrameItemConfig(id)
    return self.frameItemDict:Get(id)
end

--- @class AvatarItemConfig
AvatarItemConfig = Class(AvatarItemConfig)

function AvatarItemConfig:Ctor(id, data)
    self.id = id
    if data then
        self:ParsedData(data)
    end
end

function AvatarItemConfig:ParsedData(data)
    self.heroId = tonumber(data.hero_id)
    self.tier = tonumber(data.tier)
    self.timeDuration = tonumber(data.time_duration)
end

--- @class FrameItemConfig
FrameItemConfig = Class(FrameItemConfig)

function FrameItemConfig:Ctor(id, data)
    self.id = id
    if data then
        self:ParsedData(data)
    end
end

function FrameItemConfig:ParsedData(data)
    self.ID = tonumber(data.id)
    self.vip_level = tonumber(data.vip_level)
    self.timeDuration = tonumber(data.time_duration)
end

return AvatarConfig
