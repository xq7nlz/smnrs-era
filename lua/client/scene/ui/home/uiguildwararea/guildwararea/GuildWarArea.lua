require "lua.client.scene.ui.home.uiGuildWarArea.guildWarArea.GuildWarAreaLand"

local deltaMoveRectContent = 500
local camMoveLength = nil

--- @type UnityEngine_Vector3
local u_Vector3 = U_Vector3

--- @class GuildWarArea
GuildWarArea = Class(GuildWarArea)

GuildWarArea.CLAMP_LEFT = -19.15
GuildWarArea.CLAMP_RIGHT = 19.15

function GuildWarArea:Ctor()
    --- @type DG_Tweening_Tweener
    self._camTweener = nil
    --- @type GuildWarAreaLand
    self.guildLand1 = nil
    --- @type GuildWarAreaLand
    self.guildLand2 = nil
    --- @type GuildWarDefenseWorldBase
    self.dragSlot = nil
    --- @type GuildWarAreaConfig
    self.config = nil
    --- @type function
    self.onSelectBaseSlot = nil

    --- @type number
    self.clampLeft = GuildWarArea.CLAMP_LEFT
    --- @type number
    self.clampRight = GuildWarArea.CLAMP_RIGHT
    --- @type number
    self.cameraViewWidth = nil

    self:InitConfig()
end

function GuildWarArea:InitConfig()
    self:SetPrefabName()
    self.gameObject = SmartPool.Instance:CreateGameObject(AssetType.UIPool, self.prefabName)
    self:SetConfig(self.gameObject.transform)

    self:_InitListener()
end

function GuildWarArea:SetPrefabName()
    self.prefabName = 'guild_war_area_world'
    self.uiPoolType = UIPoolType.GuildWarAreaWorld
end

--- @param transform UnityEngine_Transform
function GuildWarArea:SetConfig(transform)
    --- @type GuildWarAreaConfig
    self.config = UIBaseConfig(transform)

    self.guildLand1 = GuildWarAreaLand(self.config.left, true, self.config.camera)
    self.guildLand1.triggerSelectSlot = function(slotIndex)
        self:OnSelectBaseSlot(true, slotIndex)
    end
    self.guildLand1.onPointerDrag = function(data)
        self:_OnPointerDrag(data)
    end
    self.guildLand2 = GuildWarAreaLand(self.config.right, false, self.config.camera)
    self.guildLand2.triggerSelectSlot = function(slotIndex)
        self:OnSelectBaseSlot(false, slotIndex)
    end
    self.guildLand2.onPointerDrag = function(data)
        self:_OnPointerDrag(data)
    end
    self.config.canvas.overrideSorting = true
    self.config.canvas.sortingLayerID = ClientConfigUtils.BACKGROUND_LAYER_ID
    self.config.canvas.sortingOrder = 0
end

function GuildWarArea:InitLocalization()

end

function GuildWarArea:_InitListener()
    local entry = U_EventSystems.EventTrigger.Entry()
    entry.eventID = U_EventSystems.EventTriggerType.Drag
    entry.callback:AddListener(function(data)
        self:_OnPointerDrag(data)
    end)
    self.config.viewportEventTrigger.triggers:Add(entry)
end

--- @param clampLeft number
--- @param clampRight number
function GuildWarArea:Show(clampLeft, clampRight)
    self:SetClampCameraView(clampLeft, clampRight)
    self:SetActive(true)
end

--- @param isLeftSide boolean
--- @param slotCount number
function GuildWarArea:SetBaseSlot(isLeftSide, slotCount)
    --- @type GuildWarAreaLand
    local guildLand = self:GetGuildLandBySide(isLeftSide)
    guildLand:SetBaseSlot(slotCount)
end

function GuildWarArea:DisableHighlight()
    self.guildLand1:DisableHighlight()
    self.guildLand2:DisableHighlight()
    self:EnableCover(false)
end

--- @param isLeftSide boolean
--- @param listSelectedMember List
function GuildWarArea:SetListSelectedMember(isLeftSide, listSelectedMember)
    --- @type GuildWarAreaLand
    local guildLand = self:GetGuildLandBySide(isLeftSide)
    guildLand:SetListSelectedMember(listSelectedMember)
end

--- @return GuildWarAreaLand
function GuildWarArea:GetGuildLandBySide(isLeftSide)
    if isLeftSide then
        return self.guildLand1
    end
    return self.guildLand2
end

--- @param isEnable boolean
function GuildWarArea:SetSwapAble(isEnable)
    self.config.rayCaster.enabled = isEnable
end

function GuildWarArea:EnableUpdateScroll(isEnable)
    ClientConfigUtils.KillCoroutine(self._camTweener)
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
        end
        updateCamAxisX()
        local contentTrans = self.config.content
        camTrans.localPosition = u_Vector3(camAxisX, 0, -10)
        local oldPosX = contentTrans.anchoredPosition3D.x
        while (true) do
            coroutine.yield(nil)
            if oldPosX ~= contentTrans.anchoredPosition3D.x then
                updateCamAxisX()
                oldPosX = contentTrans.anchoredPosition3D.x
            end
            if camTrans.localPosition.x ~= camAxisX then
                camTrans.localPosition = u_Vector3.SmoothDamp(camTrans.localPosition, u_Vector3(camAxisX, 0, -10), refVelocity, U_Time.deltaTime)
            end
        end
    end)
