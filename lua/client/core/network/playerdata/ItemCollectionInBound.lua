--- @class ItemCollectionInBound : BaseJsonInBound
ItemCollectionInBound = Class(ItemCollectionInBound, BaseJsonInBound)

--- @return void
function ItemCollectionInBound:Ctor()
    BaseJsonInBound.Ctor(self)
    ---@type Dictionary
    self.stoneConvertDict = Dictionary()
    ---@type Dictionary
    self.refreshTalentDict = Dictionary()
    --- @type boolean
    self.needRequestItemCollection = nil
end

--- @return void
function ItemCollectionInBound:InitDatabase()
    local jsonDatabase = json.decode(self.jsonData)
    local inventoryData = zg.playerData:GetInventoryData()
    inventoryData:Get(ResourceType.ItemEquip):InitDatabase(jsonDatabase['0'])
    inventoryData:Get(ResourceType.ItemArtifact):InitDatabase(jsonDatabase['1'])
    inventoryData:Get(ResourceType.ItemFragment):InitDatabase(jsonDatabase['2'])
    inventoryData:Get(ResourceType.Skin):InitDatabase(jsonDatabase['3'])
    inventoryData:Get(ResourceType.SkinFragment):InitDatabase(jsonDatabase['4'])

    --- @type ClientResourceAvatar
    local clientResourceAvatar = inventoryData:Get(ResourceType.Avatar)
    clientResourceAvatar:InitDatabase(jsonDatabase['5'])

    inventoryData:Get(ResourceType.AvatarFrame):InitDatabase(jsonDatabase['6'])
    self:InitDatabaseStoneConvert(jsonDatabase['7'])
    self:InitDatabaseRefreshTalent(jsonDatabase['8'])
    inventoryData:Get(ResourceType.IDLE_EFFECT):InitDatabase(jsonDatabase['9']) -- list effect da co nhung chua dung
    self.needRequestItemCollection = false
end

--- @return void
--- @param data table
function ItemCollectionInBound:InitDatabaseStoneConvert(data)
    if data ~= nil then
        self.stoneConvertDict:Clear()
        for heroInventoryId, stoneId in pairs(data) do
            self.stoneConvertDict:Add(tonumber(heroInventoryId), tonumber(stoneId))
        end
    end
end

--- @return void
--- @param data table
function ItemCollectionInBound:InitDatabaseRefreshTalent(data)
    if data ~= nil then
        self.refreshTalentDict:Clear()
        for heroInventoryId, dict in pairs(data) do
            self.refreshTalentDict:Add(tonumber(heroInventoryId), dict["0"])
        end
    end
end

--- @return void
--- @param heroInventoryId number
function ItemCollectionInBound:IsConvertingStone(heroInventoryId)
    return self.stoneConvertDict:IsContainKey(heroInventoryId)
end

--- @return void
--- @param heroInventoryId number
function ItemCollectionInBound:GetConvertingStone(heroInventoryId)
    return self.stoneConvertDict:Get(heroInventoryId)
end

--- @return void
--- @param heroInventoryId number
---@param stoneId number
function ItemCollectionInBound:SetConvertingStone(heroInventoryId, stoneId)
    return self.stoneConvertDict:Add(heroInventoryId, stoneId)
end

--- @return void
--- @param heroInventoryId number
function ItemCollectionInBound:RemoveConvertingStone(heroInventoryId)
    return self.stoneConvertDict:RemoveByKey(heroInventoryId)
end

--- @return void
--- @param heroInventoryId number
function ItemCollectionInBound:GetNumberRefreshTalent(heroInventoryId, slot)
    local dictSlot = self.refreshTalentDict:Get(heroInventoryId)
    if dictSlot ~= nil then
        return dictSlot[tostring(slot)] or 0
    end
    return 0
end

--- @return void
--- @param heroInventoryId number
function ItemCollectionInBound:AddNumberRefreshTalent(heroInventoryId, slot)
    local dictSlot = self.refreshTalentDict:Get(heroInventoryId)
    if dictSlot == nil then
        dictSlot = {}
        self.refreshTalentDict:Add(heroInventoryId, dictSlot)
    end
    dictSlot[tostring(slot)] = self:GetNumberRefreshTalent(heroInventoryId, slot) + 1
end