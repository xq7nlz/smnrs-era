--- @class RootItemsTableView
RootItemsTableView = Class(RootItemsTableView)

--- @return void
--- @param uiTransform UnityEngine_Transform
--- @param onInitItem function
--- @param uiPoolType UIPoolType
function RootItemsTableView:Ctor(uiTransform, onInitItem, uiPoolType)
    assert(uiTransform)
    self.uiTransform = uiTransform
    --- @type List --<ItemIconData>
    self.resourceList = nil
    --- @type List --<SelectRewardData>
    self.selectRewardDataList = nil
    --- @type function
    self.onInitItem = onInitItem
    --- @type UIPoolType
    self.uiPoolType = uiPoolType
    --- @type List IconView
    self.iconViewList = List()
end

--- @return void
--- @param resourceList List -- <ItemIconData>
--- @param uiPoolType UIPoolType
--- @param selectRewardDataList List --<SelectRewardData>
function RootItemsTableView:SetData(resourceList, uiPoolType, selectRewardDataList)
    self.uiPoolType = uiPoolType or self.uiPoolType
    --for i = 1, resourceList:Count() do
    --    local iconData = resourceList:Get(i)
    --    XDebug.Log("iconData before OnDisabled" .. LogUtils.ToDetail(iconData))
    --end
    self:Hide()
    self.resourceList = resourceList
    self.selectRewardDataList = selectRewardDataList
    --for i = 1, self.resourceList:Count() do
    --    local iconData = self.resourceList:Get(i)
    --    XDebug.Log("iconData after OnDisabled" .. LogUtils.ToDetail(iconData))
    --end
    self:Show()
    self:SetSize(165, 165)
end

--- @return List
function RootItemsTableView:GetItems()
    return self.iconViewList
end

function RootItemsTableView:IsChosenItem(isCustomChosenPack)
    if (isCustomChosenPack == true ) then
        ---@type SelectRewardData
        local selectRewardData = self.selectRewardDataList:Get(i)
        return selectRewardData ~= nil and selectRewardData.isSelectionReward == true
    end
    return false
end

--- @return void
function RootItemsTableView:Show()
    --- init item
    if self.resourceList ~= nil then
        local iconViewDict = {}
        local iconDataDict = {}
        local isCustomChosenPack = self.selectRewardDataList ~= nil -- for custom chosen pack
        ---@type SelectRewardData
        local selectRewardData = nil
        for i = 1, self.resourceList:Count() do
            local isChosenItem = self:IsChosenItem(isCustomChosenPack) -- for custom chosen pack
            ---@type HeroIconData
            local iconData = self.resourceList:Get(i)
            --- @type HeroIconView
            local iconView
            if self.uiPoolType == nil then
                iconView = SmartPoolUtils.GetIconViewByIconData(iconData, self.uiTransform)
                if iconViewDict[iconView] == nil then
                    iconViewDict[iconView] = iconView
                else
                    XDebug.Error("Error Pool BUG item table view iconViewDict")
                end

                if iconDataDict[iconData] == nil then
                    iconDataDict[iconData] = iconData
                else
                    XDebug.Error("Error Pool BUG item table view iconDataDict")
                end
            else
                iconView = SmartPool.Instance:SpawnLuaUIPool(self.uiPoolType, self.uiTransform)
                if (isChosenItem) then -- for custom chosen pack
                    ---@type SelectRewardData
                    local selectRewardData = self.selectRewardDataList:Get(i)
                    local showPlusNoti = selectRewardData:ShowPlusNoti()
                    iconView:ActiveUIPool(UIPoolType.Plus, showPlusNoti)
                    iconView:ActiveUIPool(UIPoolType.Noti, showPlusNoti)
                    iconView:ActiveUIPool(UIPoolType.Change,selectRewardData:ShowChangeIcon())
                    iconView:RemoveAllListeners() -- root icon view should have custom listener
                    iconView:AddListener(function()
                        selectRewardData.callbackClick()
                    end)
                else

                end
                iconView:SetIconData(iconData)
            end
            if (not isChosenItem) then
                iconView:RegisterShowInfo()
            end
            iconView:DefaultShow()

            self.iconViewList:Add(iconView)

            if self.onInitItem ~= nil then
                self.onInitItem(iconView,i)
            end
        end
    end
end

--- @return void
function RootItemsTableView:Hide()
    --- @param iconView IconView
    for _, iconView in ipairs(self.iconViewList:GetItems()) do
        iconView:ReturnPool()
    end
    self.resourceList = nil
    self.selectRewardDataList = nil
    self.iconViewList:Clear()
    ClientConfigUtils.KillCoroutine(self.motionCoroutine)
end

--- @return void
function RootItemsTableView:ReturnPool()
    XDebug.Log("Use self:Hide() instead")
    self:Hide()
end

--- @return IconView
--- @param index number
function RootItemsTableView:Get(index)
    return self.iconViewList:Get(index)
end

--- @param isActive boolean
--- @param size UnityEngine_Vector2
function RootItemsTableView:ActiveMaskSelect(isActive, size)
    --- @param iconView IconView
    for _, iconView in ipairs(self.iconViewList:GetItems()) do
        iconView:ActiveMaskSelect(isActive, size)
    end
end

function RootItemsTableView:SetSize(x, y)
    --- @param iconView IconView
    for _, iconView in ipairs(self.iconViewList:GetItems()) do
        iconView:SetSize(x, y)
    end
end

--- @param motionConfig MotionConfig
function RootItemsTableView:PlayMotion(motionConfig)
    if motionConfig == nil then
        return
    end
    local delay = motionConfig.delay
    local listItems = self:GetItems()
    local deltaTime = motionConfig.deltaTime
    local offsetSpawn = motionConfig.offsetSpawn
    ClientConfigUtils.KillCoroutine(self.motionCoroutine)
    self.motionCoroutine = Coroutine.start(function()
        for i = 1, listItems:Count() do
            listItems:Get(i):SetAlpha(0)
        end
        if delay > 0 then
            coroutine.waitforseconds(delay)
        end
        --for i = 1, listItems:Count() do
        --    listItems:Get(i):PlayMotion(true)
        --    coroutine.waitforseconds(deltaTime)
        --end

        local count = listItems:Count()
        local spawnedIndex = 1
        local spawn = function()
            --- @type MotionIconView
            local iconView = listItems:Get(spawnedIndex)
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



