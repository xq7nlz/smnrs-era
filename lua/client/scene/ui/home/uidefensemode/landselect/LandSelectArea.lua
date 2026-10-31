require "lua.client.scene.ui.home.uiDefenseMode.LandSelect.LandElementView"
local deltaMoveRectContent = 500
local camMoveLength = nil

--- @type UnityEngine_Vector3
local u_Vector3 = U_Vector3

--- @class LandSelectArea
LandSelectArea = Class(LandSelectArea)
LandSelectArea.CONVERT = 0
LandSelectArea.RANGE = 3
LandSelectArea.CLAMP_LEFT = -20.5
LandSelectArea.CLAMP_RIGHT = 11
function LandSelectArea:Ctor(transform, onShowPopup, onClickBubble)
    --- @type DG_Tweening_Tweener
    self._camTweener = nil
    --- @type GuildWarDefenseWorldBase
    self.dragSlot = nil
    --- @type LandSelectConfig
    self.config = nil
    --- @type function
    self.onSelectBaseSlot = nil

    --- @type BasicInfoInBound
    self.summonerInbound = nil
    --- @type CampaignData
    self.campaignData = nil
    ---@type DefenseModeConfig
    self.defenseModeConfig = ResourceMgr.GetDefenseModeConfig()

    self.callBackShowPopup = onShowPopup
    self.onClickBubble = onClickBubble
    --- @type number
    self.clampLeft = LandSelectArea.CLAMP_LEFT
    --- @type number
    self.clampRight = LandSelectArea.CLAMP_RIGHT
    --- @type number
    self.cameraViewWidth = nil

    --- @type Dictionary
    self.landDic = Dictionary()

    self:InitConfig(transform)
    self:_InitListener()
    self:InitLands()
end

function LandSelectArea:InitConfig(transform)
    self:SetConfig(transform)
end
function LandSelectArea:SetConfig(transform)
    --- @type GuildWarAreaConfig
    self.config = UIBaseConfig(transform)
    self.config.transform:SetParent(zgUnity.transform)
    self.config.transform.position = u_Vector3.zero
    self.config.transform.localScale = u_Vector3.one

    local camViewHeight = 2 * math.tan((MainAreaWorldModel.fieldOfView / 2) / 180 * 3.1428) * MainAreaWorldModel.cameraDistance
    local cameraViewWidth = U_Screen.width / U_Screen.height * camViewHeight / 2
    MainAreaWorldModel.cameraBoundLeft = MainAreaWorldModel.clampLeft + cameraViewWidth
    MainAreaWorldModel.cameraBoundRight = MainAreaWorldModel.clampRight - cameraViewWidth
    MainAreaWorldModel.camMoveLength = MainAreaWorldModel.cameraBoundRight - MainAreaWorldModel.cameraBoundLeft
end

function LandSelectArea:InitLocalization()
    if self.landDic then
        --- @param v LandElementView
        for _, v in pairs(self.landDic:GetItems()) do
            v:InitLocalization()
        end
    end
end

function LandSelectArea:_InitListener()
    local entry = U_EventSystems.EventTrigger.Entry()
    entry.eventID = U_EventSystems.EventTriggerType.Drag
    entry.callback:AddListener(function(data)
        self:_OnPointerDrag(data)
    end)
    self.config.viewportEventTrigger.triggers:Add(entry)
end

function LandSelectArea:SetupLandWithId(landId)
    local level = self.summonerInbound.level
    local stage = self.campaignData.stageCurrent
    local unlockLandConfig = self.defenseModeConfig:GetLandUnlockConfig(landId)
    local isUnlock = unlockLandConfig:IsUnlocked(level, stage)
    local condition = function()
        if stage < unlockLandConfig.stage then
            local difficult, map, _stage = ClientConfigUtils.GetIdFromStageId(unlockLandConfig.stage)
            SmartPoolUtils.ShowShortNotification(StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("require_stage_x"), LanguageUtils.LocalizeDifficult(difficult), map, _stage))
        elseif level < unlockLandConfig.level then
            SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("require_level_x"), unlockLandConfig.level))
        else
            SmartPoolUtils.ShowNotificationFeatureState(unlockLandConfig.unlockState)
        end

    end
    return isUnlock, condition
end

