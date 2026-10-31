--- @class FeatureConfigInBound
FeatureConfigInBound = Class(FeatureConfigInBound)

FeatureConfigInBound.VISUAL_UPDATED = false

function FeatureConfigInBound:Ctor()
    --- @type Dictionary
    self.featureConfigDict = Dictionary()
    --- @type number
    self.nextTimeNeedRequest = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function FeatureConfigInBound:ReadBuffer(buffer)
    self.listFeatureConfig = NetworkUtils.GetListDataInBound(buffer, FeatureItemInBound.CreateByBuffer)
    self:CheckNextRequestTime()
end

function FeatureConfigInBound:CheckNextRequestTime()
    self.featureConfigDict = Dictionary()

    for i = 1, self.listFeatureConfig:Count() do
        --- @type FeatureItemInBound
        local featureItemInBound = self.listFeatureConfig:Get(i)
        local featureType = featureItemInBound.featureType
        self.featureConfigDict:Add(featureType, featureItemInBound)
    end
end

--- @return FeatureItemInBound
--- @param featureType FeatureType
function FeatureConfigInBound:GetFeatureConfigInBound(featureType)
    --- @type FeatureItemInBound
    local featureItemInBound = self.featureConfigDict:Get(featureType)
    if featureItemInBound == nil then
        featureItemInBound = FeatureItemInBound()
        featureItemInBound.featureType = featureType
        featureItemInBound.featureState = FeatureState.LOCK
        self.featureConfigDict:Add(featureType, featureItemInBound)
    end
    return featureItemInBound
end

function FeatureConfigInBound.Validate(callback, forceUpdate)
    if forceUpdate == true then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.FEATURE_CONFIG }, function()
            FeatureConfigInBound.VISUAL_UPDATED = false
            RxMgr.featureConfigUpdated:Next()
            if callback then
                callback()
            end
        end)
    else
        if callback then
            callback()
        end
    end
end

--- @class FeatureItemInBound
FeatureItemInBound = Class(FeatureItemInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function FeatureItemInBound:ReadBuffer(buffer)
    --- @type FeatureType
    self.featureType = buffer:GetByte()
    --- @type FeatureState
    self.featureState = buffer:GetByte()
    self.unlockTime = buffer:GetLong()
    self.unlockVersion = buffer:GetString()

    self:InitArrayVersion()

    if FeatureItemInBound.IsConfigByGO(self.featureType) == false then
        self.featureState = FeatureState.UNLOCK
    end
end

function FeatureItemInBound:InitArrayVersion()
    self.arrClientVersion = PRODUCT_VERSION:Split('.')
    for i = 1, #self.arrClientVersion do
        self.arrClientVersion[i] = tonumber(self.arrClientVersion[i])
    end

    self.arrConfigVersion = self.unlockVersion:Split('.')
    for i = 1, #self.arrConfigVersion do
        self.arrConfigVersion[i] = tonumber(self.arrConfigVersion[i])
    end
end

function FeatureItemInBound:IsAvailableToShowButton()
    return self.featureState == FeatureState.UNLOCK
            or self.featureState == FeatureState.COMING_SOON
            or self.featureState == FeatureState.MAINTAIN
end
function FeatureItemInBound.GetHelpFeatureLocalize(featureType)
    if (featureType == FeatureType.DEFENSE) then
        return "defense_mode_info"
    elseif (featureType == FeatureType.ARENA_TEAM) then
        return "arena_team_info"
    elseif (featureType == FeatureType.DOMAINS) then
        return "domains_info"
    else
        return nil
    end

end

function FeatureItemInBound.GetTimeOpenIn(featureType)
    --- @type FeatureLockData
    local featureLockData = ResourceMgr.GetMajorFeatureLock():GetFeatureLockConfig(featureType)

    if featureLockData ~= nil then
        --- @type ServerListInBound
        local serverListInBound = zg.playerData:GetServerListInBound()
        local featureUnlockInBound = serverListInBound:GetServerData(PlayerSettingData.serverId)
        local openTime = featureUnlockInBound.openTime

        --return (openTime + featureLockData.serverOpenDay * TimeUtils.SecondADay) - zg.timeMgr:GetServerTime() - TimeUtils.TimeZone * 60 * 60
        return (openTime + featureLockData.serverOpenDay * TimeUtils.SecondADay) - zg.timeMgr:GetServerTime()
    end
    return 0
end

function FeatureItemInBound:IsAvailableToGoFeature(isShowNotify)
    local showShortNotification = function(featureType, result, content, timeOpenIn)
        if result == false and isShowNotify ~= false then
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            local helpInfo = FeatureItemInBound.GetHelpFeatureLocalize(featureType)
            if (helpInfo ~= nil and timeOpenIn ~= nil) then
                PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, { ["textHelp"] = LanguageUtils.LocalizeHelpInfo(helpInfo), ["featureType"] = featureType, ["timeOpen"] = timeOpenIn })
            else
                SmartPoolUtils.ShowShortNotification(content)
            end
        end
    end
    local timeOpenIn = FeatureItemInBound.GetTimeOpenIn(self.featureType)
    if timeOpenIn > 0 then
        showShortNotification(self.featureType, false, string.format(LanguageUtils.LocalizeCommon("feature_available_in_s"),
                TimeUtils.GetDeltaTime(timeOpenIn)), timeOpenIn)
        return false
    end
    if self.featureState == FeatureState.COMING_SOON then
        showShortNotification(self.featureType, false, LanguageUtils.LocalizeCommon("coming_soon"))
        return false
    elseif self.featureState == FeatureState.MAINTAIN then
        showShortNotification(self.featureType, false, LanguageUtils.LocalizeCommon("feature_maintain"))
        return false
    elseif self.featureState == FeatureState.LOCK then
        showShortNotification(self.featureType, false, LanguageUtils.LocalizeCommon("lock"))
        return false
    elseif self.featureState == FeatureState.UNLOCK then
        local svTime = zg.timeMgr:GetServerTime()
        local isValidTime = svTime >= self.unlockTime
        local isValidVersion = ClientConfigUtils.CompareVersion(self.arrClientVersion, self.arrConfigVersion) >= 0

        local openInTime = self.unlockTime - svTime

        if not isValidTime and isValidVersion then
            showShortNotification(self.featureType, false, string.format(LanguageUtils.LocalizeCommon("feature_available_in_s"),
                    TimeUtils.GetDeltaTime(openInTime)))
            return false
        elseif isValidTime and not isValidVersion then
            showShortNotification(self.featureType, false, string.format(LanguageUtils.LocalizeCommon("feature_open_at_version_s"), self.unlockVersion))
            return false
        elseif not isValidTime and not isValidVersion then
            showShortNotification(self.featureType, false, string.format(LanguageUtils.LocalizeCommon("feature_open_at_version_s_time_s"),
                    self.unlockVersion, TimeUtils.GetDeltaTime(openInTime)))
            return false
        else
            return true
        end
    end

    return true
end

function FeatureItemInBound.IsConfigByGO(featureType)
    return featureType >= FeatureType.DEFENSE
            and featureType < FeatureType.MAIL
end

--- @return FeatureItemInBound
--- @param buffer UnifiedNetwork_ByteBuf
function FeatureItemInBound.CreateByBuffer(buffer)
    local data = FeatureItemInBound()
    data:ReadBuffer(buffer)
    return data
end