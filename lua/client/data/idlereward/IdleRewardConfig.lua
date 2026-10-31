require "lua.client.data.IdleReward.IdleItemGroupRateConfig"
require "lua.client.data.IdleReward.IdleItemRateConfig"
require "lua.client.data.IdleReward.IdleMoneyConfig"
--- @class IdleRewardConfig
IdleRewardConfig = Class(IdleRewardConfig)

--- @return void
function IdleRewardConfig:Ctor()
    --- @type Dictionary --<difficult, Dictionary <map, stage>>
    self.campaignDictionary = self:GetCampaignDictionary()
    --local idleItem, stage = self:GetIdleItemDictionary()
    local idleItem, stage = self:GetIdleItemDictionaryOptimize()
    --- @type Dictionary --<stageId, Dictionary <groupId, IdleItemGroupRateConfig>>
    self.idleItemRateDictionary = idleItem
    if stage ~= nil then
        ---@type number
        self.difficultAncientPotion, self.mapAncientPotion, self.stageAncientPotion = ClientConfigUtils.GetIdFromStageId(stage)
    end
    --- @type Dictionary--<number, number>
    self.expTrainDictionary = nil
    --- @type Dictionary --<stageId, List<IdleMoneyConfig>>
    --self.idleMoneyDictionary, self.expTrainDictionary = self:GetIdleMoneyDictionary()
    self.idleMoneyDictionary, self.expTrainDictionary = self:GetIdleMoneyDictionaryOptimize()
end

--- @return List<IdleMoneyConfig>
function IdleRewardConfig:GetDataStage(type, stageId)
    local data = self[type]:Get(stageId)
    if data == nil then
        XDebug.Error(string.format("stage %s is nil: %s", type, tostring(stageId)))
    end
    return data
end

--- @return number
function IdleRewardConfig:GetExpTrain(stageId)
    return self:GetDataStage("expTrainDictionary", stageId)
end

--- @return List<IdleMoneyConfig>
function IdleRewardConfig:GetIdleMoney(stageId)
    return self:GetDataStage("idleMoneyDictionary", stageId)
end

--- @return List<IdleMoneyConfig>
function IdleRewardConfig:GetIdleItem(stageId)
    return self:GetDataStage("idleItemRateDictionary", stageId)
end

function IdleRewardConfig:GetRewardsIdle(stageId)
    local rewardList = List()
    local idleItem = self:GetIdleItem(stageId)
    --- @param idleItemGroupRateConfig IdleItemGroupRateConfig
    for _, idleItemGroupRateConfig in pairs(idleItem:GetItems()) do
        --- @param idleItemRateConfig IdleItemRateConfig
        for _, idleItemRateConfig in pairs(idleItemGroupRateConfig.listItemRate:GetItems()) do
            local type = idleItemRateConfig.resourceType
            local id = idleItemRateConfig.id
            local isContain = false
            --- @param itemIconData ItemIconData
            for _, itemIconData in pairs(rewardList:GetItems()) do
                if itemIconData.type == type and itemIconData.itemId == id then
                    isContain = true
                    break
                end
            end
            if isContain == false then
                rewardList:Add(ItemIconData.CreateInstance(type, id))
            end
        end
    end
    return rewardList
end


--- @return Dictionary
function IdleRewardConfig:GetCampaignDictionary()
    local decodeData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.IDLE_ITEM_REWARD, nil, true)
    ---@type Dictionary
    local dict = Dictionary()
    for _, data in ipairs(decodeData) do
        ---@type number
        local difficultId = data['difficultId']
        ---@type number
        local mapId = data['mapId']
        ---@type number
        local stageId = data['stageId']
        ---@type Dictionary
        local dictDifficult

        if dict:IsContainKey(difficultId) then
            dictDifficult = dict:Get(difficultId)
        else
            dictDifficult = Dictionary()
            dict:Add(difficultId, dictDifficult)
        end

        if dictDifficult:IsContainKey(mapId) == false or dictDifficult:Get(mapId) < stageId then
            dictDifficult:Add(mapId, stageId)
        end
    end
    return dict
end

