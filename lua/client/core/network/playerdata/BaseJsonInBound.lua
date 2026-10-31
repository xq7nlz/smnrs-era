--- @class BaseJsonInBound
BaseJsonInBound = Class(BaseJsonInBound)

--- @return void
function BaseJsonInBound:Ctor()
end

--- @param buffer UnifiedNetwork_ByteBuf
function BaseJsonInBound:ReadBuffer(buffer)
    local gzipData = buffer:GetString(false)
    self.jsonData = ClientConfigUtils.GetGunzipString(gzipData)
    self:InitDatabase()
end

--- @return void
function BaseJsonInBound:InitDatabase()
    assert(false, "Need override here")
end

--- @return string
function BaseJsonInBound:ToString()
    return self.jsonData
end