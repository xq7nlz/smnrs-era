--- @class NotificationArena
NotificationArena = Class(NotificationArena)

NotificationArena.KEY_NOTI_RECORD_ID = "arena_record_noti"

---@type {time, listRecord}
NotificationArena.records = nil

--- @return boolean
function NotificationArena.IsNotification()
    local notify = false
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.ARENA, false) then
        local currentArenaTicket = InventoryUtils.GetMoney(MoneyType.ARENA_TICKET)
        local maxArenaTicket = currentArenaTicket >= ResourceMgr.GetArenaConfig().maxTicket
        if maxArenaTicket then
            --- @type EventPopupModel
            local eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA)
            if eventPopupModel:IsOpening() then
                notify = true
            end
        end
    end
    return notify
end

--- @return void
function NotificationArena.LoadFromServer(callbackSuccess, callbackFailed)
    NotificationArena.records = zg.playerData.remoteConfig.recordArena
    if NotificationArena.records == nil then
        NotificationArena.records = {}
    end
    if callbackSuccess ~= nil then
        callbackSuccess()
    end
    --RemoteConfigSetOutBound.GetValueByKey(NotificationArena.KEY_NOTI_RECORD_ID, function (notiRecord)
    --    NotificationArena.records = json.decode(notiRecord)
    --    if callbackSuccess ~= nil then
    --        callbackSuccess()
    --    end
    --end, function ()
    --    NotificationArena.records = {}
    --    if callbackSuccess ~= nil then
    --        callbackSuccess()
    --    end
    --end)
end

--- @return void
function NotificationArena.SetDataNotificationRecord()
    local cacheRecord = NotificationArena.records
    if cacheRecord ~= nil then
        NotificationArena.records = {}
        ---@type ArenaData
        local arenaData = zg.playerData:GetArenaData()
        if arenaData ~= nil and arenaData.arenaRecordDataInBound ~= nil then
            ---@param v BattleRecordShort
            for _, v in pairs(arenaData.arenaRecordDataInBound.listRecord:GetItems()) do
                local key = tostring(v.recordId)
                NotificationArena.records[key] = cacheRecord[key]
            end
        end
    end
end

--- @return void
function NotificationArena.SaveToServer()
    zg.playerData.remoteConfig.recordArena = NotificationArena.records
    zg.playerData:SaveRemoteConfig()
    --local remoteConfigSetOutBound = RemoteConfigSetOutBound()
    --remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(NotificationArena.KEY_NOTI_RECORD_ID,
    --        RemoteConfigValueType.STRING, json.encode(NotificationArena.records)))
    --RemoteConfigSetOutBound.SetValue(remoteConfigSetOutBound)
end

--- @return void
function NotificationArena.CheckNotificationRecord()
    local noti = false
    ---@type ArenaData
    local arenaData = zg.playerData:GetArenaData()
    if arenaData ~= nil and arenaData.arenaRecordDataInBound ~= nil then
        noti = arenaData.arenaRecordDataInBound.needRequest
        if noti == false then
            ---@param v BattleRecordShort
            for _, v in pairs(arenaData.arenaRecordDataInBound.listRecord:GetItems()) do
                if v:IsDefenseFailed() and NotificationArena.CheckNotificationRecordId(v) == true then
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
function NotificationArena.CheckNotificationRecordId(record)
    local noti = record:IsDefenseFailed()
    if noti and NotificationArena.records ~= nil then
        if NotificationArena.records[tostring(record.recordId)] ~= nil then
            noti = false
        end
    end
    return noti
end

--- @return void
---@param record BattleRecordShort
function NotificationArena.RemoveNotificationRecord(record)
    if NotificationArena.records == nil then
        NotificationArena.records = {}
    end
    if NotificationArena.CheckNotificationRecordId(record) == true then
        NotificationArena.records[tostring(record.recordId)] = 1
        NotificationArena.SetDataNotificationRecord()
        NotificationArena.SaveToServer()
    end
end