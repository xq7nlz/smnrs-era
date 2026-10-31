--- @class AvatarEffectConfig
AvatarEffectConfig = Class(AvatarEffectConfig)

local PATH = "csv/client/avatar_fx_config.csv"

function AvatarEffectConfig:Ctor()
    --- @type Dictionary
    self.avatarItemDict = Dictionary()
    self:InitAvatarEffect()
end

--- @return void
function AvatarEffectConfig:InitAvatarEffect()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(PATH)
    for i = 1, #parsedData do
        local data = parsedData[i]
        local id = tonumber(data.avatar_id)
        local effectID = tonumber(data.effect_id)
        self.avatarItemDict:Add(id, effectID)
    end
end

--- @return number
------ @param avatarID number
function AvatarEffectConfig:GetAvatarEffectID(avatarID)
    if (self.avatarItemDict:IsContainKey(avatarID)) then
        return self.avatarItemDict:Get(avatarID)
        else
        return nil
    end
end

return AvatarEffectConfig
