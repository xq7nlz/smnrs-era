require "lua.client.core.network.playerData.common.MarketItemInBound"

--- @class ModeShopDataInBound
ModeShopDataInBound = Class(ModeShopDataInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function ModeShopDataInBound:ReadBuffer(buffer)
    self.marketItemList = NetworkUtils.GetListDataInBound(buffer, MarketItemInBound.CreateByBuffer)
    self.level = buffer:GetByte()
end

function ModeShopDataInBound:GetNotification(marketConfig)
    self.config = marketConfig
    if marketConfig ~= nil then
        if self.level == marketConfig.maxLevel then
            self.isNoti = false
            return self.isNoti
        end
        local dataConfig = marketConfig:GetUpgradeMoneyList(self.level)
        for i = 1, dataConfig.listData:Count() do
            local current = InventoryUtils.GetMoney(dataConfig.listData:Get(i).moneyType)
            local requirement = dataConfig.listData:Get(i).moneyValue
            if current < requirement then
                --XDebug.Log(string.format("Not Enough Resource: %d/%d", current, requirement))
                self.isNoti = false
                return self.isNoti
            end
        end
        self.isNoti = true
        return self.isNoti
    else
        self.isNoti = false
        return self.isNoti
    end
end

function ModeShopDataInBound:GetNotificationInView()
    local marketConfig = self.config
    if marketConfig ~= nil then
        if self.level == marketConfig.maxLevel then
            self.isNoti = false
            return self.isNoti
        end
        local dataConfig = marketConfig:GetUpgradeMoneyList(self.level)
        for i = 1, dataConfig.listData:Count() do
            local current = InventoryUtils.GetMoney(dataConfig.listData:Get(i).moneyType)
            local requirement = dataConfig.listData:Get(i).moneyValue
            if current < requirement then
                --XDebug.Log(string.format("Not Enough Resource: %d/%d", current, requirement))
                self.isNoti = false
                return self.isNoti
            end
        end
        self.isNoti = true
        return self.isNoti
    else
        self.isNoti = false
        return self.isNoti
    end
end