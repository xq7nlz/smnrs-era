require "lua.client.data.Purchase.PackOfProducts"

--- @class BoostFirstPurchasePackOfProducts : PackOfProducts
BoostFirstPurchasePackOfProducts = Class(BoostFirstPurchasePackOfProducts, PackOfProducts)

--- @param pack ProgressPackProduct
--- @param csvPath string
--- @param conditionPath string
--- @param opCode OpCode
function BoostFirstPurchasePackOfProducts:Ctor(opCode, pack, csvPath, conditionPath)
    self.conditionPath = conditionPath
    self.groupPackDict = Dictionary()
    PackOfProducts.Ctor(self, opCode, pack, csvPath)
end

--- @return void
function BoostFirstPurchasePackOfProducts:ParseCsv()
    PackOfProducts.ParseCsv(self)
    self:ParseGroupPack()
end

function BoostFirstPurchasePackOfProducts:ParseGroupPack()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(self.csvPath)
    if parsedData ~= nil then
        --- @type GroupProductConfig
        local group = nil
        for _, v in ipairs(parsedData) do
            if v.group ~= nil then
                local groupId = tonumber(v.group)
                group = GroupProductConfig(v)
                self.groupPackDict:Add(groupId, group)
            end
            if v.id ~= nil then
                local packId = tonumber(v.id)
                local pack = self:GetPackBase(packId)
                group:AddProductConfig(pack)
            end
        end
    end
end

--- @return GroupProductConfig
--- @param groupId number
function BoostFirstPurchasePackOfProducts:GetGroup(groupId)
    local group = self.groupPackDict:Get(groupId)
    if group == nil then
        --XDebug.Log("groupId is nil: " .. tostring(groupId))
    end
    return group
end


