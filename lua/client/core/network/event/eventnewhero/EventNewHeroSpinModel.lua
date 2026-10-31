--- @class EventNewHeroSpinModel : EventPopupModel
EventNewHeroSpinModel = Class(EventNewHeroSpinModel, EventPopupModel)

function EventNewHeroSpinModel:Ctor()
    --- @type number
    self.completedFloor = nil
    --- @type List
    self.openedSlots = nil
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroSpinModel:ReadInnerData(buffer)
    self.completedFloor = buffer:GetByte()
    local size = buffer:GetByte()
    self.openedSlots = List()
    for i = 1, size do
        self.openedSlots:Add(buffer:GetInt())
    end
end

function EventNewHeroSpinModel:HasNotification()
    ---@type Dictionary
    local dict = self:GetConfig():GetCostConfig()
    if self.openedSlots:Count() < dict:Count() then
        ---@type EventNewHeroSpinCost
        local cost = dict:Get(math.min(self.openedSlots:Count() + 1, dict:Count()))
        return InventoryUtils.Get(ResourceType.Money, cost.moneyType) >= cost.moneyValue
    else
        return false
    end
end