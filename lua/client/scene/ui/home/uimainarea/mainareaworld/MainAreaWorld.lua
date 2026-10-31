require "lua.client.scene.ui.home.uiMainArea.mainAreaWorld.MainAreaWorldModel"
require "lua.client.scene.ui.home.uiMainArea.mainAreaBuilding.MainAreaBuilding"
require "lua.client.scene.ui.home.uiMainArea.mainAreaBuilding.SpineAreaBuilding"
require "lua.client.scene.ui.home.uiMainArea.mainAreaBuilding.SpriteAreaBuilding"
require "lua.client.scene.ui.home.uiMainArea.mainAreaBuilding.ArenaSpineAreaBuilding"

--- @class MainAreaWorld
MainAreaWorld = Class(MainAreaWorld)

--- @type UnityEngine_Vector3
local u_Vector3 = U_Vector3

--- @param transform UnityEngine_Transform
--- @param view UIMainAreaView
function MainAreaWorld:Ctor(transform, view)
    --- @type MainAreaWorldConfig
    self.config = UIBaseConfig(transform)
    --- @type UIMainAreaView
    self.view = view
    --- @type Coroutine
    self._camCoroutine = nil
    self._effectCampaignChecker = nil
    self.lastLevelCheck = nil
    self.lastCampaignCheck = nil
    --- @type function
    self.updateTime = nil

    --- @type Dictionary | {featureType : FeatureType, mainAreaBuilding : MainAreaBuilding}
    self.buildingFeature = Dictionary()
    --- @type MainAreaBuilding
    self.missionNpc = nil
    self:_Init()
end

function MainAreaWorld:_Init()
    self:_InitView()
    self:_InitListener()
    self:_InitBuilding()
end

--- @return void
function MainAreaWorld:InitLocalization()
    --- @param featureType FeatureType
    --- @param v MainAreaBuilding
    for featureType, v in pairs(self.buildingFeature:GetItems()) do
        v:InitLocalize(featureType)
    end
    self.missionNpc:FixedTittle(LanguageUtils.LocalizeCommon("mission"))
end

function MainAreaWorld:_InitView()
    self.config.transform:SetParent(zgUnity.transform)
    self.config.transform.position = u_Vector3.zero
    self.config.transform.localScale = u_Vector3.one

    local camViewHeight = 2 * math.tan((MainAreaWorldModel.fieldOfView / 2) / 180 * 3.1428) * MainAreaWorldModel.cameraDistance
    local cameraViewWidth = U_Screen.width / U_Screen.height * camViewHeight / 2
    MainAreaWorldModel.cameraBoundLeft = MainAreaWorldModel.clampLeft + cameraViewWidth
    MainAreaWorldModel.cameraBoundRight = MainAreaWorldModel.clampRight - cameraViewWidth
    MainAreaWorldModel.camMoveLength = MainAreaWorldModel.cameraBoundRight - MainAreaWorldModel.cameraBoundLeft
end

function MainAreaWorld:_InitListener()
    local entry = U_EventSystems.EventTrigger.Entry()
    entry.eventID = U_EventSystems.EventTriggerType.Drag
    entry.callback:AddListener(function(data)
        self:_OnPointerDrag(data)
    end)
    self.config.viewport_event_trigger.triggers:Add(entry)
end