--- @return Dictionary
function IdleRewardConfig:GetIdleItemDictionary()
    local stageAncientPotion = nil
    ---@type Dictionary
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.IDLE_ITEM_RATE)
    ---@type number
    local cacheIdGroup
    ---@type number
    local cacheCsvId

    for i = 1, #parsedData do
        ---@type string
        local data = parsedData[i]
        ---@type number
        local stageIdCsv = tonumber(data.stage)

        if stageIdCsv ~= nil then
            cacheCsvId = stageIdCsv
        end
        if cacheCsvId ~= nil then
            ---@type Dictionary
            local dictStage
            if dict:IsContainKey(cacheCsvId) then
                dictStage = dict:Get(cacheCsvId)
            else
                dictStage = Dictionary()
                dict:Add(cacheCsvId, dictStage)
            end

            ---@type IdleItemGroupRateConfig
            local idleItemGroupRate
            ---@type number
            local groupId = tonumber(data.group)
            if groupId ~= nil then
                cacheIdGroup = groupId
            end
            if dictStage:IsContainKey(cacheIdGroup) then
                idleItemGroupRate = dictStage:Get(cacheIdGroup)
                --XDebug.Log("dictStage:IsContainKey(cacheIdGroup)" .. cacheIdGroup)
            else
                --XDebug.Log("not dictStage:IsContainKey(cacheIdGroup)" .. cacheIdGroup)
                idleItemGroupRate = IdleItemGroupRateConfig()
                idleItemGroupRate.groupId = groupId
                idleItemGroupRate.groupRate = tonumber(data.group_rate)
                dictStage:Add(cacheIdGroup, idleItemGroupRate)
            end
            ---@type IdleItemRateConfig
            local idleItemRateConfig = IdleItemRateConfig()
            idleItemRateConfig.group = idleItemGroupRate.groupId
            idleItemRateConfig.groupRate = idleItemGroupRate.groupRate
            idleItemRateConfig:ParseCsv(data)
            if stageAncientPotion == nil and idleItemRateConfig.resourceType == ResourceType.Money and idleItemRateConfig.id == MoneyType.ANCIENT_POTION then
                stageAncientPotion = cacheCsvId
            end
            idleItemGroupRate.listItemRate:Add(idleItemRateConfig)
        end
    end

    for i, v in pairs(dict:GetItems()) do
        ClientMathUtils.CalculateRate(v:GetItems(), "groupRate")
        --XDebug.Log(LogUtils.ToDetail(v:GetItems()))
    end
    return dict, stageAncientPotion
end

--- @return Dictionary
function IdleRewardConfig:GetIdleItemDictionaryOptimize()
    local stageAncientPotion = nil
    ---@type Dictionary
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.IDLE_ITEM_RATE_OPTIMIZE)
    ---@type number
    local cacheIdGroup
    ---@type number
    local cacheCsvId
    ---@type List
    local listData = List()

    for i = 1, #parsedData do
        ---@type string
        local data = parsedData[i]
        ---@type number
        local stageIdCsv = tonumber(data.stage)

        if stageIdCsv ~= nil then
            cacheCsvId = stageIdCsv
        end
        if cacheCsvId ~= nil then
            ---@type Dictionary
            local dictStage
            if dict:IsContainKey(cacheCsvId) then
                dictStage = dict:Get(cacheCsvId)
            else
                dictStage = Dictionary()
                listData:Add(dictStage)
                for i = tonumber(data.stage1), cacheCsvId do
                    dict:Add(i, dictStage)
                end
            end

            ---@type IdleItemGroupRateConfig
            local idleItemGroupRate
            ---@type number
            local groupId = tonumber(data.group)
            if groupId ~= nil then
                cacheIdGroup = groupId
            end
            if dictStage:IsContainKey(cacheIdGroup) then
                idleItemGroupRate = dictStage:Get(cacheIdGroup)
                --XDebug.Log("dictStage:IsContainKey(cacheIdGroup)" .. cacheIdGroup)
            else
                --XDebug.Log("not dictStage:IsContainKey(cacheIdGroup)" .. cacheIdGroup)
                idleItemGroupRate = IdleItemGroupRateConfig()
                idleItemGroupRate.groupId = groupId
                idleItemGroupRate.groupRate = tonumber(data.group_rate)
                dictStage:Add(cacheIdGroup, idleItemGroupRate)
            end
            ---@type IdleItemRateConfig
            local idleItemRateConfig = IdleItemRateConfig()
            idleItemRateConfig.group = idleItemGroupRate.groupId
            idleItemRateConfig.groupRate = idleItemGroupRate.groupRate
            idleItemRateConfig:ParseCsv(data)
            if stageAncientPotion == nil and idleItemRateConfig.resourceType == ResourceType.Money and idleItemRateConfig.id == MoneyType.ANCIENT_POTION then
                stageAncientPotion = cacheCsvId
            end
            idleItemGroupRate.listItemRate:Add(idleItemRateConfig)
        end
    end

    for i, v in ipairs(listData:GetItems()) do
        ClientMathUtils.CalculateRate(v:GetItems(), "groupRate")
        --XDebug.Log(LogUtils.ToDetail(v:GetItems()))
    end
    return dict, stageAncientPotion