function LandSelectArea:InitLands()
    ---@param landView LandElementView
    local addLands = function(landView)
        local land = landView
        local entryPointerDown = U_EventSystems.EventTrigger.Entry()
        entryPointerDown.eventID = U_EventSystems.EventTriggerType.PointerDown
        entryPointerDown.callback:AddListener(function(data)
            land:OnPointerDown()
        end)
        local entryPointerUp = U_EventSystems.EventTrigger.Entry()
        entryPointerUp.eventID = U_EventSystems.EventTriggerType.PointerUp
        entryPointerUp.callback:AddListener(function(data)
            land:OnPointerUp()
        end)
        --- @type UnityEngine_EventSystems_EventTrigger_Entry
        local entryBeginDrag = U_EventSystems.EventTrigger.Entry()
        entryBeginDrag.eventID = U_EventSystems.EventTriggerType.BeginDrag
        entryBeginDrag.callback:AddListener(function(data)
            land:OnBeginDrag()
        end)
        --- @type UnityEngine_EventSystems_EventTrigger_Entry
        local entryDrag = U_EventSystems.EventTrigger.Entry()
        entryDrag.eventID = U_EventSystems.EventTriggerType.Drag
        entryDrag.callback:AddListener(
                function(data)
                    self:_OnPointerDrag(data)
                end)
        land.config.eventTrigger.triggers:Add(entryPointerDown)
        land.config.eventTrigger.triggers:Add(entryPointerUp)
        land.config.eventTrigger.triggers:Add(entryBeginDrag)
        land.config.eventTrigger.triggers:Add(entryDrag)
    end
    local onClickLand = function(landPickId)
        self:HideAllLands(landPickId)
    end
    local onClickBubble = function(landId, key)
        self.onClickBubble(landId, key)
    end
    local hideLand = function(landId, isHide)
        if isHide == nil then
            isHide = false
        end
        self.config.fxUiWorldDefenseModeAnchor:GetChild(landId - 1).gameObject:SetActive(isHide)

    end
    for i = 1, self.config.landContainer.childCount do
        local landTransform = self.config.landContainer:GetChild(i - 1)
        ---@type LandElementView
        local landView = LandElementView(landTransform, onClickLand, i, onClickBubble, hideLand)
        addLands(landView)
        self.landDic:Add(i, landView)
    end
end
---@return LandElementView
function LandSelectArea:GetLandWithId(id)
    if self.landDic:IsContainKey(id) then
        return self.landDic:Get(id)
    end
    return nil
end

function LandSelectArea:SetLands()
    ---@param v LandElementView
    for i, v in pairs(self.landDic:GetItems()) do
        local isUnlock, condition = self:SetupLandWithId(v.landId)
        v:SetUnlock(isUnlock, condition)
    end
end
function LandSelectArea:HideAllLands(landPickId)
    self.canDrag = false
    local landOpen = nil
    for k, v in pairs(self.landDic:GetItems()) do
        if v.landId == landPickId then
            v:OpenLand()
            landOpen = v
            self.config.fxUiWorldDefenseModeAnchor:GetChild(k - 1).gameObject:SetActive(v.landId == landPickId)
        else
            v:HideLand()
        end
        v:SetActiveButton(false)
    end
    if landOpen ~= nil then
        self:EnableUpdateScroll(false)
        self:AutoFocus(landOpen.config.transform.position, function()
            self.callBackShowPopup(landPickId)
        end)
    end
end

function LandSelectArea:OpenAllLands()
    self.canDrag = true
    for k, v in pairs(self.landDic:GetItems()) do
        v:OpenLand()
        v:SetActiveButton(true)
    end
end

function LandSelectArea:UpdateAllBubbleTimeAndResource()
    --- @param v LandElementView
    for k, v in pairs(self.landDic:GetItems()) do
        v:UpdateBubbleTimeAndResource()
    end
end

---@param data Dictionary
function LandSelectArea:SetAllDefenseModeData(data)
    --- @param v IdleDefenseModeData
    for k, v in pairs(data:GetItems()) do
        if self.landDic:IsContainKey(k) then
            ---@type LandElementView
            local landView = self.landDic:Get(k)
            landView:SetDefenseModeData(v)
        end
    end
end

--- @param clampLeft number
--- @param clampRight number
function LandSelectArea:Show()
    self.summonerInbound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    self.campaignData = zg.playerData:GetCampaignData()
    self:SetClampCameraView()
    self:SetActive(true)
    self:SetLands()
    self:EnableUpdateScroll()
    self:OpenAllLands()
    if self.cacheCovert == nil then
        LandSelectArea.CONVERT = -math.abs(self.config.content.anchoredPosition3D.x / self.config.camTrans.position.x)
        self.cacheCovert = true
    end
    self:CalculateClampContent()
end

--- @param isEnable boolean
function LandSelectArea:SetSwapAble(isEnable)
    self.config.rayCaster.enabled = isEnable
end

--- @param isEnable boolean
function LandSelectArea:SetListSelectedMember(isEnable, x)
end

