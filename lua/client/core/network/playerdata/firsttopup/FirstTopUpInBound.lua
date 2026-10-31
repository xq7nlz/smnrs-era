--- @class FirstTopUpInBound
function FirstTopUpInBound:Ctor(buffer)
    ---@type boolean
    self.alreadyChosen = false
    ---@type number
    self.packageNumber = -1
    ---@type boolean
    self.alreadyPurchase = false
end