end

--- @return Dictionary
function IdleRewardConfig:GetIdleMoneyDictionary()
    ---@type Dictionary
    local dict = Dictionary()
    ---@type Dictionary
    local dictExp = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.IDLE_MONEY_REWARD)
    local cacheStageId
    for i = 1, #parsedData do
        ---@type List
        local listMoney
        ---@type IdleMoneyConfig
        local idleMoneyConfig = IdleMoneyConfig()
        ---@type string
        local data = parsedData[i]
        ---@type number
        local stageId = tonumber(data.stage)
        if stageId ~= nil then
            cacheStageId = stageId
            if dict:IsContainKey(stageId) then
                listMoney = dict:Get(stageId)
            else
                listMoney = List()
                dict:Add(stageId, listMoney)
            end
        else
            listMoney = dict:Get(cacheStageId)
        end
        idleMoneyConfig.stageId = cacheStageId
        idleMoneyConfig:ParseCsv(data)
        listMoney:Add(idleMoneyConfig)
        local exp = tonumber(data.exp_train)
        if exp ~= nil and exp > 0 then
            dictExp:Add(stageId, tonumber(data.exp_train))
        end
        --XDebug.Log(LogUtils.ToDetail(idleMoneyConfig))
    end
    --for i, v in pairs(dict:GetItems()) do
    --    XDebug.Log(string.format("stageId%s, count%s", i, v:Count()))
    --end
    return dict, dictExp
end

--- @return Dictionary
function IdleRewardConfig:GetIdleMoneyDictionaryOptimize()
    ---@type Dictionary
    local dict = Dictionary()
    ---@type Dictionary
    local dictExp = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.IDLE_MONEY_REWARD_OPTIMIZE)
    local cacheStageId
    for i = 1, #parsedData do
        ---@type List
        local listMoney
        ---@type IdleMoneyConfig
        local idleMoneyConfig = IdleMoneyConfig()
        ---@type string
        local data = parsedData[i]
        ---@type number
        local stageId = tonumber(data.stage)
        if stageId ~= nil then
            cacheStageId = stageId
            if dict:IsContainKey(stageId) then
                listMoney = dict:Get(stageId)
            else
                listMoney = List()
                for i = tonumber(data.stage1), stageId do
                    dict:Add(i, listMoney)
                end
            end
        else
            listMoney = dict:Get(cacheStageId)
        end
        idleMoneyConfig.stageId = cacheStageId
        idleMoneyConfig:ParseCsv(data)
        listMoney:Add(idleMoneyConfig)
        local exp = tonumber(data.exp_train)
        if exp ~= nil and exp > 0 then
            for i = tonumber(data.stage1), stageId do
                dictExp:Add(i, tonumber(data.exp_train))
            end
        end
        --XDebug.Log(LogUtils.ToDetail(idleMoneyConfig))
    end
    --for i, v in pairs(dict:GetItems()) do
    --    XDebug.Log(string.format("stageId%s, count%s", i, v:Count()))
    --end
    return dict, dictExp
end

return IdleRewardConfig