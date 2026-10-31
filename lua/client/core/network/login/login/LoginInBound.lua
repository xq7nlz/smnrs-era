--- @class LoginInBound
LoginInBound = Class(LoginInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function LoginInBound:Ctor(buffer)
    ---@type AuthMethod
    self.authMethod = buffer:GetByte()
    ---@type number
    self.serverId = buffer:GetShort()
    ---@type number
    self.playerId = buffer:GetLong()

    self:SaveData()
end

--- @return void
function LoginInBound:SaveData()
    PlayerSettingData.serverId = self.serverId
    PlayerSettingData.playerId = self.playerId
    TrackingUtils.Login(tostring(self.authMethod))

    self:CheckLogViewer()
end

--- @return void
function LoginInBound:ToString()
    return LogUtils.ToDetail(self)
end

function LoginInBound:CheckLogViewer()
    if zgUnity.IsTest == true then
        return
    end
    local url = string.format(NetConfig.REMOTE_URL, NetConfig.loadBalancerIP, NetConfig.loadBalancerPort, "a_log_viewer")
    local onSuccess = function(content)
        if string.len(content) > 0 then
            local playerId = tonumber(content)
            if playerId == self.playerId then
                U_GameUtils.Instantiate("Reporter")
            end
        end
    end
    local onFailed = function()
    end
    NetworkUtils.TryRequestData(3, url, onSuccess, onFailed)
end