function MainAreaWorld:_InitBuilding()
    --- @param featureType FeatureType
    --- @param transform UnityEngine_Transform
    --- @param buildingType MainAreaBuilding
    --- @param onClickBuilding function
    local addMainAreaBuilding = function(featureType, transform, buildingType, onClickBuilding)
        local areaBuilding = buildingType(transform)
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
            self:OnClickFeatureBuilding(featureType)
            if featureType == FeatureType.SUMMON then
                local eventRateUp = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_RATE_UP)
                if eventRateUp ~= nil and eventRateUp:IsOpening() then
                    zg.playerData.remoteConfig.lastTimeOpenRateUp = zg.timeMgr:GetServerTime()
                    zg.playerData:SaveRemoteConfig()
                end
            end
            if onClickBuilding then
                onClickBuilding()
            end
        end)
        if featureType ~= nil then
            self.buildingFeature:Add(featureType, areaBuilding)
        end
        return areaBuilding
    end

    addMainAreaBuilding(FeatureType.PROPHET_TREE, self.config.prophetSummon, SpineAreaBuilding)
    addMainAreaBuilding(FeatureType.RAID, self.config.raid, SpineAreaBuilding)
    addMainAreaBuilding(FeatureType.CASINO, self.config.casino, SpineAreaBuilding)
    addMainAreaBuilding(FeatureType.TAVERN, self.config.tavern, SpineAreaBuilding)
    addMainAreaBuilding(FeatureType.BLACK_MARKET, self.config.blackmarket, SpineAreaBuilding)
    addMainAreaBuilding(FeatureType.SUMMON, self.config.summonCircle, SpineAreaBuilding)
    addMainAreaBuilding(FeatureType.BLACK_SMITH, self.config.blacksmith, SpineAreaBuilding)
    addMainAreaBuilding(FeatureType.ARENA, self.config.arena, ArenaSpineAreaBuilding)
    addMainAreaBuilding(FeatureType.TOWER, self.config.tower, SpineAreaBuilding, function()
        if NotificationCheckUtils.IsCanShowSoftTutTower() then
            zg.playerData.remoteConfig.softTutTower = zg.timeMgr:GetServerTime()
            zg.playerData:SaveRemoteConfig()
        end
    end)
    addMainAreaBuilding(FeatureType.GUILD, self.config.guild, SpineAreaBuilding)
    addMainAreaBuilding(FeatureType.CAMPAIGN, self.config.campaign, SpriteAreaBuilding, function()
        if NotificationCheckUtils.IsCanShowSoftTutCampaign() then
            zg.playerData.remoteConfig.softTutCampaign = zg.timeMgr:GetServerTime()
            zg.playerData:SaveRemoteConfig()
        end
    end)
    addMainAreaBuilding(FeatureType.DUNGEON, self.config.aspen, SpriteAreaBuilding)
    addMainAreaBuilding(FeatureType.DEFENSE, self.config.defense, SpriteAreaBuilding)
    addMainAreaBuilding(FeatureType.DOMAINS, self.config.domains, SpriteAreaBuilding)

    self.missionNpc = addMainAreaBuilding(nil, self.config.mission, SpineAreaBuilding, function()
        self.view:OnClickMission()
    end)
end

function MainAreaWorld:CheckSoftTutCampaign()
    local isActive = NotificationCheckUtils.IsCanShowSoftTutCampaign()
    self.config.softTutCampaign:SetActive(isActive)
    return isActive
end

function MainAreaWorld:CheckSoftTutTower()
    local isActive = NotificationCheckUtils.IsCanShowSoftTutTower() and (NotificationCheckUtils.IsCanShowSoftTutCampaign() == false)
    self.config.softTutTower:SetActive(isActive)
    return isActive
end

