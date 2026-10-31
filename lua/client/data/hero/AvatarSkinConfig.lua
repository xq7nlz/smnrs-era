--- @class AvatarSkinConfig
AvatarSkinConfig = Class(AvatarSkinConfig)

local SKIN_AVATAR_PATH = "csv/avatar/skin_avatar.csv"

function AvatarSkinConfig:Ctor()
    self:_ReadCsv()
end

function AvatarSkinConfig:_ReadCsv()
    --- @type Dictionary
    self.avatarConfigDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(SKIN_AVATAR_PATH)
    for i = 1, #parsedData do
        local skinId = tonumber(parsedData[i].skin_id)
        local avatar = tonumber(parsedData[i].id)
        if skinId ~= nil and avatar ~= nil then
            self.avatarConfigDict:Add(avatar, skinId)

        end
    end
end

--- @return SkinRarity
--- @param avatarId number
function AvatarSkinConfig:GetSkinBuyAvatarID(avatarId)
    if self.avatarConfigDict:IsContainKey(avatarId) then
        return self.avatarConfigDict:Get(avatarId)
    end
    XDebug.Warning("NIL avatar skin" .. avatarId)
    return 1000
end

return AvatarSkinConfig