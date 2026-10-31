require "lua.client.scene.ui.home.uiGuildArea.GuildAreaWorldModel"
require "lua.client.core.network.guild.guildWar.GuildWarPreviousSeasonResultInBound"
require "lua.client.core.network.guild.guildWar.GuildWarPreviousBattleResultInBound"

--- @type UnityEngine_Vector3
local u_Vector3 = U_Vector3

--- @class GuildAreaWorld : BgWorldView
GuildAreaWorld = Class(GuildAreaWorld, BgWorldView)

--- @param transform UnityEngine_Transform
--- @param view UIGuildAreaView
function GuildAreaWorld:Ctor(transform, view)
    BgWorldView.Ctor(self, transform)
    --- @type UIGuildAreaView
    self.view = view
    --- @type UIGuildAreaModel
    self.model = view.model

    --- @type Dictionary
    self.buildingDict = Dictionary()

    --- @type Coroutine
    self._camCoroutine = nil

    --- @type GuildBasicInfoInBound
    self.guildBasicInfo = nil
    --- @type GuildWarTimeInBound
    self.guildWarTimeInBound = nil
    --- @type GuildWarInBound
    self.guildWarInBound = nil
    --- @type GuildWarConfig
    self.guildWarConfig = nil

    --- @type GuildWarPhase
    self.currentPhase = nil

    self:_Init()
end

function GuildAreaWorld:InitConfig(transform)
    --- @type GuildAreaWorldConfig
    self.config = UIBaseConfig(transform)
end

function GuildAreaWorld:_Init()
    self:_InitViewPortEvent()
    self:_InitBuilding()
    self:_InitView()

    self.guildWarConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig()
end

function GuildAreaWorld:_InitBuilding()
    --- @param guildAreaWorldBuilding GuildAreaWorldBuilding
    --- @param transform UnityEngine_Transform
    --- @param classBuilding MainAreaBuilding
    --- @param onClick function
    local addMainAreaBuilding = function(guildAreaWorldBuilding, transform, classBuilding, onClick)
        local areaBuilding = classBuilding(transform)
        local entryPointerDown = U_EventSystems.EventTrigger.Entry()
        entryPointerDown.eventID = U_EventSystems.EventTriggerType.PointerDown
        entryPointerDown.callback:AddListener(function(data)
            areaBuilding:OnPointerDown()
        end)
        local entryPointerUp = U_EventSystems.EventTrigger.Entry()
        entryPointerUp.eventID = U_EventSystems.EventTriggerType.PointerUp
        entryPointerUp.callback:AddListener(function(data)
            areaBuilding:OnPointerUp()
        end)
        --- @type UnityEngine_EventSystems_EventTrigger_Entry
        local entryBeginDrag = U_EventSystems.EventTrigger.Entry()
        entryBeginDrag.eventID = U_EventSystems.EventTriggerType.BeginDrag
        entryBeginDrag.callback:AddListener(function(data)
            areaBuilding:OnBeginDrag()
        end)
        --- @type UnityEngine_EventSystems_EventTrigger_Entry
        local entryDrag = U_EventSystems.EventTrigger.Entry()
        entryDrag.eventID = U_EventSystems.EventTriggerType.Drag
        entryDrag.callback:AddListener(
                function(data)
                    self:_OnPointerDrag(data)
                end)
        areaBuilding.config.eventTrigger.triggers:Add(entryPointerDown)
        areaBuilding.config.eventTrigger.triggers:Add(entryPointerUp)
        areaBuilding.config.eventTrigger.triggers:Add(entryBeginDrag)
        areaBuilding.config.eventTrigger.triggers:Add(entryDrag)

        areaBuilding:AddListener(function()
            onClick()
        end)
        self.buildingDict:Add(guildAreaWorldBuilding, areaBuilding)
        return areaBuilding
    end
    addMainAreaBuilding(GuildAreaWorldBuilding.GuildHall, self.config.guildHall, SpriteAreaBuilding, function()
        self.view:OnClickGuildHall()
    end)
    addMainAreaBuilding(GuildAreaWorldBuilding.GuildBoss, self.config.guildDailyBoss, SpriteAreaBuilding, function()
        self.view:OnClickGuildDailyBoss()
    end)
    addMainAreaBuilding(GuildAreaWorldBuilding.GuildDungeon, self.config.guildDungeon, SpriteAreaBuilding, function()
        self.view:OnClickGuildDungeon()
    end)
    addMainAreaBuilding(GuildAreaWorldBuilding.GuildShop, self.config.guildShop, SpineAreaBuilding, function()
        self.view:OnClickGuildShop()
    end)
    addMainAreaBuilding(GuildAreaWorldBuilding.GuildWar, self.config.guildWar, SpriteAreaBuilding, function()
        self:OnClickGuildWar()
    end)
    self:InitLocalization()
