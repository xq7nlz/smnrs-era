--- @class UILoopScroll
UILoopScroll = Class(UILoopScroll)

UILoopScroll.defaultSpeed = 3000

--- @return void
--- @param scroll UnityEngine_UI_LoopScrollRect
--- @param uiPoolType UIPoolType
--- @param onCreateItem function HeroBaseIconView
function UILoopScroll:Ctor(scroll, uiPoolType, onCreateItem, onUpdateItem)
    --- @type UIPoolType
    self.uiPoolType = uiPoolType
    --- @type Dictionary
    self.dict = Dictionary()
    --- @type UnityEngine_UI_LoopScrollRect
    self.scroll = scroll
    --- @type function
    self.onCreateItem = onCreateItem
    --- @type function
    self.onUpdateItem = onUpdateItem
    --- @type nil
    self.motionCoroutine = nil
    --- @type MotionConfig
    self.motionConfig = nil

    self:_CreateScroll()
end

--- @param motionConfig MotionConfig
function UILoopScroll:SetUpMotion(motionConfig)
    self.motionConfig = motionConfig
end

--- @return void
function UILoopScroll:_CreateScroll()
    if self.scroll then
        self.scroll.onCreateItem = function(itemIndex, listIndex)
            --- @type IconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(self.uiPoolType, self.scroll.content)
            if itemIndex == 0 then
                iconView:SetAsFirstSibling()
            else
                iconView:SetAsLastSibling()
            end
            self.dict:Add(iconView:GetInstanceID(), iconView)

            if self.onCreateItem then
                iconView:DefaultShow()
                self.onCreateItem(iconView, listIndex)
            end
        end

        self.scroll.onUpdateItem = function(instanceId, listIndex)
            if self.dict:IsContainKey(instanceId) then
                local iconView = self.dict:Get(instanceId)
                if self.onUpdateItem then
                    iconView:DefaultShow()
                    self.onUpdateItem(iconView, listIndex)
                end
            else
                XDebug.Warning("Key is not exist: " .. instanceId)
            end
        end

        --- @param instanceId number
        self.scroll.onReturnItem = function(instanceId)
            if self.dict:IsContainKey(instanceId) then
                local iconView = self.dict:Get(instanceId)
                iconView:ReturnPool()
                self.dict:RemoveByKey(instanceId)
            else
                XDebug.Warning("Key is not exist: " .. instanceId)
            end
        end
    end
end

function UILoopScroll:GetItems()
    return self.dict:GetItems()
end

--- @return void
--- @param newSize number
function UILoopScroll:Resize(newSize, offset)
    self:SetSize(newSize)
    self.scroll:RefillCells(offset or 0)
end

--- @return void
--- @param newSize number
function UILoopScroll:SetSize(newSize)
    self.scroll.totalCount = newSize
end

--- @return void
--- @param newSize number
function UILoopScroll:RefreshCells(newSize)
    if newSize ~= nil then
        if self.scroll.totalCount > newSize
                and self.scroll.itemTypeStart ~= nil
                and self.scroll.itemTypeStart > 0 then
            self.scroll.itemTypeStart = math.max(self.scroll.itemTypeStart - (self.scroll.totalCount - newSize), 0)
        end
        self:SetSize(newSize)
    end
    self.scroll:RefreshCells()
end

--- @return void
--- @param newSize number
function UILoopScroll:GetOffsetVertical(newSize)
    if newSize ~= nil then
        return newSize * self.scroll.verticalNormalizedPosition
    else
        return self.scroll.totalCount * self.scroll.verticalNormalizedPosition
    end
end

--- @return void
--- @param newSize number
function UILoopScroll:GetOffsetHorizontal(newSize)
    if newSize ~= nil then
        return newSize * self.scroll.horizontalNormalizedPosition
    else
        return self.scroll.totalCount * self.scroll.horizontalNormalizedPosition
    end
end

