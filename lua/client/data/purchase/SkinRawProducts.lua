--- @class SkinRawProducts
SkinRawProducts = Class(SkinRawProducts)

--- @return void
--- @param pack ProgressPackProduct|RawProduct|SubscriptionProduct|LimitedProduct|EventProduct
--- @param csvPath string
---@param opCode OpCode
function SkinRawProducts:Ctor(opCode, pack, csvPath)
    self.opCode = opCode
    self.pack = pack
    self.csvPath = csvPath
    self.packDict = Dictionary() -- use for query data
    self.packList = List() -- use for show data from sort list

    --- @type Dictionary -- skinId - ProductConfig
    self.rawSkinPackDict = Dictionary()
    --- @type List -- skinId
    self.rawSkinPackList = List()

    self:ParseCsv()
end

--- @return void
function SkinRawProducts:ParseCsv()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(self.csvPath)
    if parsedData ~= nil then
        --- @type ProductConfig
        local purchasePack
        for _, v in ipairs(parsedData) do
            local rewardInBound = RewardInBound.CreateByParams(v)
            if v.id ~= nil then
                purchasePack = self.pack()
                purchasePack.opCode = self.opCode
                self.packDict:Add(tonumber(v.id), purchasePack)
                self.packList:Add(purchasePack)
                purchasePack:ParseCsv(v)
                purchasePack.rewardList:Add(rewardInBound)

                if rewardInBound.type == ResourceType.Skin then
                    self.rawSkinPackDict:Add(rewardInBound.id, purchasePack)
                    self.rawSkinPackList:Add(rewardInBound.id)
                end
            else
                purchasePack.rewardList:Add(rewardInBound)
            end
        end
    else
        XDebug.Error("data path is nil: " .. self.csvPath)
    end
end

--- @return List
function SkinRawProducts:GetAllPackBase()
    return self.packList
end

--- @return Dictionary
function SkinRawProducts:GetAllPackDict()
    return self.packDict
end

--- @return Dictionary
function SkinRawProducts:GetAllPackSkinDict()
    return self.rawSkinPackDict
end

--- @return List
function SkinRawProducts:GetAllPackSkinList()
    return self.rawSkinPackList
end

--- @return ProductConfig
--- @param id number
function SkinRawProducts:GetPackBase(id)
    local data = self.packDict:Get(id)
    if data == nil then
        XDebug.Warning(string.format("pack_id is nil: %s opCode: %s", tostring(id), tostring(self.opCode)))
    end
    return data
end

--- @return string
function SkinRawProducts:ToString()
    local str = ""
    for _, v in pairs(self.packDict:GetItems()) do
        str = str .. LogUtils.ToDetail(v)
        --for i, v in pairs(v.rewardList:GetItems()) do
        --    XDebug.Log(LogUtils.ToDetail(v))
        --end
    end
    return str
end

--- @return ProductConfig
function SkinRawProducts:FindSkinProductBySkinId(skinId)
    return self.rawSkinPackDict:Get(skinId)
end