end

function GuildAreaWorld:InitLocalization()
    if self.buildingDict == nil then
        return
    end
    --- @param k GuildAreaWorldBuilding
    --- @param v MainAreaBuilding
    for k, v in ipairs(self.buildingDict:GetItems()) do
        v:FixedTittle(self:GetBuildingTitle(k))
    end
end

function GuildAreaWorld:_InitViewPortEvent()
    local entry = U_EventSystems.EventTrigger.Entry()
    entry.eventID = U_EventSystems.EventTriggerType.Drag
    entry.callback:AddListener(function(data)
        self:_OnPointerDrag(data)
    end)
    self.config.viewport.triggers:Add(entry)
end

function GuildAreaWorld:_InitView()
    local height = 2 * self.config.camera.orthographicSize
    local width = height * self.config.camera.aspect
    GuildAreaWorldModel.cameraBoundLeft = GuildAreaWorldModel.clampLeft + width / 2
    GuildAreaWorldModel.cameraBoundRight = GuildAreaWorldModel.clampRight - width / 2
    GuildAreaWorldModel.camMoveLength = GuildAreaWorldModel.cameraBoundRight - GuildAreaWorldModel.cameraBoundLeft
end

function GuildAreaWorld:OnShow()
    self.guildBasicInfo = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)

    self:SetActive(true)
    self:CheckAllNotification()
    self:CheckGuildWarStatus()

    ClientConfigUtils.KillCoroutine(self._camCoroutine)
    self._camCoroutine = Coroutine.start(function()
        local camTrans = self.config.camera.transform
        camTrans.localPosition = u_Vector3(0, 0, -10)
        local refVelocity = u_Vector3.zero
        --- @type UnityEngine_Vector3
        local camAxisX = 0
        camAxisX = -(self.config.content.anchoredPosition3D.x / GuildAreaWorldModel.deltaMoveRectContent) * GuildAreaWorldModel.camMoveLength * 0.5
        camTrans.localPosition = u_Vector3(camAxisX, 0, -10)
        local oldPosX = self.config.content.anchoredPosition3D.x
        while (true) do
            coroutine.yield(nil)
            if oldPosX ~= self.config.content.anchoredPosition3D.x then
                camAxisX = -(self.config.content.anchoredPosition3D.x / GuildAreaWorldModel.deltaMoveRectContent) * GuildAreaWorldModel.camMoveLength * 0.5
                camTrans.localPosition = u_Vector3.SmoothDamp(camTrans.localPosition, u_Vector3(camAxisX, 0, -10), refVelocity, U_Time.deltaTime)
                oldPosX = self.config.content.anchoredPosition3D.x
            end
        end
    end)
end

--- @param data UnityEngine_EventSystems_PointerEventData
function GuildAreaWorld:_OnPointerDrag(data)
    self.config.content.anchoredPosition3D = self.config.content.anchoredPosition3D
            + u_Vector3.right * data.delta.x * 0.8
    if self.config.content.anchoredPosition3D.x > GuildAreaWorldModel.deltaMoveRectContent then
        self.config.content.anchoredPosition3D = u_Vector3(GuildAreaWorldModel.deltaMoveRectContent, 0, 0)
    end
    if self.config.content.anchoredPosition3D.x < -GuildAreaWorldModel.deltaMoveRectContent then
        self.config.content.anchoredPosition3D = u_Vector3(-GuildAreaWorldModel.deltaMoveRectContent, 0, 0)
    end
