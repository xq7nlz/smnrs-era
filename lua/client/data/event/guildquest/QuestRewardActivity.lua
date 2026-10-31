require("lua.client.data.Quest.QuestElementConfig")

--- @class QuestRewardActivity
QuestRewardActivity = Class(QuestRewardActivity)

--- @return void
function QuestRewardActivity:Ctor()
    ---@type QuestElementConfig
    self.questElementConfig = nil
    self.convertRate = nil
end

--- @return void
function QuestRewardActivity:ParsedData(data)
    self.convertRate = tonumber(data.convert_rate)
    self.questElementConfig = QuestElementConfig.GetInstanceFromCsv(data)
end

--- @return MoneyType
function QuestRewardActivity:GetMoneyTpe()
    if self.questElementConfig._questType == QuestType.SUMMON_HERO_BY_PREMIUM_SCROLL then
        return MoneyType.SUMMON_HEROIC_SCROLL
    elseif self.questElementConfig._questType == QuestType.PROPHET_TREE_SUMMON then
        return MoneyType.PROPHET_ORB
    elseif self.questElementConfig._questType == QuestType.CASINO_SPIN_MONEY then
        if self.questElementConfig:GetRequirementsByIndex(2) == 0 then
            return MoneyType.CASINO_BASIC_CHIP
        else
            return MoneyType.CASINO_PREMIUM_CHIP
        end
    end
    return nil
end

--- @return FeatureType
function QuestRewardActivity:GetFeatureType()
    if self.questElementConfig._questType == QuestType.ARENA_CHALLENGE then
        return FeatureType.ARENA
    elseif self.questElementConfig._questType == QuestType.CAMPAIGN_CHALLENGE then
        return FeatureType.CAMPAIGN
    elseif self.questElementConfig._questType == QuestType.TOWER_CHALLENGE then
        return FeatureType.TOWER
    elseif self.questElementConfig._questType == QuestType.GUILD_DUNGEON_CHALLENGE then
        return FeatureType.GUILD_DUNGEON
    elseif self.questElementConfig._questType == QuestType.GUILD_BOSS_CHALLENGE then
        return FeatureType.GUILD_BOSS
    end
    return nil
end

--- @return FeatureType
---@param moneyType
function QuestRewardActivity:GetRewardMoneyType(moneyType)
    ---@param v RewardInBound
    for _, v in pairs(self.questElementConfig._listReward:GetItems()) do
        if v.type == ResourceType.Money and v.id == moneyType then
            return v
        end
    end
    return nil
end