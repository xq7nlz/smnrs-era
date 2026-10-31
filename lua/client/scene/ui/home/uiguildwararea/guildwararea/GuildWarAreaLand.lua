require "lua.client.scene.ui.home.uiGuildWarArea.guildWarDefenseWorldBase.GuildWarDefenseWorldBase"

--- @class GuildWarAreaLand
GuildWarAreaLand = Class(GuildWarAreaLand)

--- @param transform UnityEngine_Transform
--- @param isLeftSide boolean
--- @param camera UnityEngine_Camera
function GuildWarAreaLand:Ctor(transform, isLeftSide, camera)
    --- @type UnityEngine_Transform
    self.transform = transform
    --- @type boolean
    self.isLeftSide = isLeftSide
    --- @type UnityEngine_Camera
    self.camera = camera

    --- @type Dictionary
    self.defenseBaseDict = Dictionary()

    --- @type function {isAttacker, {isFrontLine, positionId}}
    self.triggerSelectSlot = nil
    --- @type function
    self.onPointerDrag = nil
end

--- @return UnityEngine_Transform
function GuildWarAreaLand:GetBaseAnchor(index)
    return self.transform:GetChild(index - 1)
end

--- @return GuildWarDefenseWorldBase
--- @param index number
function GuildWarAreaLand:GetDefenseBaseByPosition(index)
    local baseAnchor = self:GetBaseAnchor(index)
    if baseAnchor == nil then
        XDebug.Error("Missing base anchor at position " .. index)
        return nil
    end
    --- @type GuildWarDefenseWorldBase
    local script = self.defenseBaseDict:Get(index)
    if script == nil then
        script = SmartPool.Instance:SpawnLuaGameObject(AssetType.UIPool, UIPoolType.GuildWarDefenseWorldBase)
        script:Init(baseAnchor)
        script.callbackSelect = function()
            self:OnSelectSlot(index)
        end
        local entryPointerDown = U_EventSystems.EventTrigger.Entry()
        entryPointerDown.eventID = U_EventSystems.EventTriggerType.PointerDown
        entryPointerDown.callback:AddListener(function(data)
            script:OnPointerDown()
        end)
        local entryPointerUp = U_EventSystems.EventTrigger.Entry()
        entryPointerUp.eventID = U_EventSystems.EventTriggerType.PointerUp
        entryPointerUp.callback:AddListener(function(data)
            script:OnPointerUp()
        end)
        --- @type UnityEngine_EventSystems_EventTrigger_Entry
        local entryBeginDrag = U_EventSystems.EventTrigger.Entry()
        entryBeginDrag.eventID = U_EventSystems.EventTriggerType.BeginDrag
        entryBeginDrag.callback:AddListener(function(data)
            script:OnBeginDrag()
        end)
        --- @type UnityEngine_EventSystems_EventTrigger_Entry
        local entryDrag = U_EventSystems.EventTrigger.Entry()
        entryDrag.eventID = U_EventSystems.EventTriggerType.Drag
        entryDrag.callback:AddListener(self.onPointerDrag)
        script.config.eventTrigger.triggers:Add(entryPointerDown)
        script.config.eventTrigger.triggers:Add(entryPointerUp)
        script.config.eventTrigger.triggers:Add(entryBeginDrag)
        script.config.eventTrigger.triggers:Add(entryDrag)

        script:SetRotationBySide(self.isLeftSide)
        self.defenseBaseDict:Add(index, script)
    end
    return script
end

--- @param slotCount number
function GuildWarAreaLand:SetBaseSlot(slotCount)
    --- @type GuildWarEloPositionConfig
    local guildWarEloPositionConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig()
    for i = 1, slotCount do
        --- @type GuildWarDefenseWorldBase
        local defenderWorldBase = self:GetDefenseBaseByPosition(i)
        if defenderWorldBase ~= nil then
            local elo = guildWarEloPositionConfig:GetEloByPosition(i)
            defenderWorldBase:SetBaseData(self.isLeftSide, i, elo)
            defenderWorldBase:SetActive(true)
        end
    end
end

--- @param listSelectedMember List
function GuildWarAreaLand:SetListSelectedMember(listSelectedMember)
    for i = 1, listSelectedMember:Count() do
        --- @type GuildWarPlayerInBound
        local member = listSelectedMember:Get(i)
        self:SetMemberBaseData(i, member)
    end
end

--- @param position number
--- @param guildWarPlayerInBound GuildWarPlayerInBound
function GuildWarAreaLand:SetMemberBaseData(position, guildWarPlayerInBound)
    --- @type GuildWarDefenseWorldBase
    local defenderWorldBase = self:GetDefenseBaseByPosition(position)
    if defenderWorldBase ~= nil then
        --- @type GuildWarEloPositionConfig
        local guildWarEloPositionConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig()
        local numberMedal = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig().numberMedal
        local elo = guildWarEloPositionConfig:GetEloByPosition(position)
        local healthPercent = guildWarPlayerInBound.medalHoldDefense / numberMedal
        defenderWorldBase:SetTowerState(self.isLeftSide, position, healthPercent)
        defenderWorldBase:SetMemberBaseData(position, guildWarPlayerInBound, guildWarPlayerInBound.medalHoldDefense * elo)
        defenderWorldBase:SetActive(true)
    end
end

function GuildWarAreaLand:OnSelectSlot(slotIndex)
    if self.triggerSelectSlot ~= nil then
        self.triggerSelectSlot(slotIndex)
    end
end

function GuildWarAreaLand:SetSwapAble()
    
end

--- @return GuildWarDefenseWorldBase
function GuildWarAreaLand:HighlightBaseByIndex(index)
    local highlightBase
    --- @param v GuildWarDefenseWorldBase
    for k, v in pairs(self.defenseBaseDict:GetItems()) do
        v:EnableHighlightArrow(k == index)
        if k == index then
            highlightBase = v
        end
    end
    return highlightBase
end

--- @return GuildWarDefenseWorldBase
function GuildWarAreaLand:DisableHighlight()
    --- @param v GuildWarDefenseWorldBase
    for k, v in pairs(self.defenseBaseDict:GetItems()) do
        v:EnableHighlightArrow(false)
    end
end

function GuildWarAreaLand:HideAllTower()
    --- @param v GuildWarDefenseWorldBase
    for k, v in pairs(self.defenseBaseDict:GetItems()) do
        v:SetActive(false)
    end
end