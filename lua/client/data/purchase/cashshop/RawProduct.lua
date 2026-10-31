--- @class RawProduct : ProductConfig
RawProduct = Class(RawProduct, ProductConfig)

function RawProduct:Ctor()
    ProductConfig.Ctor(self)
    self.opCode = OpCode.PURCHASE_RAW_PACK
end

--- @return void
function RawProduct:ParseCsv(data)
    if data.id ~= nil then
        ProductConfig.ParseCsv(self, data)
        if data['bonus_res_type'] ~= nil then
            self.bonusReward = RewardInBound.CreateBySingleParam(data['bonus_res_type'], data['bonus_res_id'], data['bonus_res_number'], data['bonus_res_data'])
        end
    end
    self.rewardList:Add(RewardInBound.CreateByParams(data))
end

--- return boolean
function RawProduct:HasBought()
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetIAP()
    local number = iapDataInBound:GetNumberOfBoughtRawPack(self.id)
    --XDebug.Log(string.format("id = %d Number Raw Bought: %d", self.id, number))
    return number > 0
end

function RawProduct:IncreaseBought()
    zg.playerData:GetMethod(PlayerDataMethod.IAP):IncreaseNumberOfBoughtRawPack(self.id)
end

function RawProduct:ClaimAndShowRewardList()
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetIAP()
    local number = iapDataInBound:GetNumberOfBoughtRawPack(self.id)
    local hasBought = number > 1

    ---@type List -- RewardInBound
    local rewardList = List()
    --- @param reward RewardInBound
    for _, reward in ipairs(self.rewardList:GetItems()) do
        local rewardClone = RewardInBound.Clone(reward)
        rewardList:Add(rewardClone)
    end

    if self.bonusReward ~= nil and hasBought == false then
        rewardList:Add(self.bonusReward)
    end
    PopupUtils.ClaimAndShowRewardList(rewardList)
end