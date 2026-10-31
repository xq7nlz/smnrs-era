require "lua.client.core.network.remoteConfig.RemoteConfigValueType"
require "lua.client.core.network.remoteConfig.RemoteConfigItemOutBound"

--- @class RemoteConfigSetOutBound : OutBound
RemoteConfigSetOutBound = Class(RemoteConfigSetOutBound, OutBound)

function RemoteConfigSetOutBound:Ctor()
    --- @type List
    self.listItem = List()
end

--- @param remoteConfigItemOutBound RemoteConfigSetOutBound
function RemoteConfigSetOutBound:AddItem(remoteConfigItemOutBound)
    self.listItem:Add(remoteConfigItemOutBound)
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function RemoteConfigSetOutBound:Serialize(buffer)
    buffer:PutShort(self.listItem:Count())
    for i = 1, self.listItem:Count() do
        self.listItem:Get(i):Serialize(buffer)
    end
end

function RemoteConfigSetOutBound.GetValueByKey(key, onSuccess, onFailed)
    local onReceived = function(result)
        local value
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            --- @type RemoteConfigValueType
            local remoteConfigValueType = buffer:GetByte()
            if remoteConfigValueType == RemoteConfigValueType.BOOLEAN then
                value = buffer:GetBool()
            elseif remoteConfigValueType == RemoteConfigValueType.INTEGER then
                value = buffer:GetInt()
            elseif remoteConfigValueType == RemoteConfigValueType.STRING then
                value = buffer:GetString(false)
            elseif remoteConfigValueType == RemoteConfigValueType.LONG then
                value = buffer:GetLong()
            end
        end
        local success = function()
            onSuccess(value)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, success, onFailed)
    end
    NetworkUtils.Request(OpCode.REMOTE_CONFIG_GET,
            UnknownOutBound.CreateInstance(PutMethod.LongString, key), onReceived, false)
end

function RemoteConfigSetOutBound.SetValue(outBound, onSuccessCallback, onFailedCallback)
    local onReceived = function(result)
        NetworkUtils.ExecuteResult(result, nil, onSuccessCallback, onFailedCallback)
    end
    NetworkUtils.Request(OpCode.REMOTE_CONFIG_SET, outBound, onReceived, false)
end

function RemoteConfigSetOutBound.UpdateABTest()
    local campaignABTestID = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.Campaign)
    local campaignRewardABTestID = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.CampaignReward)
    local summonABTestID = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.Summon)
    local watchAdABTestID = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.WatchAd)
    local progressPackABTestID = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.ProgressPack)
    local firstTopUpABTestID = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.FirstTopUp)
    local remoteConfigSetOutBound = RemoteConfigSetOutBound()
    remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(FirebaseRemoteConfigKey.Campaign, RemoteConfigValueType.INTEGER, campaignABTestID))
    remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(FirebaseRemoteConfigKey.CampaignReward, RemoteConfigValueType.INTEGER, campaignRewardABTestID))
    remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(FirebaseRemoteConfigKey.Summon, RemoteConfigValueType.INTEGER, summonABTestID))
    remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(FirebaseRemoteConfigKey.WatchAd, RemoteConfigValueType.INTEGER, watchAdABTestID))
    remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(FirebaseRemoteConfigKey.ProgressPack, RemoteConfigValueType.INTEGER, progressPackABTestID))
    remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(FirebaseRemoteConfigKey.FirstTopUp, RemoteConfigValueType.INTEGER, firstTopUpABTestID))

    local onBufferReading = function(buffer)
        local size = buffer:GetByte()
        for _ = 1, size do
            local key = buffer:GetString()
            local value = tonumber(buffer:GetString())
            zg.playerData:SetABTesting(key, value)
        end
    end

    local onSuccess = function()
        local campaignDataConfig = ResourceMgr.GetCampaignDataConfig()
        campaignDataConfig:InitData(campaignDataConfig:GetCampaignStageConfigID())
        local cashShopDataConfig = ResourceMgr.GetPurchaseConfig():GetCashShop()
        cashShopDataConfig:InitProgressPack(cashShopDataConfig:GetProgressPackConfigID())
    end

    NetworkUtils.RequestAndCallback(OpCode.REMOTE_CONFIG_AB_TEST_DATA_SET,
            remoteConfigSetOutBound, onSuccess, nil, onBufferReading, false)
end