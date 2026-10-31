require "lua.client.scene.ui.common.UIPrefabView"
require "lua.client.scene.ui.common.prefabHeroSlot.UIFormationButtonSlotView"

--- @class UIPrefabHeroSlotView : UIPrefabView
UIPrefabHeroSlotView = Class(UIPrefabHeroSlotView, UIPrefabView)

--- @return void
function UIPrefabHeroSlotView:Ctor()
    --- @type UnityEngine_RectTransform
    self.transform = nil
    --- @type List UIFormationButtonSlotView
    self.uiButtonSlotList = List()
    --- @type number
    self.numberSlot = 0
    --- @type number
    self.numberSlotFilled = 0
    --- @type UIBaseView
    self.holder = nil
    --- @type function
    self.removeSlotListener = nil
    --- @type function
    self.swapSlotListener = nil
    --- @type List<HeroResource>
    self.heroResourceList = nil
    --- @type boolean
    self.canDrag = nil
    --- @type function
    self.onSelectSlot = nil

    UIPrefabView.Ctor(self)

    self:_OnCreate()
end

--- @return void
function UIPrefabHeroSlotView:SetPrefabName()
    self.prefabName = 'prefab_hero_slot'
    self.uiPoolType = UIPoolType.UIPrefabHeroSlotView
end

--- @return void
function UIPrefabHeroSlotView:SetConfig(transform)
    self.config = {}
    self.config.transform = transform
    self.config.gameObject = transform.gameObject
end

--- @return void
function UIPrefabHeroSlotView:Show()
    UIPrefabTeamView.Show(self)
    self.canDrag = true
    self.heroResourceList = InventoryUtils.Get(ResourceType.Hero)
end

--- @return void
--- @param removeSlotListener function
--- @param swapSlotListener function
--- @param numberSlot number
function UIPrefabHeroSlotView:Init(numberSlot, removeSlotListener, swapSlotListener)
    self.removeSlotListener = removeSlotListener
    self.swapSlotListener = swapSlotListener
    self.numberSlot = numberSlot
end

--- @return boolean
function UIPrefabHeroSlotView:CanFillSlot()
    if self.numberSlot > self.numberSlotFilled then
        return true
    end
    return false
end

--- @return void
--- @param canDrag boolean
function UIPrefabHeroSlotView:SetCanDrag(canDrag)
    self.canDrag = canDrag
    --XDebug.Log("SetCan Drag: " .. tostring(self.canDrag))
end

--- @return void
--- @param heroIndex number
--- @param heroData HeroIconData
--- @param position UnityEngine_Vector3
function UIPrefabHeroSlotView:SpawnHeroIcon(heroIndex, heroData, position)
    self.numberSlotFilled = self.numberSlotFilled + 1

    --- @param slot UIFormationButtonSlotView
    for index, slot in ipairs(self.uiButtonSlotList:GetItems()) do
        if slot.iconView == nil then
            slot:SpawnHeroIcon(UIPoolType.HeroIconView, heroIndex, heroData, position)
            slot:SetOnSelectSlotCallback(self.onSelectSlot)
            return index
        end
    end
    assert(false, "Cant find a slot: something wrong here")
end

--- @return void
--- @param uiPoolType UIPoolType
--- @param heroIndex number
--- @param heroData HeroIconData
--- @param slotIndex number
function UIPrefabHeroSlotView:SpawnHeroIconAtIndex(uiPoolType, slotIndex, heroIndex, heroData, isShowHp)
    if slotIndex <= 0 or slotIndex > self.uiButtonSlotList:Count() then
        assert(false, string.format("Invalid value %d %d %s", slotIndex, heroIndex, LogUtils.ToDetail(heroData)))
    end
    self.numberSlotFilled = self.numberSlotFilled + 1
    --- @type UIFormationButtonSlotView
    local button = self.uiButtonSlotList:Get(slotIndex)
    button:SpawnHeroIcon(uiPoolType, heroIndex, heroData, nil, isShowHp)
    button:EnableRaycast(self.onSelectSlot ~= nil)
end

--- @return void
function UIPrefabHeroSlotView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self.numberSlotFilled = 0
    --- @param v UIFormationButtonSlotView
    for i, v in ipairs(self.uiButtonSlotList:GetItems()) do
        v:OnDisabled()
        v.config.rectTransform:SetParent(self.config.transform)
    end
end