end

function GuildWarArea:SetActive(isActive)
    self.gameObject:SetActive(isActive)
end

function GuildWarArea:Hide()
    self.onSelectBaseSlot = nil

    self:ReturnPool()

    self:EnableCover(false)
    self.guildLand1:DisableHighlight()
    self:HideAllTower()
end

function GuildWarArea:HideAllTower()
    self.guildLand1:HideAllTower()
    self.guildLand2:HideAllTower()
end

function GuildWarArea:ReturnPool()
    self:SetActive(false)
    SmartPool.Instance:DespawnLuaGameObject(AssetType.UIPool, UIPoolType.GuildWarAreaWorld, self)
    ClientConfigUtils.KillCoroutine(self._camTweener)
end

--- @param data UnityEngine_EventSystems_PointerEventData
function GuildWarArea:_OnPointerDrag(data)
    self.config.content.anchoredPosition3D = self.config.content.anchoredPosition3D
            + u_Vector3.right * data.delta.x * 0.8
    local pos = self.config.content.anchoredPosition3D
    pos.x = MathUtils.Clamp(self.config.content.anchoredPosition3D.x, -deltaMoveRectContent, deltaMoveRectContent)
    self.config.content.anchoredPosition3D = pos
end

function GuildWarArea:SlotTriggerPointerDown(isLeft, slotIndex)

end

function GuildWarArea:SlotTriggerPointerUp(isLeft, slotIndex)

end

function GuildWarArea:SlotTriggerPointerDrag(isLeft, slotIndex)

end

function GuildWarArea:CallbackSelectSlot(isLeft, slotIndex)

end

--- @return GuildWarDefenseWorldBase
--- @param isLeftSide boolean
--- @param slotIndex number
function GuildWarArea:GetGuildWarDefenseWorldBaseByIndex(isLeftSide, slotIndex)
    if isLeftSide == true then
        return self.guildLand1:GetDefenseBaseByPosition(slotIndex)
    end
    return self.guildLand2:GetDefenseBaseByPosition(slotIndex)
end

--- @param isLeftSide boolean
--- @param slotIndex number
function GuildWarArea:HighlightBasePosition(isLeftSide, slotIndex)
    self:EnableCover(true)
    --- @type GuildWarAreaLand
    local guildLand
    if isLeftSide == true then
        guildLand = self.guildLand1
    else
        guildLand = self.guildLand2
    end
    local base = guildLand:HighlightBaseByIndex(slotIndex)
    if base ~= nil then
        local camPos = self.config.camTrans.position
        camPos.x = base.config.transform.position.x + 2
        camPos.x = MathUtils.Clamp(camPos.x - self.cameraViewWidth / 2, self.clampLeft, self.clampRight)
        camPos.x = MathUtils.Clamp(camPos.x + self.cameraViewWidth / 2, self.clampLeft, self.clampRight)
        DOTweenUtils.DOLocalMoveX(self.config.camTrans, camPos.x, 0.5)
    end
end

function GuildWarArea:OnSelectBaseSlot(isLeftSide, slotIndex)
    if self.onSelectBaseSlot ~= nil then
        self.onSelectBaseSlot(isLeftSide, slotIndex)
    end
end

--- @param isEnable boolean
function GuildWarArea:EnableCover(isEnable)
    self.config.cover:SetActive(isEnable)
end

--- @param isLeftSide boolean
--- @param newPlayerInfo GuildWarPlayerInBound
function GuildWarArea:UpdateBaseInfoBySlot(isLeftSide, position, newPlayerInfo)
    local guildLand = self:GetGuildLandBySide(isLeftSide)
    guildLand:SetMemberBaseData(position, newPlayerInfo)
end

--- @param clampLeft number
--- @param clampRight number
function GuildWarArea:SetClampCameraView(clampLeft, clampRight)
    clampLeft = clampLeft or GuildWarArea.CLAMP_LEFT
    clampRight = clampRight or GuildWarArea.CLAMP_RIGHT
    local clampLength = clampRight - clampLeft
    self.cameraViewWidth = 2 * self.config.camera.orthographicSize * self.config.camera.aspect
    if clampLength < self.cameraViewWidth then
        if clampRight < clampLeft + self.cameraViewWidth then
            clampRight = clampLeft + self.cameraViewWidth
        elseif clampLeft > clampRight - self.cameraViewWidth then
            clampLeft = clampRight - self.cameraViewWidth
        end
    end
    local camPos = self.config.camTrans.position
    camPos.x = (self.clampRight + self.clampLeft) / 2
    self.config.camTrans.position = camPos

    self.clampLeft = clampLeft
    self.clampRight = clampRight

    camMoveLength = self.clampRight - self.clampLeft - self.cameraViewWidth

    self:CalculateClampContent()
end

function GuildWarArea:CalculateClampContent()
    self.config.content.anchoredPosition3D = u_Vector3.zero
end

return GuildWarArea