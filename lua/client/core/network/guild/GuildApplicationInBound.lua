require "lua.client.core.network.guild.GuildApplicationItemInBound"

--- @class GuildApplicationInBound
GuildApplicationInBound = Class(GuildApplicationInBound)
GuildApplicationInBound.KEY_LAST_CREATED = "guild_last_created_application"

function GuildApplicationInBound:Ctor()
    --- @type number
    self.lastSavedCreatedApplication = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildApplicationInBound:ReadBuffer(buffer)
    --- @type number
    local size = buffer:GetByte()
    --- @type List -- GuildApplicationItemInBound
    self.listApplicationItem = List()
    for _ = 1, size do
        self.listApplicationItem:Add(GuildApplicationItemInBound(buffer))
    end
    self:SortList()
    --- @type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function GuildApplicationInBound:IsAvailableToRequest()
    return self.lastTimeRequest == nil or (zg.timeMgr:GetServerTime() - self.lastTimeRequest) > 10
end

--- @param onNotified function
function GuildApplicationInBound:CheckNotify(onNotified)
    local invoke = function(param)
        if onNotified ~= nil then
            onNotified(param)
        end
    end
    local onLoadedLastSavedTime = function()
        --- @type GuildApplicationItemInBound
        local lastApplication = self.listApplicationItem:Get(self.listApplicationItem:Count())
        if lastApplication ~= nil and self.lastSavedCreatedApplication < lastApplication.createdTime then
            invoke(true)
        else
            invoke(false)
        end
    end
    if self.lastSavedCreatedApplication ~= nil then
        onLoadedLastSavedTime()
        return
    end
    --- @param logicCode LogicCode
    local onFailed = function(logicCode)
        if logicCode == LogicCode.REMOTE_CONFIG_KEY_NOT_FOUND then
            self.lastSavedCreatedApplication = -1
        end
        onLoadedLastSavedTime()
    end
    GuildApplicationInBound.GetLastCreatedGuildApplication(onLoadedLastSavedTime, onFailed)
end

function GuildApplicationInBound:SortList()
    if self.listApplicationItem:Count() > 0 then
        self.listApplicationItem:SortWithMethod(GuildApplicationInBound.SortByCreatedTime)
    end
end

--- @return number
---@param x GuildApplicationItemInBound
---@param y GuildApplicationItemInBound
function GuildApplicationInBound.SortByCreatedTime(x, y)
    if y.createdTime > x.createdTime then
        return 1
    else
        return -1
    end
end

--- @return number
--- @param onSuccess function
--- @param onFailed function
function GuildApplicationInBound.GetLastCreatedGuildApplication(onSuccess, onFailed)
    --- @param value number
    local callback = function(value)
        --- @type GuildApplicationInBound
        local guildApplicationInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_APPLICATION)
        guildApplicationInBound.lastSavedCreatedApplication = value
        onSuccess(value)
    end
    local lastSavedCreatedApplication = zg.playerData.remoteConfig.lastSavedCreatedApplication
    if lastSavedCreatedApplication == nil then
        lastSavedCreatedApplication = -1
    end
    callback(lastSavedCreatedApplication)
    ----- @param logicCode LogicCode
    --local onFailedNilKey = function(logicCode)
    --    if logicCode == LogicCode.REMOTE_CONFIG_KEY_NOT_FOUND then
    --        callback(-1)
    --    end
    --end
    --RemoteConfigSetOutBound.GetValueByKey(GuildApplicationInBound.KEY_LAST_CREATED, callback, onFailedNilKey)
end

--- @param createdTime number
--- @param onSuccess function
--- @param onFailed function
function GuildApplicationInBound.SetLastCreatedGuildApplication(createdTime, onSuccess, onFailed)
    zg.playerData.remoteConfig.lastSavedCreatedApplication = createdTime
    zg.playerData:SaveRemoteConfig()
    if onSuccess ~= nil then
        onSuccess()
    end
    --local remoteConfigSetOutBound = RemoteConfigSetOutBound()
    --remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(GuildApplicationInBound.KEY_LAST_CREATED, RemoteConfigValueType.LONG, createdTime))
    --RemoteConfigSetOutBound.SetValue(remoteConfigSetOutBound, onSuccess, onFailed)
end

--- @param dataIndex number
function GuildApplicationInBound:GetApplicationItemByIndex(dataIndex)
    return self.listApplicationItem:Get(dataIndex)
end

--- @param itemInBound GuildApplicationItemInBound
function GuildApplicationInBound:RemoveItemInBound(itemInBound)
    if self.listApplicationItem:IsContainValue(itemInBound) then
        self.listApplicationItem:RemoveByReference(itemInBound)
    end
end

function GuildApplicationInBound.Validate(callback)
    --- @type GuildApplicationInBound
    local guildApplicationInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_APPLICATION)
    if guildApplicationInBound == nil or guildApplicationInBound:IsAvailableToRequest() == true then
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_APPLICATION }, callback, onFailed)
    else
        callback()
    end
end