end

function GuildAreaWorld:OnHide()
    BgWorldView.OnHide(self)
    ClientConfigUtils.KillCoroutine(self._camCoroutine)
    self:RemovePhaseTimer()
end

function GuildAreaWorld:CheckAllNotification()
    self:EnableNotificationBuilding(GuildAreaWorldBuilding.GuildWar, false)

    --- @type EventInBound
    local eventInBound = zg.playerData:GetEvents()
    --- @type EventPopupModel
    local eventDungeon = eventInBound:GetEvent(EventTimeType.GUILD_DUNGEON)
    local isGuildDungeonOpen = eventDungeon:IsOpening()
    self:EnableNotificationBuilding(GuildAreaWorldBuilding.GuildDungeon, isGuildDungeonOpen and InventoryUtils.GetMoney(MoneyType.GUILD_DUNGEON_STAMINA) > 0)
    self:EnableNotificationBuilding(GuildAreaWorldBuilding.GuildBoss, InventoryUtils.GetMoney(MoneyType.GUILD_BOSS_STAMINA) > 0)
    self:CheckNotificationGuildHall()
    self:CheckGuildMarketNotification()
end

function GuildAreaWorld:CheckGuildMarketNotification()
    local onSuccess = function()
        local notify = false
        notify = NotificationCheckUtils.ShopCheckNotification(PlayerDataMethod.GUILD_MARKET)
        self:EnableNotificationBuilding(GuildAreaWorldBuilding.GuildShop, notify)
    end
    local modeShopDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_MARKET)
    if modeShopDataInBound == nil then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_MARKET }, onSuccess, SmartPoolUtils.LogicCodeNotification)
    else
        onSuccess()
    end
end
function GuildAreaWorld:CheckNotificationGuildHall()
    local isAvailableToCheckIn = self.guildBasicInfo.isAvailableToCheckIn
    self:EnableNotificationBuilding(GuildAreaWorldBuilding.GuildHall, isAvailableToCheckIn)
    if isAvailableToCheckIn == true
            or self.guildBasicInfo.guildInfo.selfRole == GuildRole.MEMBER then
        return
    end
    local callbackNotificationLeader = function(isNotified)
        self:EnableNotificationBuilding(GuildAreaWorldBuilding.GuildHall, isNotified)
    end
    self.guildBasicInfo:CheckLeaderNotification(callbackNotificationLeader)
end

