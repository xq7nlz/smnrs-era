--- @class VipRewardData
VipRewardData = Class(VipRewardData)

function VipRewardData:Ctor()
    --- @type Dictionary  --<vipLevel, List<ItemIconData>>
    self.dict = nil
end

function VipRewardData:ReadData(path)
    self.dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local vipLevelCache
    for i = 1, #parsedData do

        if parsedData[i].vip_level ~= nil and parsedData[i].vip_level ~= "" then
            vipLevelCache = tonumber(parsedData[i].vip_level)
        end
        if vipLevelCache ~= nil then
            ---@type List
            local listItem
            if self.dict:IsContainKey(vipLevelCache) then
                listItem = self.dict:Get(vipLevelCache)
            else
                listItem = List()
                self.dict:Add(vipLevelCache, listItem)
                if parsedData[i].subscription_pack_id ~= nil then
                    local subscriptionPackId = tonumber(parsedData[i].subscription_pack_id)
                    listItem.subscriptionPackId = subscriptionPackId
                end
            end
            ---@type ItemIconData
            local itemData = ItemIconData.CreateInstance(tonumber(parsedData[i].res_type), tonumber(parsedData[i].res_id), tonumber(parsedData[i].res_number))
            listItem:Add(itemData)
        end
    end
end

---@return List
---@param vipLevel number
function VipRewardData:GetListRewardByVipLevel(vipLevel)
    return self.dict:Get(vipLevel)
end