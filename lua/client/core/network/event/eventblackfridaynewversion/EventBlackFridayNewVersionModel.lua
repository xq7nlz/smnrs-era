
--- @class EventBlackFridayNewVersionModel : EventPopupModel
EventBlackFridayNewVersionModel = Class(EventBlackFridayNewVersionModel, EventPopupModel)

function EventBlackFridayNewVersionModel:Ctor()
    --- @type List
    self.listCustomizePack = List()
    EventPopupModel.Ctor(self)
end

function EventBlackFridayNewVersionModel:ReadInnerData(buffer)
    require "lua.client.core.network.event.eventBlackFridayNewVersion.EventBlackFridayCustomizePackInBound"
    self.listCustomizePack = List()
    --- @type List
    self.listCustomizePack = NetworkUtils.GetListDataInBound(buffer, EventBlackFridayCustomizePackInBound.CreateByBuffer)
    --print("Buffer : " .. LogUtils.ToDetail(self.listCustomizePack:GetItems()))
end

--- @return EventBlackFridayCustomizePackInBound
--- @param customizePackId number
function EventBlackFridayNewVersionModel:GetCustomizePack(customizePackId)
    --- @param v EventBlackFridayCustomizePackInBound
    for _, v in pairs(self.listCustomizePack:GetItems()) do
        if v.packId == customizePackId then
            return v
        end
    end

    return nil
end

function EventBlackFridayNewVersionModel:UpdateListCustomizePack(newListCustomizePack)
    self.listCustomizePack = List()
    for i = 1, newListCustomizePack:Count() do
        self.listCustomizePack:Add(newListCustomizePack:Get(i))
    end
end

--- @param customizePackId number
function EventBlackFridayNewVersionModel:GetNumberOfBoughtCustomizePack(customizePackId)
    --- @param v EventBlackFridayCustomizePackInBound
    for _, v in pairs(self.listCustomizePack:GetItems()) do
        if v.packId == customizePackId then
            return v.numberOfBought
        end
    end
    return 0
end

--- @param packId number
function EventBlackFridayNewVersionModel:IncreaseNumberOfBoughtCustomizePack(packId)
    self:GetCustomizePack(packId):IncreaseNumberOfBought()
end

--- @class EventBlackFridayNewVersionTab
EventBlackFridayNewVersionTab = {
    SELECT_ITEM = 1,
    SUPER_DEAL = 2,
}