function GuildAreaWorld:CheckGuildWarStatus(forceUpdate)
    self.config.guildWarSeasonTimer:SetActive(false)

    self.config.textGuildWarSeasonTimer.text = ""
    local needRequest = {}
    if GuildWarTimeInBound.IsAvailableToRequest() or forceUpdate == true then
        needRequest[#needRequest + 1] = PlayerDataMethod.GUILD_WAR_TIME
    end
    if GuildWarInBound.IsAvailableToRequest() or forceUpdate == true then
        needRequest[#needRequest + 1] = PlayerDataMethod.GUILD_WAR
    end
    if #needRequest > 0 then
        PlayerDataRequest.RequestAndCallback(needRequest, function()
            self:OnGuildWarTimeLoaded()
        end)
    else
        self:OnGuildWarTimeLoaded()
    end
end

function GuildAreaWorld:OnClickGuildWar()
    GuildWarInBound.ValidateData(function()
        local currentPhase = self.guildWarTimeInBound:CurrentPhase()
        if currentPhase == GuildWarPhase.SPACE then
            local format = LanguageUtils.LocalizeCommon("season_open_in")
            local time = self.guildWarTimeInBound:GetTimeToCurrentPhaseEnd()
            local message = string.format("%s %s", format, TimeUtils.GetDeltaTime(time))
            SmartPoolUtils.ShowShortNotification(message)
        elseif currentPhase == GuildWarPhase.REGISTRATION then
            self:OnClickGuildWarOnRegistrationPhase()
        elseif currentPhase == GuildWarPhase.SETUP_DEFENDER then
            self:OnClickGuildWarOnSetupPhase()
        elseif currentPhase == GuildWarPhase.BATTLE then
            self:OnClickGuildWarOnBattlePhase()
        end
    end)
end

function GuildAreaWorld:OnGuildWarTimeLoaded()
    self.config.guildWarSeasonTimer:SetActive(true)

    self.guildWarTimeInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_TIME)
    self.guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)

    self.currentPhase = self.guildWarTimeInBound:CurrentPhase()

    self:EnableNotificationBuilding(GuildAreaWorldBuilding.GuildWar, self.currentPhase == GuildWarPhase.REGISTRATION and self.guildWarInBound.registered ~= true)
    if self.currentPhase == GuildWarPhase.SETUP_DEFENDER then
        local selfRole = self.guildBasicInfo.guildInfo:GetSelfRole()
        local guildWarConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig()
        if selfRole ~= GuildRole.MEMBER
                and self.guildWarInBound:CountSelectedForGuildWar() == 0
                and self.guildWarInBound:CountParticipants() >= guildWarConfig.numberMemberJoin then
            self:EnableNotificationBuilding(GuildAreaWorldBuilding.GuildWar, true)
        end
    elseif self.currentPhase == GuildWarPhase.BATTLE and self.guildWarInBound:CountSelectedForGuildWar() > 0 then
        if InventoryUtils.GetMoney(MoneyType.GUILD_WAR_STAMINA) > 0 then
            self:EnableNotificationBuilding(GuildAreaWorldBuilding.GuildWar, true)
        end
    end
    self:SetPhaseTimer()

    -- CHECK PREVIOUS RESULT
    self:CheckGuildWarBattleResult(function()
        self:CheckGuildWarSeasonResult()
    end)
end

function GuildAreaWorld:SetPhaseTimer()
    if self.currentPhase == nil then
        self.config.textGuildWarSeasonTimer.text = LanguageUtils.LocalizeCommon("closed")
        return
    end
    local format = string.format("")
    if self.currentPhase == GuildWarPhase.SPACE then
        format = LanguageUtils.LocalizeCommon("season_open_in")
    else
        format = string.format("%s %s",
                LanguageUtils.LocalizeCommon(string.format("guild_war_phase_%s_name", self.currentPhase)),
                LanguageUtils.LocalizeCommon("will_end_in"))
    end
    self:RemovePhaseTimer()
    local onEndTime = function()
        self:RemovePhaseTimer()
        self:CheckGuildWarStatus(true)
    end
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            if self.currentPhase == self.guildWarTimeInBound:CurrentPhase() then
                self.timeRefresh = self.guildWarTimeInBound:GetTimeToCurrentPhaseEnd()
            else
                onEndTime()
            end
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self.timeRefresh >= 0 then
            self.config.textGuildWarSeasonTimer.text = string.format("%s %s",
                    format,
                    UIUtils.SetColorString(UIUtils.color7, TimeUtils.GetDeltaTime(self.timeRefresh)))
        else
            onEndTime()
        end
    end
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function GuildAreaWorld:RemovePhaseTimer()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
end

--- @param openTime number
function GuildAreaWorld:ShowSpacePhaseStatus(openTime)
    self.config.textGuildWarSeasonTimer.text = ""
    --- @type MainAreaBuilding
    local guildWarBuilding = self.buildingDict:Get(GuildAreaWorldBuilding.GuildWar)
    guildWarBuilding:AddListener(function()
        local svTime = zg.timeMgr:GetServerTime()
        if openTime > svTime then
            SmartPoolUtils.ShowShortNotification(
                    string.format("%s %s",
                            UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("will_open_in")),
                            UIUtils.SetColorString(UIUtils.color2, TimeUtils.SecondsToClock(openTime - zg.timeMgr:GetServerTime()))))
        else
            self.view:OnRegisterGuildWar()
        end
    end)
end

