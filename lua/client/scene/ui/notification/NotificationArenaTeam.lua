--- @class NotificationArenaTeam
NotificationArenaTeam = Class(NotificationArenaTeam)

NotificationArenaTeam.KEY_NOTI_RECORD_ID = "arena_record_noti"

---@type {time, listRecord}
NotificationArenaTeam.records = nil

--- @return boolean
function NotificationArenaTeam.IsNotification()
    local notify = false
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    --- @type FeatureItemInBound
    local featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.ARENA_TEAM)
    if featureItemInBound.featureState == FeatureState.UNLOCK then
        if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.ARENA_TEAM, false) then
            local currentArenaTicket = InventoryUtils.GetMoney(MoneyType.ARENA_TEAM_TICKET)
            local maxArenaTicket = currentArenaTicket >= ResourceMgr.GetArenaTeamConfig().maxTicket
            if maxArenaTicket then
                --- @type EventPopupModel
                local eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA_TEAM)
                if eventPopupModel:IsOpening() then
                    notify = true
                end
            end
        end
    else

    end
    return notify
end

--- @return void
function NotificationArenaTeam.LoadFromServer(callbackSuccess, callbackFailed)
    NotificationArenaTeam.records = zg.playerData.remoteConfig.recordArenaTeam
    if NotificationArenaTeam.records == nil then
        NotificationArenaTeam.records = {}
    end
    if callbackSuccess ~= nil then
        callbackSuccess()
    end
    --RemoteConfigSetOutBound.GetValueByKey(NotificationArenaTeam.KEY_NOTI_RECORD_ID, function (notiRecord)
    --    NotificationArenaTeam.records = json.decode(notiRecord)
    --    if callbackSuccess ~= nil then
    --        callbackSuccess()
    --    end
    --end, function ()
    --    NotificationArenaTeam.records = {}
    --    if callbackSuccess ~= nil then
    --        callbackSuccess()
    --    end
    --end)
end

--- @return void
function NotificationArenaTeam.SetDataNotificationRecord()
    local cacheRecord = NotificationArenaTeam.records
    if cacheRecord ~= nil then
        NotificationArenaTeam.records = {}
        ---@type ArenaData
        local arenaData = zg.playerData:GetArenaData()
        if arenaData ~= nil and arenaData.arenaTeamRecordDataInBound ~= nil then
            ---@param v BattleRecordShort
            for _, v in pairs(arenaData.arenaTeamRecordDataInBound.listRecord:GetItems()) do
                local key = tostring(v.recordId)
                NotificationArenaTeam.records[key] = cacheRecord[key]
            end
        end
    end
end

--- @return void
function NotificationArenaTeam.SaveToServer()
    zg.playerData.remoteConfig.recordArenaTeam = NotificationArenaTeam.records
    zg.playerData:SaveRemoteConfig()
    --local remoteConfigSetOutBound = RemoteConfigSetOutBound()
    --remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(NotificationArenaTeam.KEY_NOTI_RECORD_ID,
    --        RemoteConfigValueType.STRING, json.encode(NotificationArenaTeam.records)))
    --RemoteConfigSetOutBound.SetValue(remoteConfigSetOutBound)
end

--- @return void
function NotificationArenaTeam.CheckNotificationRecord()
    local noti = false
    ---@type ArenaData
    local arenaData = zg.playerData:GetArenaData()
    if arenaData ~= nil and arenaData.arenaRecordDataInBound ~= nil then
        noti = arenaData.arenaRecordDataInBound.needRequest
        if noti == false then
            ---@param v BattleRecordShort
            for _, v in pairs(arenaData.arenaRecordDataInBound.listRecord:GetItems()) do
                if v:IsDefenseFailed() and NotificationArenaTeam.CheckNotificationRecordId(v) == true then
                    noti = true
                    break
                end
            end
        end
    end
    return noti
end

--- @return void
---@param record BattleRecordShort
function NotificationArenaTeam.CheckNotificationRecordId(record)
    local noti = record:IsDefenseFailed()
    if noti and NotificationArenaTeam.records ~= nil then
        if NotificationArenaTeam.records[tostring(record.recordId)] ~= nil then
            noti = false
        end
    end
    return noti
end

--- @return void
---@param record BattleRecordShort
function NotificationArenaTeam.RemoveNotificationRecord(record)
    if NotificationArenaTeam.records == nil then
        NotificationArenaTeam.records = {}
    end
    if NotificationArenaTeam.CheckNotificationRecordId(record) == true then
        NotificationArenaTeam.records[tostring(record.recordId)] = 1
        NotificationArenaTeam.SetDataNotificationRecord()
        NotificationArenaTeam.SaveToServer()
    end
end