--- @class PopupBuyItemData
PopupBuyItemData = Class(PopupBuyItemData)

--- @return void
function PopupBuyItemData:Ctor()
    ---@type ResourceType
    self.type = nil
    ---@type number
    self.id = nil
    ---@type number
    self.number = nil
    ---@type number
    self.minInput = nil
    ---@type number
    self.maxInput = nil
    ---@type MoneyType
    self.moneyType = nil
    ---@type number
    self.price = nil
    ---@type function
    self.callbackPurchase = nil
    ---@type string
    self.title = nil
    ---@type string
    self.textButton = nil
    --- @type boolean
    self.isSell = true
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
function PopupBuyItemData:SetData(type, id, number, minInput, maxInput, moneyType, price, callbackPurchase, title, textButton, isSell)
    self.type = type
    self.id = id
    self.number = number
    self.minInput = minInput
    self.maxInput = maxInput
    self.moneyType = moneyType
    self.price = price
    self.callbackPurchase = callbackPurchase
    self.title = title
    self.textButton = textButton
    self.isSell = isSell
end