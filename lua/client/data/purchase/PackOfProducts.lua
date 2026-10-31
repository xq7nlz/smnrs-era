--- @class PackOfProducts
PackOfProducts = Class(PackOfProducts)

--- @return void
--- @param pack ProgressPackProduct|RawProduct|SubscriptionProduct|LimitedProduct|EventProduct|FlashSaleEvolveProduct
--- @param csvPath string
---@param opCode OpCode
function PackOfProducts:Ctor(opCode, pack, csvPath)
    self.opCode = opCode
    self.pack = pack
    self.csvPath = csvPath
    self.packDict = Dictionary() -- use for query data
    self.packList = List() -- use for show data from sort list

    self:ParseCsv()
end

--- @return void
function PackOfProducts:ParseCsv()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(self.csvPath)
    if parsedData ~= nil then
        --- @type ProductConfig
        local purchasePack
        for _, v in ipairs(parsedData) do
            if v.id ~= nil then
                purchasePack = self.pack()
                purchasePack.opCode = self.opCode
                self.packDict:Add(tonumber(v.id), purchasePack)
                self.packList:Add(purchasePack)
            end
            purchasePack:ParseCsv(v)
        end
    else
        XDebug.Error("data path is nil: " .. self.csvPath)
    end
end

--- @return List
function PackOfProducts:GetAllPackBase()
    return self.packList
end

--- @return Dictionary
function PackOfProducts:GetAllPackDict()
    return self.packDict
end

--- @return ProductConfig
--- @param id number
function PackOfProducts:GetPackBase(id)
    local data = self.packDict:Get(id)
    if data == nil then
        XDebug.Warning(string.format("pack_id is nil: %s opCode: %s", tostring(id), tostring(self.opCode)))
    end
    return data
end

--- @return string
function PackOfProducts:ToString()
    local str = ""
    for _, v in pairs(self.packDict:GetItems()) do
        str = str .. LogUtils.ToDetail(v)
        --for i, v in pairs(v.rewardList:GetItems()) do
        --    XDebug.Log(LogUtils.ToDetail(v))
        --end
    end
    return str
end