function GuildAreaWorld:ShowRegistrationPhaseStatus()
    --- @type MainAreaBuilding
    local guildWarBuilding = self.buildingDict:Get(GuildAreaWorldBuilding.GuildWar)

    local color = UIUtils.color7
    if self.guildWarInBound.listParticipants:Count() >= self.guildWarConfig.numberMemberJoin then
        color = UIUtils.color2
    end
    if self.guildWarInBound.registered ~= true then
        guildWarBuilding:AddListener(function()
            self.view:OnRegisterGuildWar()
        end)
    elseif self.guildWarInBound.registered == true then
        guildWarBuilding:AddListener(function()
            self.view:OnClickChangeFormation()
        end)
    end
end

function GuildAreaWorld:ShowSetUpDefenderPhaseStatus()

end

function GuildAreaWorld:OnRegisterGuildWar()
    local result = {}
    result.gameMode = GameMode.GUILD_WAR
    result.tittle = LanguageUtils.LocalizeCommon("save")
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation2)
        PopupMgr.ShowPopup(UIPopupName.UIGuildArea)
    end
    local onSuccess = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation2)
        PopupMgr.ShowPopup(UIPopupName.UIGuildWarRegistration)
    end
    result.callbackPlayBattle = function(uiFormationTeamData)
        self.guildWarInBound:RegisterMemberForGuildWar(uiFormationTeamData, onSuccess, result.callbackClose)
    end
    PopupMgr.HidePopup(UIPopupName.UIGuildArea)
    PopupMgr.ShowPopup(UIPopupName.UIFormation2, result)
end

function GuildAreaWorld:OnClickGuildWarOnRegistrationPhase()
    if self.guildWarInBound.registered == true
            and self.guildWarInBound.guildId == self.guildBasicInfo.guildInfo.guildId then
        PopupMgr.HidePopup(UIPopupName.UIGuildArea)
        PopupMgr.ShowPopup(UIPopupName.UIGuildWarRegistration)
    else
        self:OnRegisterGuildWar()
    end
end

function GuildAreaWorld:OnClickGuildWarOnSetupPhase()
    if self.guildWarInBound:CountTotalParticipants() < self.guildWarConfig.numberMemberJoin then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_enough_member_registered"))
        return
    end
    local selfRole = self.guildBasicInfo.guildInfo.selfRole
    if selfRole == GuildRole.LEADER or selfRole == GuildRole.SUB_LEADER then
        if self.guildWarInBound:CountSelectedForGuildWar() == 0 then
            self:GoToGuildWarSetup()
        else
            self:GoToGuildWarRegistration()
        end
    else
        self:GoToGuildWarRegistration()
    end
end

function GuildAreaWorld:OnClickGuildWarOnBattlePhase()
    zg.playerData:GetGuildData():ValidateGuildWarOpponent(function()
        self:GoToGuildWarBattlePhase()
    end, function(logicCode)
        if logicCode == LogicCode.GUILD_WAR_OPPONENT_CAN_NOT_BE_FOUND then
            PopupMgr.ShowPopup(UIPopupName.UIGuildWarBattleFreeWin)
        else
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
    end)
end

function GuildAreaWorld:GoToGuildWarSetup()
    PopupMgr.HidePopup(UIPopupName.UIGuildArea)
    PopupMgr.ShowPopup(UIPopupName.UIGuildWarSetup)
end

function GuildAreaWorld:GoToGuildWarRegistration()
    PopupMgr.HidePopup(UIPopupName.UIGuildArea)
    PopupMgr.ShowPopup(UIPopupName.UIGuildWarRegistration)
end

function GuildAreaWorld:GoToGuildWarBattlePhase()
    zg.playerData:GetGuildData():GetLastGuildWarSeasonCheckOut(function()
        PopupMgr.HidePopup(UIPopupName.UIGuildArea)
        PopupMgr.ShowPopup(UIPopupName.UIGuildWarPhase3Main)
    end)
end

