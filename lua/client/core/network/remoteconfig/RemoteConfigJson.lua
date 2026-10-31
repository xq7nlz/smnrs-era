require "lua.client.core.network.remoteConfig.RemoteConfigSetOutbound"
require "lua.client.core.network.remoteConfig.RemoteConfigValueType"

--- @class RemoteConfigJson
RemoteConfigJson = Class(RemoteConfigJson)

function RemoteConfigJson:Ctor(key, data)
    self._key = key
    self.data = data
end

function RemoteConfigJson:_CallSuccess(callbackSuccess)
    if callbackSuccess ~= nil then
        callbackSuccess(self.data)
    end
end


function RemoteConfigJson:GetConfigFromServer(callbackSuccess)
    RemoteConfigSetOutBound.GetValueByKey(self._key, function (data)
        self.data = json.decode(data)
        self:_CallSuccess(callbackSuccess)
    end, function ()
        self.data = {}
        self:_CallSuccess(callbackSuccess)
    end)
end

function RemoteConfigJson:GetConfigFromServerOrCache(callbackSuccess)
    if self.data ~= nil then
        self:_CallSuccess(callbackSuccess)
    else
        self:GetConfigFromServer(callbackSuccess)
    end
end

function RemoteConfigJson:SaveConfig()
    if self.data ~= nil then
        local remoteConfigSetOutBound = RemoteConfigSetOutBound()
        remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(self._key,
                RemoteConfigValueType.STRING, json.encode(self.data)))
        RemoteConfigSetOutBound.SetValue(remoteConfigSetOutBound)
    end
end