function LandSelectArea:EnableUpdateScroll(isEnable)
    ClientConfigUtils.KillCoroutine(self._camTweener)
    isEnable = isEnable == nil and true or isEnable
    if isEnable == false then
        return
    end
    self._camTweener = Coroutine.start(function()
        local camTrans = self.config.camTrans
        local refVelocity = u_Vector3.zero
        --- @type UnityEngine_Vector3
        local camAxisX = 0
        local updateCamAxisX = function()
            local rateScroll = -self.config.content.anchoredPosition3D.x / deltaMoveRectContent
            local delta = rateScroll * camMoveLength / 2
            camAxisX = (self.clampLeft + self.clampRight) / 2 + delta
            --XDebug.Log(string.format("rateScroll: %s, delta: %s, camAxisX: %s, camMoveLength: %s", rateScroll, delta, camAxisX, camMoveLength))
        end
        updateCamAxisX()
        local contentTrans = self.config.content
        camTrans.localPosition = u_Vector3(camAxisX, 0, camTrans.localPosition.z)
        local oldPosX = contentTrans.anchoredPosition3D.x
        while (true) do
            coroutine.yield(nil)
            if oldPosX ~= contentTrans.anchoredPosition3D.x then
                updateCamAxisX()
                oldPosX = contentTrans.anchoredPosition3D.x
            end
            if camTrans.localPosition.x ~= camAxisX then
                camTrans.localPosition = u_Vector3.SmoothDamp(camTrans.localPosition, u_Vector3(camAxisX, 0, camTrans.localPosition.z), refVelocity, U_Time.deltaTime)
            end
        end
    end)
end

function LandSelectArea:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

function LandSelectArea:Hide()
    self.onSelectBaseSlot = nil

    self:ReturnPool()
    self:SetActive(false)
end

function LandSelectArea:ReturnPool()
    self:SetActive(false)
    ClientConfigUtils.KillCoroutine(self._camTweener)
    for k, v in pairs(self.landDic:GetItems()) do
        v:ReturnPool()
    end
end

--- @param data UnityEngine_EventSystems_PointerEventData
function LandSelectArea:_OnPointerDrag(data)
    if self.canDrag == nil or self.canDrag == true then
        self.config.content.anchoredPosition3D = self.config.content.anchoredPosition3D
                + u_Vector3.right * data.delta.x * 0.8
        local pos = U_Vector3(self.config.content.anchoredPosition3D.x, self.config.content.anchoredPosition3D.y, -35)
        pos.x = MathUtils.Clamp(self.config.content.anchoredPosition3D.x, -deltaMoveRectContent, deltaMoveRectContent)
        self.config.content.anchoredPosition3D = pos
    end
end

function LandSelectArea:SlotTriggerPointerDown(isLeft, slotIndex)
end

function LandSelectArea:SlotTriggerPointerUp(isLeft, slotIndex)

end

function LandSelectArea:SlotTriggerPointerDrag(isLeft, slotIndex)

end

function LandSelectArea:CallbackSelectSlot(isLeft, slotIndex)

end

--- @param clampLeft number
--- @param clampRight number
function LandSelectArea:SetClampCameraView()
    local clampLeft = LandSelectArea.CLAMP_LEFT
    local clampRight = LandSelectArea.CLAMP_RIGHT
    local clampLength = clampRight - clampLeft
    self.cameraViewWidth = 2 * self.config.camera.orthographicSize * self.config.camera.aspect
    if clampLength < self.cameraViewWidth then
        if clampRight < clampLeft + self.cameraViewWidth then
            clampRight = clampLeft + self.cameraViewWidth
        elseif clampLeft > clampRight - self.cameraViewWidth then
            clampLeft = clampRight - self.cameraViewWidth
        end
    end
    --local camPos = self.config.camTrans.position
    --camPos.x = (self.clampRight + self.clampLeft) / 2
    --self.config.camTrans.position = camPos

    self.clampLeft = clampLeft
    self.clampRight = clampRight

    camMoveLength = self.clampRight - self.clampLeft - self.cameraViewWidth
end

function LandSelectArea:CalculateClampContent()
    self.config.content.localPosition = U_Vector3(500, self.config.content.localPosition.y, -35)
end

function LandSelectArea:AutoFocus(pos, showPopup)
    self:SetClampRight(false)
    local range = pos.x + LandSelectArea.RANGE
    local touch = TouchUtils.Spawn("LandSelectArea:AutoFocus")
    local temp = math.abs(range - self.config.camTrans.position.x)
    local timeMove = temp < 1 and 0.1 or 0.3
    self.config.camTrans:DOLocalMoveX(range, timeMove):OnComplete(function()
        if showPopup ~= nil then
            showPopup()
        end
        self.config.content.localPosition = U_Vector3(self.config.camTrans.position.x * LandSelectArea.CONVERT, self.config.content.localPosition.y, -35)
        touch:Enable()
    end)
end
function LandSelectArea:SetClampRight(option)
    --- false return 19.5, true return 9.5

    if not option then
        LandSelectArea.CLAMP_RIGHT = 20.5
    else
        LandSelectArea.CLAMP_RIGHT = 11
    end
    self:SetClampCameraView()
end

function LandSelectArea:IsRestrictArea()
    local x = self.config.camTrans.localPosition.x
    return x > -0.5700008
end

return LandSelectArea