--- @class CommunityEventData
CommunityEventData = Class(CommunityEventData)
function CommunityEventData:Ctor()
    --- @type CommunityEventConfig
    self.configs = nil

    self:GetDefaultRemoteConfig()

    if self.configs == nil then
        self.configs = self:GetNilDefaultConfigCsv()
    end
end

function CommunityEventData:GetDefaultConfigCsv()
    ---@type List
    local table = {}
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile("csv/client/community_event/community_event_config.csv")
    for i = 1, #parsedData do
        local data = {}
        data.id = tonumber(parsedData[i].id)
        data.eventName = tonumber(parsedData[i].event_name)
        data.eventUrl = tonumber(parsedData[i].event_url)
        data.eventImageId = tonumber(parsedData[i].event_image_id)
        table[i] = data
    end
    return table
end

function CommunityEventData:GetNilDefaultConfigCsv()
    ---@type List
    local table = {}
    --- @type CommunityEventConfig
    local data = {}
    data.id = 0
    data.eventName = "nil"
    data.eventUrl = "nil"
    data.eventImageId = 0
    table[1] = data
    return table
end

function CommunityEventData:GetDefaultRemoteConfig()
    local url = string.format(NetConfig.REMOTE_URL, NetConfig.loadBalancerIP, NetConfig.loadBalancerPort, "a_community_event_config")
    local onSuccess = function(content)
        self.configs = json.decode(content);
    end
    local onFailed = function()
    end
    NetworkUtils.TryRequestData(3, url, onSuccess, onFailed)
end

function CommunityEventData:HasEventTabNotSeen()
    for i, v in pairs(self.configs) do
        if self:CheckTabNotSeen(v) then
            return true
        end
    end
    return false
end

--- @param communityEventData CommunityEventData
function CommunityEventData:CheckTabNotSeen(communityEventData)
    if self.configs[1].id == 0 then
        return false
    elseif zg.playerData.remoteConfig.listSeenCommunityEvent == nil then
        return true
    end
    local checkUrl = zg.playerData.remoteConfig.listSeenCommunityEvent[communityEventData.id]
    if checkUrl == nil or checkUrl == false then
        return true
    end
    return false
end

--- @param communityEventData CommunityEventData
function CommunityEventData:SaveTabSeenRemoteConfig(communityEventData)
    if zg.playerData.remoteConfig.listSeenCommunityEvent == nil then
        zg.playerData.remoteConfig.listSeenCommunityEvent = {}
    end
    zg.playerData.remoteConfig.listSeenCommunityEvent[communityEventData.id] = true
    zg.playerData:SaveRemoteConfig()
end

--- @class CommunityEventConfig
CommunityEventConfig = Class(CommunityEventConfig)
function CommunityEventConfig:Ctor()
    --- @type number
    self.id = nil
    --- @type string
    self.event_name = nil
    --- @type string
    self.img_localize = nil
    --- @type string
    self.event_url = nil
    --- @type number
    self.event_image_id = nil
    --- @type CommunityEventButtonPosition
    self.button_position = nil
    --- @type {}
    self.button_facebook = nil
    --- @type {}
    self.button_discord = nil
    --- @type {}
    self.button_other = nil
end