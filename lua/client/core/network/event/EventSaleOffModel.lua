--- @class EventSaleOffModel : EventPopupModel
EventSaleOffModel = Class(EventSaleOffModel, EventPopupModel)

function EventSaleOffModel:Ctor()
    --- @type List
    self.listPurchasePackInBound = List()
    EventPopupModel.Ctor(self)
    ---@type function
    self.onUpdateCallback = nil

    ---@type function
    self.updateTime = nil
    ---@type number
    self.timeRefresh = nil

    self:InitUpdateTime()
end

function EventSaleOffModel:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self.timeRefresh < 0 then
            self:RemoveUpdateTime()
        end
        if self.onUpdateCallback ~= nil then
            self.onUpdateCallback(self.timeRefresh)
        end
    end
end

function EventSaleOffModel:SetTimeRefresh()
    self.timeRefresh = self.timeData.endTime - zg.timeMgr:GetServerTime()
end

function EventSaleOffModel:StartRefreshTime(updateCallback)
    self.onUpdateCallback = updateCallback
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function EventSaleOffModel:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventSaleOffModel:ReadInnerData(buffer)
    self.listPurchasePackInBound = NetworkUtils.GetListDataInBound(buffer, PurchasedPackInBound.CreateByBuffer)
end

--- @return PurchasedPackInBound
function EventSaleOffModel:FindPurchasePackById(packId)
    if self.listPurchasePackInBound == nil or self.listPurchasePackInBound:Count() == 0 then
        return nil
    end
    for i = 1, self.listPurchasePackInBound:Count() do
        --- @type PurchasedPackInBound
        local purchasedPackInBound = self.listPurchasePackInBound:Get(i)
        if purchasedPackInBound.packId == packId then
            return purchasedPackInBound
        end
    end
    return nil
end

--- @param packId number
function EventSaleOffModel:OnBuySalePackSuccess(packId)
    local purchasedPackInBound = self:FindPurchasePackById(packId)
    if purchasedPackInBound ~= nil then
        purchasedPackInBound.numberOfBought = purchasedPackInBound.numberOfBought + 1
    else
        purchasedPackInBound = PurchasedPackInBound()
        purchasedPackInBound.packId = packId
        purchasedPackInBound.numberOfBought = 1
        self.listPurchasePackInBound:Add(purchasedPackInBound)
    end
end

--- @return PackOfSaleProducts
function EventSaleOffModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end