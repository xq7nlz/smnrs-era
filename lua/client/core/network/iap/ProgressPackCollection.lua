--- @class ProgressPackCollection
ProgressPackCollection = Class(ProgressPackCollection)

function ProgressPackCollection:Ctor()
    --- @type Dictionary
    self.activeProgressPackDict = Dictionary()
    --- @type Dictionary
    self.boughtPackDict = Dictionary()
    --- @type Dictionary
    self.starterPackItemSelectDict = Dictionary()

    self.starterPackId = 0;
end

function ProgressPackCollection:SetItemSelect(packId,listId)
--[[    if (self.starterPackItemSelectDict == nil) then

    end]]
    self.starterPackId= packId
    self.starterPackItemSelectDict = Dictionary()
    self.starterPackItemSelectDict:Add(packId,listId)
end

function ProgressPackCollection:HasPackNotChoose()
    if self.starterPackItemSelectDict:IsContainKey(self.starterPackId) then
        --- @type List
        local listSelectedItem = self.starterPackItemSelectDict:Get(self.starterPackId)
        for i = 1, listSelectedItem:Count() do
            if (listSelectedItem:Get(i) <= 0) then
                return true
            end
        end
        return false
    else
        return true
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function ProgressPackCollection:ReadBuffer(buffer)
    self.activeProgressPackDict = Dictionary()
    --- @type number
    local size = buffer:GetByte()
    --XDebug.Log(" size " .. tostring(size))
    for _ = 1, size do
        local groupId = buffer:GetInt()
        local createdTime = buffer:GetLong()
        --XDebug.Log("ADD " .. tostring(groupId) .. "time " .. tostring(createdTime))
        self.activeProgressPackDict:Add(groupId, createdTime)
    end

    self.boughtPackDict = Dictionary()
    --- @type number
    size = buffer:GetByte()
    for _ = 1, size do
        local packId = buffer:GetInt()
        local numberBought = buffer:GetInt()
        self.boughtPackDict:Add(packId, numberBought)
    end

    self.starterPackItemSelectDict = Dictionary()
    size = buffer:GetByte()
    --XDebug.Log("SIZE DICT SELECT " .. tostring(size))
    if (size > 0) then
        for _ = 1, size do
            self.starterPackId = buffer:GetInt()
            local sizeOfListItemSelect = buffer:GetByte()
            if (sizeOfListItemSelect > 0) then
                local listItemSelect = Dictionary()
                for k = 1, sizeOfListItemSelect do
                    local slot = buffer:GetInt()
                    local id = buffer:GetInt()
                    listItemSelect:Add(slot, id)
                    --XDebug.Log("add id select " .. tostring(id))
                end
                self.starterPackItemSelectDict:Add(self.starterPackId, listItemSelect)
            end
        end
    end
end

--- @return number
--- @param packId number
function ProgressPackCollection:GetBoughtCount(packId)
    if self.boughtPackDict:IsContainKey(packId) then
        return self.boughtPackDict:Get(packId)
    end
    return 0
end

--- @param packId number
function ProgressPackCollection:IncreaseBoughtPack(packId)
    local bought = self:GetBoughtCount(packId)
    self.boughtPackDict:Add(packId, bought + 1)
end

--- @return List | GroupProductConfig
function ProgressPackCollection:GetActiveGroupListFlashSale()
    local activeList = List()
    --- @type ProgressGroupPackOfProducts
    local iapConfig = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPack(OpCode.PURCHASE_PROGRESS_PACK)
    for groupId, createdTime in pairs(self.activeProgressPackDict:GetItems()) do
        ---@type GroupProductConfig
        local group = iapConfig:GetGroup(groupId)
        if group ~= nil and group:IsActiveByDuration(createdTime) and group.viewType == PackViewType.FLASH_SALE_PACK then
            activeList:Add(group)
        end
    end
    activeList:SortWithMethod(GroupProductConfig.SortByPriority)
    return activeList
end

--- @return List | GroupProductConfig
function ProgressPackCollection:GetActiveGroupListNewFlashSale()
    local activeList = List()
    --- @type ProgressGroupPackOfProducts
    local iapConfig = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPack(OpCode.PURCHASE_PROGRESS_PACK)
    for groupId, createdTime in pairs(self.activeProgressPackDict:GetItems()) do
        ---@type GroupProductConfig
        local group = iapConfig:GetGroup(groupId)
        if group ~= nil and group:IsActiveByDuration(createdTime) and group.viewType == PackViewType.FLASH_SALE_NEW then
            activeList:Add(group)
        end
    end
    activeList:SortWithMethod(GroupProductConfig.SortByPriority)
    return activeList
end

--- @return List | GroupProductConfig
function ProgressPackCollection:GetActiveGroupList()
    local activeList = List()
    --- @type ProgressGroupPackOfProducts
    local iapConfig = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPack(OpCode.PURCHASE_PROGRESS_PACK)
    for groupId, createdTime in pairs(self.activeProgressPackDict:GetItems()) do
        ---@type GroupProductConfig
        local group = iapConfig:GetGroup(groupId)
        if group ~= nil and group:IsActiveByDuration(createdTime) then
            activeList:Add(group)
        end
    end
    activeList:SortWithMethod(GroupProductConfig.SortByPriority)
    return activeList
end

--- @return List | GroupProductConfig
--- @param packViewType PackViewType
function ProgressPackCollection:GetListActiveGroupByViewType(packViewType)
    local activeList = self:GetActiveGroupList()
    for i = activeList:Count(), 1, -1 do
        --- @type GroupProductConfig
        local groupProductConfig = activeList:Get(i)
        if groupProductConfig.viewType ~= packViewType then
            activeList:RemoveByIndex(i)
        end
    end
    return activeList
end