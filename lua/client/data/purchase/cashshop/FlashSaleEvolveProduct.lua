--- @class FlashSaleEvolveProduct : ProductConfig
FlashSaleEvolveProduct = Class(FlashSaleEvolveProduct, ProductConfig)

function FlashSaleEvolveProduct:Ctor()
    ProductConfig.Ctor(self)
    self.opCode = OpCode.PURCHASE_FLASH_SALE_EVOLVE_PACK
    self.heroId = nil
end

---@param rewardInBound RewardInBound
function FlashSaleEvolveProduct:AddRewardToProduct(rewardInBound)
    self.bonusRewardList = List()
    self.heroId = rewardInBound.id
    self.bonusRewardList:Add(rewardInBound)
end

---@param rewardInBound RewardInBound
function FlashSaleEvolveProduct:RemoveRewardFromProduct(rewardInBound)
    ---@param v RewardInBound
    for _, v in pairs(self.rewardList:GetItems()) do
        if v.id == rewardInBound.id then
            self.rewardList:RemoveByReference(v)
        end
    end
end

function FlashSaleEvolveProduct:ClaimAndShowRewardList()
    ---@type List <RewardInBound>
    local rewardList = List()
    for _, v in ipairs(self.rewardList:GetItems()) do
        rewardList:Add(v)
    end
    PopupUtils.ClaimAndShowRewardList(rewardList)
    self.bonusRewardList:Clear()
end

--- @return void
function FlashSaleEvolveProduct:ParseCsv(data)
    if data.id then
        self.id = data.id
        ProductConfig.ParseCsv(self, data)
    end
    ---@type RewardInBound
    local rewardInBound = RewardInBound.CreateByParams(data)
    if (rewardInBound.id ~= nil) then
        self.rewardList:Add(rewardInBound)
    end
end