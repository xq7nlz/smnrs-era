--- @class UILoopScrollAsync : UILoopScroll
UILoopScrollAsync = Class(UILoopScrollAsync, UILoopScroll)

--- @return void
--- @param scroll UnityEngine_UI_LoopScrollRect
--- @param uiPoolType UIPoolType
--- @param onCreateItem function HeroBaseIconView
function UILoopScrollAsync:Ctor(scroll, uiPoolType, onCreateItem, onUpdateItem)
    UILoopScroll.Ctor(self, scroll, uiPoolType, onCreateItem, onUpdateItem)
    self.canPlayMotion = false
end

--- @return void
function UILoopScrollAsync:_CreateScroll()
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

            if self.canPlayMotion == true then
                iconView.listIndex = listIndex
                iconView.config.gameObject:SetActive(false)
            else
                if self.onCreateItem then
                    iconView:DefaultShow()
                    self.onCreateItem(iconView, listIndex)
                end
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
                XDebug.Error("Key is not exist: " .. instanceId)
            end
        end

        --- @param instanceId number
        self.scroll.onReturnItem = function(instanceId)
            if self.dict:IsContainKey(instanceId) then
                local iconView = self.dict:Get(instanceId)
                iconView.listIndex = nil
                iconView:ReturnPool()
                self.dict:RemoveByKey(instanceId)
            else
                XDebug.Error("Key is not exist: " .. instanceId)
            end
        end
    end
end

--- @return void
---@param item ItemIconView
function UILoopScrollAsync:AddItemToLoadAsync(item)
    item.config.gameObject:SetActive(false)
    self.listPlayMotionItem:Add(item)
end

--- @return void
--- @param newSize number
--- @param canPlayMotion boolean
function UILoopScrollAsync:Resize(newSize, canPlayMotion)
    self.canPlayMotion = canPlayMotion
    self:ResetLoadAsync()
    UILoopScroll.Resize(self, newSize)
end

--- @return void
function UILoopScrollAsync:ResetLoadAsync()
    ClientConfigUtils.KillCoroutine(self.coroutineAsync)
    self.currentItem = nil
    self.lastItem = nil
end

--- @return void
function UILoopScrollAsync:Hide()
    self:SetSize(0)
    --- @param v IconView
    for _, v in pairs(self.dict:GetItems()) do
        local object = v.config.loadAsync
        if object ~= nil then
            object:SetActive(true)
        end
        v.listIndex = nil
        v:ReturnPool()
    end
    self.dict:Clear()
    ClientConfigUtils.KillCoroutine(self.motionCoroutine)
end

function UILoopScrollAsync:PlayMotion()
    if self.motionConfig == nil or self.canPlayMotion == false then
        return
    end
    self.canPlayMotion = false
    local items = self:GetItems()
    local delay = self.motionConfig.delay
    local offsetSpawn = self.motionConfig.offsetSpawn
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
        local spawnItemByIndex = function(index)
            --- @type MotionIconView
            local item = listItem:Get(index)
            if self.onCreateItem ~= nil and item.listIndex ~= nil then
                self.onCreateItem(item, item.listIndex)
            end
            item.config.gameObject:SetActive(true)
            item:PlayMotion(true)
            spawnedIndex = spawnedIndex + 1
        end
        while count > offsetSpawn do
            for _ = 1, offsetSpawn do
                spawnItemByIndex(spawnedIndex)
            end
            count = count - offsetSpawn
            coroutine.waitforseconds(deltaTime)
        end
        for _ = 1, count do
            spawnItemByIndex(spawnedIndex)
        end
    end)
end