--- @return void
function UIPrefabHeroSlotView:_OnCreate()
    --- @param innerSlot UIFormationButtonSlotView
    --- @param data UnityEngine_EventSystems_PointerEventData
    local onDrag = function(innerSlot, trigger, data)
        if self.canDrag == false then
            return
        end
        if innerSlot.iconView ~= nil then
            --- @type UnityEngine_Transform
            local slot = innerSlot.iconView.config.transform
            local point = uiCanvas.camUI:ScreenToWorldPoint(U_Vector3(data.position.x, data.position.y, uiCanvas.camUI.nearClipPlane))
            if slot ~= nil then
                if innerSlot.deltaPos == nil then
                    innerSlot.deltaPos = U_Vector2.zero--U_Vector2(slot.position.x - point.x, slot.position.y - point.y)
                end

                slot.transform:SetParent(uiCanvas.config.uiPopup)
                slot.position = U_Vector3(point.x + innerSlot.deltaPos.x,
                        point.y + innerSlot.deltaPos.y,
                        trigger.transform.position.z)
            end
        end
    end

    --- @param innerSlot UIFormationButtonSlotView
    --- @param data UnityEngine_EventSystems_PointerEventData
    local onMouseUp = function(innerSlot, trigger, data)
        if self.canDrag == false then
            return
        end

        assert(innerSlot and trigger and data)
        if innerSlot.iconView ~= nil then
            local innerTransform = innerSlot.iconView.config.transform
            local obj = data.pointerCurrentRaycast.gameObject
            if obj and obj:CompareTag("hero_slot") then
                local index = tonumber(obj.name)
                if index ~= innerSlot.index then
                    self:_SwapSlot(innerSlot, self.uiButtonSlotList:Get(index))
                    if self.swapSlotListener ~= nil then
                        self.swapSlotListener()
                    end
                    return
                end
            end

            innerTransform:SetParent(trigger.transform)
            innerTransform.localPosition = U_Vector3.zero
        end
    end

    for i = 0, self.config.transform.childCount - 1 do
        --- @type UnityEngine_Transform
        local child = self.config.transform:GetChild(i)
        --- @type UIFormationButtonSlotView
        local innerSlot = UIFormationButtonSlotView(child, i + 1)
        --- @type UnityEngine_EventSystems_EventTrigger
        local trigger = child.gameObject:GetComponent(ComponentName.UnityEngine_EventSystems_EventTrigger)

        --- calculate and drag slot hero
        --- @type UnityEngine_EventSystems_EventTrigger_Entry
        local entryDrag = U_EventSystems.EventTrigger.Entry()
        entryDrag.eventID = U_EventSystems.EventTriggerType.Drag
        entryDrag.callback:AddListener(function(data)
            onDrag(innerSlot, trigger, data)
        end)
        trigger.triggers:Add(entryDrag)

        --- @type UnityEngine_EventSystems_EventTrigger_Entry
        local entryPointUp = U_EventSystems.EventTrigger.Entry()
        entryPointUp.eventID = U_EventSystems.EventTriggerType.PointerUp
        entryPointUp.callback:AddListener(function(data)
            onMouseUp(innerSlot, trigger, data)
        end)
        trigger.triggers:Add(entryPointUp)

        innerSlot:EnableRaycast(self.onSelectSlot ~= nil)
        innerSlot.config.button.onClick:AddListener(function()
            if innerSlot.iconView ~= nil then
                self.numberSlotFilled = self.numberSlotFilled - 1
                if self.removeSlotListener ~= nil then
                    self.removeSlotListener(innerSlot)
                end
                if self.onSelectSlot ~= nil then
                    self.onSelectSlot(self.uiButtonSlotList:Count() - innerSlot.index + 1)
                end
            end
        end)

        self.uiButtonSlotList:Add(innerSlot)
    end
end

--- @return Dictionary -- <slot,heroIndex>
function UIPrefabHeroSlotView:GetHeroIndexDict()
    local dict = Dictionary()
    --- @param v UIFormationButtonSlotView
    for i, v in ipairs(self.uiButtonSlotList:GetItems()) do
        if v.heroIndex ~= nil then
            dict:Add(i, v.heroIndex)
        end
    end
    return dict
end

--- @return List -- <heroIndex>
function UIPrefabHeroSlotView:GetHeroIndexList()
    local list = List()
    --- @param v UIFormationButtonSlotView
    for i, v in ipairs(self.uiButtonSlotList:GetItems()) do
        if v.heroIndex ~= nil then
            list:Add(v.heroIndex)
        end
    end
    return list
end

--- @return Dictionary -- <slot,heroIndex>
function UIPrefabHeroSlotView:GetHeroIdDict()
    local dict = Dictionary()
    --- @param v UIFormationButtonSlotView
    for i, v in ipairs(self.uiButtonSlotList:GetItems()) do
        if v.heroIndex ~= nil then
            dict:Add(i, v.iconView.iconData.heroId)
        end
    end
    return dict
end

--- @return number
--- @param index Number
function UIPrefabHeroSlotView:GetButtonPosX(index)
    assert(index > 0 and index <= self.uiButtonSlotList:Count())
    return self.uiButtonSlotList:Get(index).config.rectTransform.position.x
end

--- @return number
--- @param index Number
function UIPrefabHeroSlotView:GetButtonLocalPosX(index)
    assert(index > 0 and index <= self.uiButtonSlotList:Count())
    return self.uiButtonSlotList:Get(index).config.rectTransform.localPosition.x
end

--- @return void
--- @param slot1 UIFormationButtonSlotView
--- @param slot2 UIFormationButtonSlotView
function UIPrefabHeroSlotView:_SwapSlot(slot1, slot2)
    --- @type UIFormationButtonSlotView
    local swapSlot = slot1.iconView
    --- @type number
    local swapIndex = slot1.heroIndex
    slot1.iconView = slot2.iconView
    slot1.heroIndex = slot2.heroIndex
    slot2.iconView = swapSlot
    slot2.heroIndex = swapIndex
    slot1:_ResetPosHeroInfo()
    slot2:_ResetPosHeroInfo()
end

return UIPrefabHeroSlotView