--- @return void
--- @param index number
function UILoopScroll:ScrollToCell(index, speed)
    if index == nil or type(index) ~= "number" or index < 0 then
        XDebug.Error("index is out of range")
        return
    end
    speed = speed or UILoopScroll.defaultSpeed
    self.scroll:ScrollToCell(index, speed)
    --XDebug.Log("ScrollToCell" .. index)
end

--- @return void
--- @param index number
function UILoopScroll:ScrollToCellSnap(index, speed)
    if index == nil or type(index) ~= "number" or index < 0 then
        XDebug.Error("index is out of range")
        return
    end
    speed = speed or UILoopScroll.defaultSpeed
    self.scroll:ScrollToCellSnap(index, speed)
    --XDebug.Log("ScrollToCell" .. index)
end

--- @return void
function UILoopScroll:Hide()
    --- @param v IconView
    for _, v in pairs(self.dict:GetItems()) do
        v:ReturnPool()
    end
    self:SetSize(0)
    self.dict:Clear()
    ClientConfigUtils.KillCoroutine(self.motionCoroutine)
end

--- @return void
--- @param uiPoolType UIPoolType
function UILoopScroll:ChangePoolType(uiPoolType)
    if self.uiPoolType ~= uiPoolType then
        self:Hide()
        self.uiPoolType = uiPoolType
    end
end

function UILoopScroll:PlayMotion()
    if self.motionConfig == nil then
        return
    end
    local delay = self.motionConfig.delay
    local offsetSpawn = self.motionConfig.offsetSpawn
    local items = self:GetItems()
    local deltaTime = self.motionConfig.deltaTime
    ClientConfigUtils.KillCoroutine(self.motionCoroutine)
    self.motionCoroutine = Coroutine.start(function()
        local listItem = List()
        --- @param v IconView
        for _, v in pairs(items) do
            listItem:Add(v)
            v.uxMotion:SetAlpha(0)
        end
        listItem:SortWithMethod(UILoopScroll.SortItemByIndex)
        if delay > 0 then
            coroutine.waitforseconds(delay)
        end
        local count = listItem:Count()
        local spawnedIndex = 1
        local spawn = function()
            --- @type MotionIconView
            local iconView = listItem:Get(spawnedIndex)
            iconView:PlayMotion(true)
            spawnedIndex = spawnedIndex + 1
        end
        while count > offsetSpawn do
            for _ = 1, offsetSpawn do
                spawn()
            end
            count = count - offsetSpawn
            coroutine.waitforseconds(deltaTime)
        end
        for _ = 1, count do
            spawn()
        end
    end)
end

--- @param index number
function UILoopScroll:RefillCells(index)
    index = index or 0
    index = math.max(index, 0)
    self.scroll:RefillCells(index)
end

--- @param left UnityEngine_GameObject
--- @param right UnityEngine_GameObject
--- @param delta number
function UILoopScroll:SetArrowLeftRight(left, right, delta, count)
    if left ~= nil or right ~= nil then
        if delta == nil then
            delta = 0.1
        end
        ---@param v UnityEngine_Vector2
        local checkPos = function(v)
            if count == nil or self.scroll.totalCount > count then
                if left ~= nil then
                    left:SetActive(v.x > delta)
                end
                if right ~= nil then
                    right:SetActive(v.x < 1 - delta)
                end
            else
                left:SetActive(false)
                right:SetActive(false)
            end
        end
        Coroutine.start(function()
            coroutine.waitforendofframe()
            coroutine.waitforendofframe()

            checkPos(self.scroll.normalizedPosition)
        end)

        ---@param v UnityEngine_Vector2
        self.scroll.onValueChanged:AddListener(checkPos)
    end
end

--- @param x MotionIconView
--- @param y MotionIconView
function UILoopScroll.SortItemByIndex(x, y)
    if x.config.transform:GetSiblingIndex() < y.config.transform:GetSiblingIndex() then
        return -1
    end
    return 1
end