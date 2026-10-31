require "lua.client.data.Purchase.PackOfProducts"
require "lua.client.data.Purchase.EventBossChallenge.BossChallengeGroupProductConfig"

--- @class BossChallengeGroupPackOfProducts : PackOfProducts
BossChallengeGroupPackOfProducts = Class(BossChallengeGroupPackOfProducts, PackOfProducts)

--- @param pack EventBossChallengeBundleProduct
--- @param csvPath string
--- @param opCode OpCode
function BossChallengeGroupPackOfProducts:Ctor(opCode, pack, csvPath)
    self.groupPackDict = Dictionary()
    self.csvPath = csvPath
    PackOfProducts.Ctor(self, opCode, pack, csvPath)
end

--- @return void
function BossChallengeGroupPackOfProducts:ParseCsv()
    PackOfProducts.ParseCsv(self)
    self:ParseCondition()
end

function BossChallengeGroupPackOfProducts:ParseCondition()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(self.csvPath)
    if parsedData ~= nil then
        --- @type BossChallengeGroupProductConfig
        local group = nil
        for _, v in ipairs(parsedData) do
            if v.group ~= nil then
                local groupId = tonumber(v.group)
                group = BossChallengeGroupProductConfig(v)
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

