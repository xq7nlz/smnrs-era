--- @class ComebackProducts
ComebackProducts = Class(ComebackProducts)

local COMEBACK_BUNDLE_CONFIG = "csv/client/comeback_bundle.csv"

--- @return void
--- @param pack LimitedProduct
--- @param csvPath string
---@param opCode OpCode
function ComebackProducts:Ctor(opCode, pack, csvPath)
    self.opCode = opCode
    --- @type LimitedProduct
    self.pack = pack
    self.csvPath = csvPath
    self.packDict = Dictionary() -- use for query data
    self.packList = List() -- use for show data from sort list

    --- @type Dictionary
    self.packDataDict = Dictionary()

    self:ParseCsv()
end

--- @return void
function ComebackProducts:ParseCsv()
    local listId = self:GetComebackBundleConfig()
    for _, id in pairs(listId) do
        id = tonumber(id)
        local fullPath = string.format(self.csvPath, id)
        self.packDataDict:Add(id, PackOfProducts(self.opCode, self.pack, fullPath))
    end

    --- @param v PackOfProducts
    for dataId, v in pairs(self.packDataDict:GetItems()) do
        local allPackBase = v:GetAllPackBase()
        for i = 1, allPackBase:Count() do
            --- @type ProductConfig
            local productConfig = allPackBase:Get(i)
            productConfig.dataId = dataId
            productConfig:SetKey()
            self.packList:Add(productConfig)
            self.packDict:Add(productConfig.productID, productConfig)
        end
    end
end

--- @return PackOfProducts
function ComebackProducts:GetPackDictByDataId(dataId)
    return self.packDataDict:Get(dataId)
end

--- @return List
function ComebackProducts:GetAllPackBase()
    return self.packList
end

--- @return Dictionary
function ComebackProducts:GetAllPackDict()
    return self.packDict
end

--- @return ProductConfig
--- @param id number
function ComebackProducts:GetPackBase(id)
    local data = self.packDict:Get(id)
    if data == nil then
        XDebug.Warning(string.format("pack_id is nil: %s opCode: %s", tostring(id), tostring(self.opCode)))
    end
    return data
end

--- @return string
function ComebackProducts:ToString()
    local str = ""
    for _, v in pairs(self.packDict:GetItems()) do
        str = str .. LogUtils.ToDetail(v)
        --for i, v in pairs(v.rewardList:GetItems()) do
        --    XDebug.Log(LogUtils.ToDetail(v))
        --end
    end
    return str
end

--- @return Dictionary
function ComebackProducts:GetComebackBundleConfig()
    local packIdDict = Dictionary()
    local content = CsvReaderUtils.ReadLocalFile(COMEBACK_BUNDLE_CONFIG)
    local lines = content:Split('\n')
    for i = 1, #lines do
        local chars = lines[i]:Split(',')
        local name = chars[1]
        chars[1] = nil
        packIdDict:Add(name, chars)
    end
    return packIdDict:Get("comeback")
end