--- @class EventIdleEffectModel : EventPopupModel
EventIdleEffectModel = Class(EventIdleEffectModel, EventPopupModel)
--- @param buffer UnifiedNetwork_ByteBuf
function EventIdleEffectModel:ReadInnerData(buffer)
    self.numberBuyDataDict = Dictionary()
    ---@type Dictionary
    self.packSelectedItemDict = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        local packId = buffer:GetShort()
        local numberOfBought = buffer:GetShort()
        self.numberBuyDataDict:Add(packId, numberOfBought)
    end
    local size2 = buffer:GetByte()
    for i = 1, size2 do
        local packId = buffer:GetInt()
        local size3 = buffer:GetByte()
        local listItemSelect = List()
        for i = 1, size3 do
            listItemSelect:Add(buffer:GetInt())
        end
        self.packSelectedItemDict:Add(packId,listItemSelect)
    end
end

function EventIdleEffectModel:GetSelectItemID(packId)
    local listSelectId = self.packSelectedItemDict:Get(self.packId)
    if (listSelectId == nil or listSelectId:Count() == 0) then
        return nil
    end
    return listSelectId:Get(1)
end

function EventIdleEffectModel:HasPackNotChosen()
    --- @type List
    local listPack = ResourceMgr.GetPurchaseConfig():GetIdleEffectBundle():GetPack(self.timeData.dataId).packList
    for i = 1, listPack:Count() do
        ---@type EventIdleEffectProduct
        local pack = listPack:Get(i)
        if (pack.numberSelect > 0) then
            local selected = self.packSelectedItemDict:IsContainKey(pack.id)
            if (not selected) then
                return true
            end
        end
    end
    return false
end

function EventIdleEffectModel:AddNumberBuy(packId,count)
    ---@type NumberBuyData
    local numberBuyData = self:GetNumberBuy(packId)
    self.numberBuyDataDict:Add(packId, numberBuyData + count)
end

---@return number
function EventIdleEffectModel:GetNumberBuy(packId)
    if (self.numberBuyDataDict:IsContainKey(packId)) then
        return tonumber(self.numberBuyDataDict:Get(packId))
        else
        return 0
    end
end

function EventIdleEffectModel:AddSelectItem(packId,listItemSelect)
    self.packSelectedItemDict:Add(packId, listItemSelect)
end

--- @return EventNewServerWeekConfig
function EventIdleEffectModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end