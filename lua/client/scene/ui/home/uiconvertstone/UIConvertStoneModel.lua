--- @class UIConvertStoneModel : UIBaseModel
UIConvertStoneModel = Class(UIConvertStoneModel, UIBaseModel)

--- @return void
function UIConvertStoneModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIConvertStone, "convert_stone")
    ---@type HeroResource
    self.heroResource = nil
    self.stoneId = nil
    self.convert = nil
    ---@type StoneCostConfig
    self.stoneCostConfig = nil
    ---@type StoneDataConfig
    self.stoneData = nil

    self.rewardList = List()

    self.bgDark = true
end

--- @return boolean
function UIConvertStoneModel:UseResourceConvert()
    self:UpdateReward()
    local canUpgrade = InventoryUtils.IsEnoughMultiResourceRequirement(self.rewardList, true)
    if canUpgrade then
        InventoryUtils.Sub(ResourceType.Money, MoneyType.GOLD, self.stoneCostConfig.convertGold)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.STONE_DUST, self.stoneCostConfig.convertDust)
        return true
    end
end

function UIConvertStoneModel:UpdateReward()
    self.rewardList:Clear()
    self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GOLD, self.stoneCostConfig.convertGold))
    self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.STONE_DUST, self.stoneCostConfig.convertDust))
end