function MainAreaWorld:OnShow()
    self:SetActive(true)
    --- @param featureType FeatureType
    --- @param v MainAreaBuilding
    for featureType, v in pairs(self.buildingFeature:GetItems()) do
        v:OnShow(featureType)
    end

    ClientConfigUtils.KillCoroutine(self._camCoroutine)
    self._camCoroutine = Coroutine.start(function()
        local camHeight = -0.45
        --local buildingConfig = ResourceMgr.GetMainArenaConfig():GetBuilding()
        local camTrans = self.config.camTrans
        camTrans.localPosition = u_Vector3(0, camHeight, -MainAreaWorldModel.cameraDistance)
        local refVelocity = u_Vector3.zero
        --- @type UnityEngine_Vector3
        local camAxisX = 0
        camAxisX = -(self.config.content.anchoredPosition3D.x / MainAreaWorldModel.deltaMoveRectContent) * MainAreaWorldModel.camMoveLength * 0.5
        camTrans.localPosition = u_Vector3(camAxisX, camHeight, -MainAreaWorldModel.cameraDistance)
        local oldPosX = self.config.content.anchoredPosition3D.x
        while (true) do
            coroutine.yield(nil)
            if oldPosX ~= self.config.content.anchoredPosition3D.x then
                camAxisX = -(self.config.content.anchoredPosition3D.x / MainAreaWorldModel.deltaMoveRectContent) * MainAreaWorldModel.camMoveLength * 0.5
                --camTrans.localPosition = u_Vector3.SmoothDamp(camTrans.localPosition, u_Vector3(camAxisX, camHeight, -MainAreaWorldModel.cameraDistance), refVelocity, U_Time.deltaTime)
                --camTrans.localPosition = u_Vector3(camAxisX, camHeight, -MainAreaWorldModel.cameraDistance)
                oldPosX = self.config.content.anchoredPosition3D.x
            end
            if camTrans.localPosition.x ~= camAxisX then
                camTrans.localPosition = u_Vector3.SmoothDamp(camTrans.localPosition, u_Vector3(camAxisX, camHeight, -MainAreaWorldModel.cameraDistance), refVelocity, U_Time.deltaTime)
            end
        end
    end)
end

function MainAreaWorld:ClampCameraPosition(x)
    if x ~= nil then
        self.config.camTrans.position = u_Vector3(x, self.config.camTrans.position.y, self.config.camTrans.position.z)
    end
    local camPos = self.config.camTrans.localPosition
    if camPos.x < MainAreaWorldModel.cameraBoundLeft then
        camPos.x = MainAreaWorldModel.cameraBoundLeft
    end
    if camPos.x > MainAreaWorldModel.cameraBoundRight then
        camPos.x = MainAreaWorldModel.cameraBoundRight
    end
    self.config.content.anchoredPosition3D = -self.config.camTrans.localPosition * MainAreaWorldModel.deltaMoveRectContent / (MainAreaWorldModel.camMoveLength * 0.5)
    self.config.camTrans.localPosition = camPos
end

function MainAreaWorld:_PlayEffectOnCampaign()
    ClientConfigUtils.KillCoroutine(self._effectCampaignChecker)
    self.config.model_campaign.AnimationState:SetAnimation(0, "idle", true)

    local elapse = 0
    local isTriggered = false
    local fps = ClientConfigUtils.FPS
    self._effectCampaignChecker = Coroutine.start(function()
        while true do
            coroutine.yield(nil)
            if elapse > (5.0 / fps)
                    and isTriggered == false then
                isTriggered = true
            end
            elapse = elapse + U_Time.deltaTime
            if elapse > 5.333 then
                elapse = 0
                isTriggered = false
            end
        end
    end)
end

--- @param pos number
function MainAreaWorld:ClampScrollPosition(pos)
    self.config.content.anchoredPosition3D = pos
    if self.config.content.anchoredPosition3D.x > MainAreaWorldModel.deltaMoveRectContent then
        self.config.content.anchoredPosition3D = u_Vector3(MainAreaWorldModel.deltaMoveRectContent, 0, 0)
    end
    if self.config.content.anchoredPosition3D.x < -MainAreaWorldModel.deltaMoveRectContent then
        self.config.content.anchoredPosition3D = u_Vector3(-MainAreaWorldModel.deltaMoveRectContent, 0, 0)
    end
end

--- @param data UnityEngine_EventSystems_PointerEventData
function MainAreaWorld:_OnPointerDrag(data)
    self:ClampScrollPosition(self.config.content.anchoredPosition3D + u_Vector3.right * data.delta.x * 0.8)
end

--- @return UnityEngine_Vector3
--- @param transform UnityEngine_Transform
function MainAreaWorld:GetBuildingPositionOnUI(transform)
    --- @type UnityEngine_Camera
    local cam = self.config.camera:GetComponent(ComponentName.UnityEngine_Camera)
    return uiCanvas.camIgnoreBlur:ScreenToWorldPoint(cam:WorldToScreenPoint(transform.position))