function GuildAreaWorld:CheckGuildWarBattleResult(callbackSuccess)
    if zg.playerData._guildWarBattleIdCache ~= self.guildWarInBound.battleIdOfGuildWar then
        zg.playerData._guildWarBattleIdCache = self.guildWarInBound.battleIdOfGuildWar

        ---@type GuildWarPreviousBattleResultInBound
        local previousInBound = nil
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            previousInBound = GuildWarPreviousBattleResultInBound.CreateByBuffer(buffer)
        end
        local success = function()
            if zg.playerData.remoteConfig.guildWarResult == nil then
                zg.playerData.remoteConfig.guildWarResult = {}
            end

            if zg.playerData.remoteConfig.guildWarResult.battleId ~= previousInBound.battleId then
                local data = {}
                data.data = previousInBound
                if previousInBound.isWin then
                    data.callbackClose = function()
                        PopupMgr.HidePopup(UIPopupName.UIGuildWarBattleVictory)
                        if callbackSuccess ~= nil then
                            callbackSuccess()
                        end
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIGuildWarBattleVictory, data)
                else
                    data.callbackClose = function()
                        PopupMgr.HidePopup(UIPopupName.UIGuildWarBattleDefeat)
                        if callbackSuccess ~= nil then
                            callbackSuccess()
                        end
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIGuildWarBattleDefeat, data)
                end
                zg.playerData.remoteConfig.guildWarResult.battleId = previousInBound.battleId
                zg.playerData:SaveRemoteConfig()
            else
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.GUILD_WAR_PREVIOUS_BATTLE_RESULT_GET,
                nil, success, callbackSuccess, onBufferReading, true)
    end
end

function GuildAreaWorld:CheckGuildWarSeasonResult()
    if zg.playerData._guildWarSeasonCache ~= self.guildWarInBound.season then
        zg.playerData._guildWarSeasonCache = self.guildWarInBound.season
        ---@type GuildWarPreviousSeasonResultInBound
        local previousInBound = nil
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            previousInBound = GuildWarPreviousSeasonResultInBound.CreateByBuffer(buffer)
        end
        local success = function()
            if zg.playerData.remoteConfig.guildWarResult == nil then --hoangpl resolve error
                zg.playerData.remoteConfig.guildWarResult = {}
            end
            if zg.playerData.remoteConfig.guildWarResult.seasonId ~= previousInBound.season then
                PopupMgr.ShowPopup(UIPopupName.UIGuildWarSeasonResult, previousInBound)
                zg.playerData.remoteConfig.guildWarResult.seasonId = previousInBound.season
                zg.playerData:SaveRemoteConfig()
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.GUILD_WAR_PREVIOUS_SEASON_RESULT_GET,
                nil, success, onFailed, onBufferReading, true)
    end
end

--- @param guildAreaWorldBuilding GuildAreaWorldBuilding
function GuildAreaWorld:GetBuildingTitle(guildAreaWorldBuilding)
    if guildAreaWorldBuilding == GuildAreaWorldBuilding.GuildHall then
        return LanguageUtils.LocalizeCommon("guild_hall")
    elseif guildAreaWorldBuilding == GuildAreaWorldBuilding.GuildBoss then
        return LanguageUtils.LocalizeGameMode(GameMode.GUILD_BOSS)
    elseif guildAreaWorldBuilding == GuildAreaWorldBuilding.GuildDungeon then
        return LanguageUtils.LocalizeGameMode(GameMode.GUILD_DUNGEON)
    elseif guildAreaWorldBuilding == GuildAreaWorldBuilding.GuildWar then
        return LanguageUtils.LocalizeGameMode(GameMode.GUILD_WAR)
    elseif guildAreaWorldBuilding == GuildAreaWorldBuilding.GuildShop then
        return LanguageUtils.LocalizeCommon("guild_shop")
    end
end

--- @param guildAreaWorldBuilding GuildAreaWorldBuilding
--- @param isEnable boolean
function GuildAreaWorld:EnableNotificationBuilding(guildAreaWorldBuilding, isEnable)
    --- @type MainAreaBuilding
    local mainAreaBuilding = self.buildingDict:Get(guildAreaWorldBuilding)
    mainAreaBuilding:EnableNotify(isEnable)
end

--- @class GuildAreaWorldBuilding
GuildAreaWorldBuilding = {
    GuildHall = 1,
    GuildWar = 2,
    GuildBoss = 3,
    GuildDungeon = 4,
    GuildShop = 5,
}