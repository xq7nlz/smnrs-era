--- @class ServerListInBound
ServerListInBound = Class(ServerListInBound)

function ServerListInBound:Ctor()
    --- @type Dictionary  --<key: serverId, value: clusterId>
    self.serverDict = nil
    --- @type Dictionary  --<key: clusterId, value: listServer>
    self.clusterDict = nil
    --- @type number
    self.clusterRegister = nil

    self.newCluster = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function ServerListInBound:ReadBuffer(buffer)
    ---@type number
    local sizeOfList = buffer:GetShort()
    self.listServer = NetworkUtils.GetListDataInBound(buffer, FeatureUnlockInBound.CreateByBuffer, sizeOfList)
    self.serverDict = Dictionary()
    for i = 1, self.listServer:Count() do
        --- @type FeatureUnlockInBound
        local featureUnlockInBound = self.listServer:Get(i)
        local serverID = featureUnlockInBound.server

        -- XDebug.Log("ADD " .. serverID)
        self.serverDict:Add(tonumber(serverID), featureUnlockInBound)
        local clusterID = tonumber(featureUnlockInBound.cluster)
        if self.newCluster == nil or self.newCluster < clusterID then
            self.newCluster = clusterID
        end
        local listServerID
        if (self.clusterDict == nil) then
            self.clusterDict = Dictionary()
        end
        if (self.clusterDict:IsContainKey(clusterID)) then
            listServerID = self.clusterDict:Get(clusterID)
        else
            listServerID = List()
            self.clusterDict:Add(clusterID, listServerID)
        end
        listServerID:Add(serverID)
    end
end

function ServerListInBound:IsAvailableToRequest()
    return self.serverDict == nil or self.clusterDict == nil
end

function ServerListInBound:Clear()
    self.serverDict = nil
    self.clusterDict = nil
end

--- @return number
--- @param serverId number
function ServerListInBound:GetCluster(serverId)
    if (self.serverDict == nil) then
        XDebug.Log("ERROR SERVER DICT NIL")
    end
    if (self.serverDict:IsContainKey(serverId)) then
    else
        XDebug.Log("ERROR not contain key" .. serverId)
    end
    --- @type FeatureUnlockInBound
    local featureUnlockInBound = self.serverDict:Get(serverId)
    return featureUnlockInBound.cluster
end

--- @return List
--- @param clusterId number
function ServerListInBound:GetServers(clusterId)
    return self.clusterDict:Get(tonumber(clusterId))
end

function ServerListInBound:GetClusterRegister()
    if self.clusterRegister == nil then
        local server = -1
        for featureUnlockInBound, clusterId in pairs(self.serverDict:GetItems()) do
            if featureUnlockInBound.serverId > server and PlayerSetting.IsCanShowServer(featureUnlockInBound.serverId) then
                server = featureUnlockInBound.serverId
                self.clusterRegister = clusterId
            end
        end
    end
    return self.clusterRegister
end

--- @return void
function ServerListInBound.GetServerRegister()
    return -1
end

--- @return void
function ServerListInBound.Request(callbackSuccess, callbackFailed)
    local callback = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            zg.playerData:GetServerListInBound():ReadBuffer(buffer)
        end

        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end

        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            zg.playerData:GetServerListInBound():Clear()
            if callbackFailed ~= nil then
                callbackFailed()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.SERVER_LIST_GET, nil, callback, false)
end

--- @return void
function ServerListInBound:ToString()
    return LogUtils.ToDetail(self)
end

function ServerListInBound.Validate(callback, forceUpdate)
    local serverListInBound = zg.playerData:GetServerListInBound()
    if forceUpdate == true or serverListInBound == nil or serverListInBound:IsAvailableToRequest() then
        ServerListInBound.Request(callback)
    else
        callback()
    end
end

--- @return FeatureUnlockInBound
function ServerListInBound:GetServerData(serverId)
    return self.serverDict:Get(serverId)
end

--- @class FeatureUnlockInBound
FeatureUnlockInBound = Class(FeatureUnlockInBound)

--- @return void
function FeatureUnlockInBound:Ctor()
    --- @type ResourceType
    self.server = nil
    --- @type number
    self.cluster = nil
    --- @type number
    self.openTime = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function FeatureUnlockInBound:ReadBuffer(buffer)
    self.server = buffer:GetShort()
    --XDebug.Log("ADD SERVER HOANGPL " .. self.server)
    self.cluster = buffer:GetShort()

    --XDebug.Log("ADD cluster HOANGPL " .. self.cluster)
    self.openTime = buffer:GetLong()
end

function FeatureUnlockInBound.CreateByBuffer(buffer)
    local featureUnlockInBound = FeatureUnlockInBound()
    featureUnlockInBound:ReadBuffer(buffer)
    return featureUnlockInBound
end

return ServerListInBound