end

--- @param camX number
function MainAreaWorld:UpdateBuildingPerspective(buildingConfig, camX)
    --- @type {offsetX, mul}
    local summonCircleConfig = buildingConfig.summon_circle
    self.config.pSummonCircle.localPosition = u_Vector3(summonCircleConfig.offsetX + summonCircleConfig.mul * camX, 0, 0)
end

function MainAreaWorld:CheckShowFeatureIcon()
    --- @type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    if basicInfoInBound == nil then
        return
    end
    local level = basicInfoInBound.level
    local stageCurrent = zg.playerData:GetCampaignData().stageCurrent

    if self.lastLevelCheck ~= level or self.lastCampaignCheck ~= stageCurrent then
        --- @param k FeatureType
        --- @param v MainAreaBuilding
        for k, v in pairs(self.buildingFeature:GetItems()) do
            v:CheckUnlockFeature(k)
        end
        self.lastLevelCheck = level
        self.lastCampaignCheck = stageCurrent
    end

    self:CheckBuildingFeatureState()
end

--- @param featureType FeatureType
--- @param isEnable boolean
function MainAreaWorld:EnableFeatureNotify(featureType, isEnable)
    --- @type MainAreaBuilding
    local building = self.buildingFeature:Get(featureType)
    building:EnableNotify(isEnable)
end

function MainAreaWorld:CheckArenaSeason()
    self.config.arenaSeasonTimer:SetActive(false)
end

function MainAreaWorld:StartUpdateArenaSsTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if self.arenaSsRefresh > 0 then
            self.arenaSsRefresh = self.arenaSsRefresh - 1
            local textTime = TimeUtils.SecondsToClock(self.arenaSsRefresh)
            self.config.arenaTimer.text = string.format("%s %s",
                    self.localizeArenaTime,
                    UIUtils.SetColorString("587B1C", textTime))
        else
            EventInBound.ValidateEventModel(function()
                self:CheckArenaSeason()
            end, true, false, false)
        end
    end
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function MainAreaWorld:RemoveArenaSsUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
    self.config.arenaSeasonTimer:SetActive(false)
end

function MainAreaWorld:OnHide()
    self:SetActive(false)
    --- @param featureType FeatureType
    --- @param v MainAreaBuilding
    for featureType, v in pairs(self.buildingFeature:GetItems()) do
        v:OnHide()
    end
    ClientConfigUtils.KillCoroutine(self._camCoroutine)
    ClientConfigUtils.KillCoroutine(self._effectCampaignChecker)
    self:RemoveArenaSsUpdateTime()
    self.config.softTutTower:SetActive(false)
    self.config.softTutCampaign:SetActive(false)
end

function MainAreaWorld:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

function MainAreaWorld:OnClickFeatureBuilding(featureType)
    if featureType ~= nil then
        if featureType == FeatureType.ARENA then
            self:OnClickArena()
        else
            FeatureMapping.GoToFeature(featureType, true)
        end
    end
end

--- @param featureType FeatureType
function MainAreaWorld:GetButtonBuilding(featureType)
    --- @type MainAreaBuilding
    local building = self.buildingFeature:Get(featureType)
    return building:GetButton()
end

--- @param isEnable boolean
function MainAreaWorld:EnableMissionNotification(isEnable)
    self.missionNpc:EnableNotify(isEnable)
end

function MainAreaWorld:CheckBuildingFeatureState()
    --- @param _ FeatureType
    --- @param v MainAreaBuilding
    for _, v in pairs(self.buildingFeature:GetItems()) do
        v:CheckFeatureState()
    end
end

function MainAreaWorld:OnClickArena()
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    local featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.ARENA_TEAM)
    if featureItemInBound:IsAvailableToShowButton() then
        UIBaseView.CheckBlurMain(true, true, function()
            PopupMgr.ShowPopup(UIPopupName.UISelectArena)
        end)
    else
        FeatureMapping.GoToFeature(FeatureType.ARENA, true)
    end
end