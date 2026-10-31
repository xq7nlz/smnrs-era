--- @class PopupBuyItemRaidData
PopupBuyItemRaidData = Class(PopupBuyItemRaidData)

--- @return void
function PopupBuyItemRaidData:Ctor()
    ---@type ResourceType
    self.type = nil
    ---@type number
    self.id = nil
    ---@type number
    self.maxCountBuyTurn = nil
    ---@type number
    self.maxCountAdsTurn = nil
    ---@type number
    self.turnBuyDailyVip = nil
    ---@type number
    self.turnAdsDailyVip = nil
    ---@type MoneyType
    self.moneyType = nil
    ---@type number
    self.price = nil
    ---@type function
    self.callbackPurchase = nil
    --- @type boolean
    self.isSell = true
    ---@type RaidModeType
    self.raidModeType = nil
end

--- @return void
---@param type ResourceType
---@param id number
---@param number number
---@param minInput number
---@param maxInput number
---@param moneyType MoneyType
---@param price number
---@param callbackPurchase function
---@param title string
---@param textButton string
--- @param isSell boolean
function PopupBuyItemRaidData:SetData(type, id, maxCountBuyTurn, maxCountAdsTurn, turnBuyDailyVip, turnAdsDailyVip, moneyType, price, callbackPurchase, isSell, raidModeType)
    self.type = type
    self.id = id
    self.maxCountBuyTurn = maxCountBuyTurn
    self.maxCountAdsTurn = maxCountAdsTurn
    self.turnBuyDailyVip = turnBuyDailyVip
    self.turnAdsDailyVip = turnAdsDailyVip
    self.moneyType = moneyType
    self.price = price
    self.callbackPurchase = callbackPurchase
    self.isSell = isSell
    self.raidModeType = raidModeType
end