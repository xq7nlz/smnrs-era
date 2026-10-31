--- @class BoostFirstPurchaseProduct : ProductConfig
BoostFirstPurchaseProduct = Class(BoostFirstPurchaseProduct, ProductConfig)

function BoostFirstPurchaseProduct:Ctor()
    ProductConfig.Ctor(self)
    self.opCode = OpCode.PURCHASE_BOOST_FIRST_PACK
    self.isLimited = true
    self.is_selection_pack = false
    self.number_selection = nil
    --- @type List | <RewardInBound>
    self.rewardSelectionHeroList = List()
    --- @type List | <RewardInBound>
    self.rewardSelectionItemList = List()
    --- @type Dictionary | <RewardInBound>
    self.rewardSelectionHeroDict = Dictionary()
    --- @type Dictionary | <RewardInBound>
    self.rewardSelectionItemDict = Dictionary()
end

function BoostFirstPurchaseProduct:ClaimAndShowRewardList()
    ---@type List <RewardInBound>
    local rewardList = List()
    for i, v in ipairs(self.rewardList:GetItems()) do
        rewardList:Add(v)
    end
    if self.bonusReward ~= nil then
        rewardList:Add(self.bonusReward)
    end
    if self.listSelectReward ~= nil then
        for i, v in ipairs(self.listSelectReward:GetItems()) do
            rewardList:Add(v)
        end
    end
    if (self.is_selection_pack) then
        for i = 1, 2 do
            local selectId = UIStarterPackNewView.GetItemSelect(self.id, i)
            if (selectId ~= nil) then
                if i == 1 then
                    rewardList:Add(self.rewardSelectionHeroDict:Get(selectId).rewardInBound)
                else
                    rewardList:Add(self.rewardSelectionItemDict:Get(selectId).rewardInBound)
                end
            end
        end
    end
    PopupUtils.ClaimAndShowRewardList(rewardList)
end

--- @return void
function BoostFirstPurchaseProduct:ParseCsv(data)
    if data.id ~= nil then
        ProductConfig.ParseCsv(self, data)
        --- @type number
        self.profit = tonumber(data['profit'])
        --- @type number
        self.stock = tonumber(data['stock'])
        --- @type string
        self.originPricePackId = data['origin_price_pack_id']
        local selectionVal = data.is_selection_pack
        if (selectionVal ~= nil) then
            self.is_selection_pack = MathUtils.ToBoolean(selectionVal)
            --XDebug.Log("self sel " .. tostring(data.id) .. tostring(self.is_selection_pack))
        end
        local number_selection = data.number_selection
        if (number_selection ~= nil) then
            ---@type number
            self.number_selection = number_selection
        end
    end
    ---@type RewardInBound
    local rewardInBound = RewardInBound.CreateByParams(data)
    if (rewardInBound.id ~= nil) then
        self.rewardList:Add(rewardInBound)
    end
    if (self.is_selection_pack) then
        ---@type number
        local selection_id = tonumber(data['selection_id'])
        ---@type ResourceType
        local selection_res_type = data['selection_res_type']
        ---@type number
        local selection_res_id = data['selection_res_id']
        ---@type number
        local selection_res_number = data['selection_res_number']
        --- @type number
        local selection_res_data = data['selection_res_data']
        ---@type RewardInBound
        local rewardInBound = RewardInBound.CreateBySingleParam(selection_res_type, selection_res_id, selection_res_number, selection_res_data)
        ---@type SelectReward
        local selectReward = SelectReward()
        selectReward.rewardInBound = rewardInBound
        selectReward.selectionId = selection_id
        if self.rewardSelectionHeroDict:Count() < 4 then
            self.rewardSelectionHeroList:Add(selectReward)
            --XDebug.Log("add reward " .. tostring(selection_res_id))
            self.rewardSelectionHeroDict:Add(selection_id, selectReward)
        else
            self.rewardSelectionItemList:Add(selectReward)
            --XDebug.Log("add reward " .. tostring(selection_res_id))
            self.rewardSelectionItemDict:Add(selection_id, selectReward)
        end
    end
end