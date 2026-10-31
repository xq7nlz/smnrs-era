require("lua.client.data.Purchase.GroupProductConfig")

--- @class GroupPackOfProducts : PackOfProducts
GroupPackOfProducts = Class(GroupPackOfProducts, PackOfProducts)

--- @param pack LevelPassProduct
--- @param csvPath string
--- @param opCode OpCode
function GroupPackOfProducts:Ctor(opCode, pack, csvPath)
    self.groupPackDict = Dictionary()
    PackOfProducts.Ctor(self, opCode, pack, csvPath)
end

--- @return void
function GroupPackOfProducts:ParseCsv()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(self.csvPath)
    if parsedData ~= nil then
        --- @type ProductConfig
        local productConfig
        local group
        for _, v in ipairs(parsedData) do
            if v.group ~= nil then
                group = tonumber(v.group)
                self.groupPackDict:Add(group, GroupProductConfig(v))
            end
            if v.id ~= nil then
                productConfig = self.pack()
                productConfig.opCode = self.opCode
                self.packDict:Add(tonumber(v.id), productConfig)
                self.packList:Add(productConfig)
                self:AddPackToGroup(group, productConfig)
            end
            productConfig:ParseCsv(v)
        end
    else
        XDebug.Error("data path is nil: " .. self.csvPath)
    end
end

--- @param group number
--- @param productConfig ProductConfig
function GroupPackOfProducts:AddPackToGroup(group, productConfig)
    if group == nil then
        XDebug.Error("pack group NIL!!!")
        return
    end
    --- @type GroupProductConfig
    local groupProductConfig = self:GetGroupProductConfig(group)
    if groupProductConfig == nil then
        XDebug.Error(string.format("GroupProductConfig %s NIL", group))
        return
    end
    groupProductConfig:AddProductConfig(productConfig)
end

--- @return GroupProductConfig
--- @param group number
function GroupPackOfProducts:GetGroupProductConfig(group)
    return self.groupPackDict:Get(group)
end