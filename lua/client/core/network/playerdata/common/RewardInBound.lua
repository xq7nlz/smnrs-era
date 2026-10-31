--- @class RewardInBound
RewardInBound = Class(RewardInBound)

--- @return void
function RewardInBound:Ctor()
    --- @type ResourceType
    self.type = nil
    --- @type number
    self.id = nil
    --- @type number
    self.number = nil
    --- @type number
    self.data = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function RewardInBound:ReadBuffer(buffer)
    self.type = buffer:GetByte()
    self.id = buffer:GetInt()
    self.number = buffer:GetInt()
    self.data = buffer:GetInt()
end

--- @return ItemIconData
function RewardInBound:GetIconDataNotCalculate()
    return ItemIconData.CreateInstance(self.type, self.id, ClientMathUtils.OriginalRewardNotCalculation(self.number), self.data)
end

--- @return ItemIconData
function RewardInBound:GetIconData()
    return ItemIconData.CreateInstance(self.type, self.id, self:GetNumber(), self.data)
end

--- @return ItemIconData
function RewardInBound:GetSelectionIconData()
    return ItemIconData.CreateInSelectionInstance(self.selectionId,self.type, self.id, self:GetNumber(), self.data)
end

--- @return number
function RewardInBound:GetNumber()
    return ClientMathUtils.ConvertingCalculation(self.number)
end

--- @return void
function RewardInBound:AddToInventory()
    self:GetIconData():AddToInventory()
end

--- @return string
function RewardInBound:GetKey()
    return string.format("%s_%s_%s", self.type, self.id, self.data or 0)
end

--- @return string
function RewardInBound:ToString()
    return string.format("type: %d, id: %d, number: %s", self.type, self.id, self.number)
end

--- @return string
function RewardInBound:GetNumberBase()
    if type(self.number) == "string" then
        return tonumber(string.match(self.number, "%d+"))
    else
        return self.number
    end
end

--- @return CALCULATOR_TYPE
function RewardInBound:GetCALCULATOR_TYPE()
    if type(self.number) == "string" then
        if string.find(self.number, "*") then
            return CALCULATOR_TYPE.MULTIPLY
        elseif string.find(self.number, "+") then
            return CALCULATOR_TYPE.ADD
        end
    end
    return nil
end

--- @return FACTOR_TYPE
function RewardInBound:GetFACTOR_TYPE()
    if type(self.number) == "string" then
        if string.find(self.number, "summoner_level") then
            return FACTOR_TYPE.LEVEL_SUMMON
        elseif string.find(self.number, "vip_level") then
            return FACTOR_TYPE.VIP_LEVEL
        end
    end
    return nil
end

--- @return RewardInBound
--- @param buffer UnifiedNetwork_ByteBuf
function RewardInBound.CreateByBuffer(buffer)
    local data = RewardInBound()

    data.type = buffer:GetByte()
    data.id = buffer:GetInt()
    data.number = buffer:GetInt()
    data.data = buffer:GetInt()
    return data
end


--- @return RewardInBound
--- @param json table
function RewardInBound.CreateByJson(json)
    local ins = RewardInBound()

    ins.type = tonumber(json['0'])
    ins.id = tonumber(json['1'])
    ins.number = tonumber(json['2'])
    ins.data = json['3']
    return ins
end

--- @return RewardInBound
--- @param itemType ResourceType
--- @param id number
--- @param number number
--- @param data table
function RewardInBound.CreateBySingleParam(itemType, id, number, data)
    local ins = RewardInBound()
    ins.type = tonumber(itemType)
    ins.id = tonumber(id)
    ins.data = data
    ins.number = tonumber(number) == nil and number or tonumber(number)

    return ins
end

--- @return RewardInBound
--- @param data {res_type, res_id, res_number, res_data}
function RewardInBound.CreateByParams(data)


    --XDebug.Log("data " .. LogUtils.ToDetail(data))
    local ins = RewardInBound()
    if data ~= nil then
        ins.type = tonumber(data.res_type)
        ins.id = tonumber(data.res_id)
        ins.data = data.res_data
        ins.number = tonumber(data.res_number) == nil and data.res_number or tonumber(data.res_number)
    end
    return ins
end

--- @return RewardInBound
--- @param data {selection_id,res_type, res_id, res_number, res_data}
function RewardInBound.CreateByParamsArenaChest(data)
    --XDebug.Log("data " .. LogUtils.ToDetail(data))
    local ins = RewardInBound()
    if data ~= nil then
        ins.selectionId = tonumber(data.selection_id)
        ins.type = tonumber(data.selection_res_type)
        ins.id = tonumber(data.selection_res_id)
        ins.data = data.selection_res_data
        ins.number = tonumber(data.selection_res_number) == nil
                and data.selection_res_number or tonumber(data.selection_res_number)
    end
    return ins
end

--- @return RewardInBound
--- @param reward RewardInBound
function RewardInBound.Clone(reward)
    local ins = RewardInBound()
    ins.type = reward.type
    ins.id = reward.id
    ins.number = reward:GetNumber()
    ins.data = reward.data
    return ins
end

--- @return List -- ItemIconData
--- @param rewardList List -- RewardInBound
---
function RewardInBound.GetItemIconDataList(rewardList)
    local iconDataList = List()
    --- @param v RewardInBound
    for _, v in ipairs(rewardList:GetItems()) do
        iconDataList:Add(v:GetIconData())
    end
    return iconDataList
end

function RewardInBound.GetItemIconDataListNotCalculateVipSummonLevel(rewardList)
    local iconDataList = List()
    --- @param v RewardInBound
    for _, v in ipairs(rewardList:GetItems()) do
        iconDataList:Add(v:GetIconDataNotCalculate())
    end
    return iconDataList
end