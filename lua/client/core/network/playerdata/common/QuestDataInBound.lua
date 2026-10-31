require "lua.client.data.Quest.QuestType"
require "lua.client.core.network.playerData.quest.DailyQuestInBound"
require "lua.client.core.network.playerData.quest.NewDailyQuestInBound"
require "lua.client.core.network.playerData.quest.AchievementQuestInBound"
require "lua.client.core.network.playerData.quest.QuestTreeDataInBound"
require "lua.client.core.network.playerData.quest.QuestUnitInBound"

--- @class QuestDataType
QuestDataType = {
    DAILY_QUEST = 1,
    ACHIEVEMENT = 2,
    QUEST_TREE = 3,
    NEW_DAILY_QUEST = 4
}

--- @class QuestDataInBound
QuestDataInBound = Class(QuestDataInBound)

function QuestDataInBound:Ctor()
    --- @type boolean
    self.needRequest = nil
    --- @type boolean
    self.hasNotification = nil
    --- @type number
    self.lastTimeUpdateNotify = nil
    --- @type DailyQuestInBound
    self.dailyQuestInBound = DailyQuestInBound()
    --- @type NewDailyQuestInBound
    self.newDailyQuestInBound = NewDailyQuestInBound()
    --- @type AchievementQuestInBound
    self.achievementQuestInBound = AchievementQuestInBound()
    --- @type QuestTreeDataInBound
    self.questTreeDataInBound = QuestTreeDataInBound()

    --- @type Dictionary|{string, number}
    self.progressRecordDict = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function QuestDataInBound:ReadBuffer(buffer)
    self.dailyQuestInBound:ReadBuffer(buffer)
    self.newDailyQuestInBound:ReadBuffer(buffer)
    self.achievementQuestInBound:ReadBuffer(buffer)
    self.questTreeDataInBound:ReadBuffer(buffer)

    self.progressRecordDict = Dictionary()
    for _ = 1, buffer:GetShort() do
        local keyRecordProgress = buffer:GetString()
        local record = buffer:GetLong()
        self.progressRecordDict:Add(keyRecordProgress, record)
    end
    self.needRequest = false
    self:CheckLocalNotification()
end

--- @return number
--- @param keyRecordProgress string
function QuestDataInBound:GetRecordProgressByKey(keyRecordProgress)
    return self.progressRecordDict:Get(keyRecordProgress)
end

--- @param questId number
function QuestDataInBound:SetQuestTreeComplete(questId)
    self.questTreeDataInBound:SetQuestTreeComplete(questId)
    self:CheckLocalNotification()
end

--- @param callbackSuccess function
function QuestDataInBound.Validate(callbackSuccess, showWaiting)
    local questDataInBound = zg.playerData:GetQuest()
    if questDataInBound == nil or questDataInBound.needRequest == true then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.QUEST }, callbackSuccess, SmartPoolUtils.LogicCodeNotification, showWaiting)
    else
        callbackSuccess()
    end
end

function QuestDataInBound:CheckLocalNotification()
    self.newDailyQuestInBound:CheckNotification()
    self.achievementQuestInBound:CheckNotification()
    self.questTreeDataInBound:CheckNotification()

    self.hasNotification = self.newDailyQuestInBound.hasNotification
            or self.questTreeDataInBound.hasNotification
            or self.achievementQuestInBound.hasNotification

    self.lastTimeUpdateNotify = zg.timeMgr:GetServerTime()
    RxMgr.notificationRequestQuest:Next()
end

--- @param buffer UnifiedNetwork_ByteBuf
--- @param questType QuestType
function QuestDataInBound.GetQuestProgressDataFromBuffer(buffer, questType)
    if questType == QuestType.DAILY_QUEST_COMPLETE
            or questType == QuestType.DUNGEON_HERO_BIND
            or questType == QuestType.EMAIL_VERIFY
            or questType == QuestType.FORMATION_HERO_SELECT
            or questType == QuestType.FORMATION_HERO_SAME_FACTION_SELECT
            or questType == QuestType.EVENT_PUZZLE_DAILY_QUEST_COMPLETE
            or questType == QuestType.FRIEND_COUNT then
        return buffer:GetByte()
    elseif questType == QuestType.HERO_COLLECT
            or questType == QuestType.HERO_EVOLVE
            or questType == QuestType.HERO_LEVEL_UP
            or questType == QuestType.HERO_LEVEL_UP_MAX
            or questType == QuestType.HERO_DISASSEMBLE
            or questType == QuestType.HERO_COLLECT_BASE_STAR
            or questType == QuestType.HERO_COLLECT_ALL_BASE_STAR
            or questType == QuestType.HAND_OF_MIDAS_USE
            or questType == QuestType.TAVERN_QUEST_COMPLETE
            or questType == QuestType.ARENA_CHALLENGE
            or questType == QuestType.ARENA_WIN
            or questType == QuestType.ARENA_ELO_REACH
            or questType == QuestType.CAMPAIGN_CLAIM_IDLE_REWARD
            or questType == QuestType.CASINO_SPIN_HERO_FRAGMENT
            or questType == QuestType.CASINO_SPIN_MONEY
            or questType == QuestType.CASINO_SPIN_HERO_FRAGMENT_WITHOUT
            or questType == QuestType.CASINO_SPIN_MONEY_WITHOUT
            or questType == QuestType.MARKET_BUY_HERO_FRAGMENT
            or questType == QuestType.GUILD_JOIN
            or questType == QuestType.GUILD_BOSS_CHALLENGE
            or questType == QuestType.GUILD_DUNGEON_STAGE_CHALLENGE
            or questType == QuestType.GUILD_DUNGEON_SEASON_COMPLETE
            or questType == QuestType.GUILD_MARKET_BUY
            or questType == QuestType.EQUIPMENT_COLLECT
            or questType == QuestType.EQUIPMENT_EQUIP
            or questType == QuestType.EQUIPMENT_UPGRADE
            or questType == QuestType.EQUIPMENT_SET_COLLECT
            or questType == QuestType.PROPHET_TREE_SUMMON
            or questType == QuestType.PROPHET_TREE_CONVERT
            or questType == QuestType.PROPHET_TREE_SUMMON_WITHOUT
            or questType == QuestType.FRIEND_POINT_SEND
            or questType == QuestType.FRIEND_POINT_RECEIVE
            or questType == QuestType.FRIEND_BOSS_SCOUT
            or questType == QuestType.FRIEND_BOSS_CLEAR
            or questType == QuestType.STONE_UNLOCK
            or questType == QuestType.STONE_UPGRADE
            or questType == QuestType.STONE_CONVERT
            or questType == QuestType.ARTIFACT_COLLECT
            or questType == QuestType.ARTIFACT_EQUIP
            or questType == QuestType.ARTIFACT_UPGRADE
            or questType == QuestType.SUMMON_HERO
            or questType == QuestType.SUMMON_HERO_BY_BASIC_SCROLL
            or questType == QuestType.SUMMON_HERO_BY_PREMIUM_SCROLL
            or questType == QuestType.SUMMON_HERO_BY_FRIEND_POINT
            or questType == QuestType.SUMMON_HERO_WITHOUT
            or questType == QuestType.DUNGEON_ACTIVE_BUFF_USE
            or questType == QuestType.DUNGEON_MARKET_BUY
            or questType == QuestType.DUNGEON_SMASH_SHOP_BUY
            or questType == QuestType.MASTERY_UPGRADE
            or questType == QuestType.RAID_CHALLENGE
            or questType == QuestType.GUILD_BOSS_ALL_DAMAGE_REACH
            or questType == QuestType.FORMATION_ACTIVATE_AURA
            or questType == QuestType.FORMATION_ACTIVATE_COMPANION_BUFF
            or questType == QuestType.FORMATION_SELECT_OTHER
            or questType == QuestType.FACEBOOK_JOIN
            or questType == QuestType.CAMPAIGN_CHALLENGE
            or questType == QuestType.TOWER_CHALLENGE
            or questType == QuestType.GUILD_DUNGEON_CHALLENGE
            or questType == QuestType.GUILD_CHECK_IN
            or questType == QuestType.ARENA_CONSECUTIVE_CHALLENGE
            or questType == QuestType.CAMPAIGN_CONSECUTIVE_CHALLENGE
            or questType == QuestType.TOWER_CHALLENGE_CONSECUTIVE
            or questType == QuestType.PURCHASE_PACKAGE
            or questType == QuestType.PLAYER_DAY_CREATE
            or questType == QuestType.HERO_RESET
            or questType == QuestType.FEED_THE_BEAST
            or questType == QuestType.FEED_THE_BEAST_X_TIME
            or questType == QuestType.CAMPAIGN_QUICK_BATTLE
            or questType == QuestType.HERO_COLLECT_BASE_ID
            or questType == QuestType.DEFENSE_CHALLENGE
            or questType == QuestType.DEFENSE_IDLE_CLAIM
            or questType == QuestType.EVENT_DAILY_QUEST_COMPLETE
            or questType == QuestType.ARENA_TEAM_CHALLENGE
            or questType == QuestType.ARENA_TEAM_WIN
            or questType == QuestType.ARENA_TEAM_ELO_REACH
            or questType == QuestType.ARENA_TEAM_CONSECUTIVE_CHALLENGE
            or questType == QuestType.ARENA_COMMON_CHALLENGE
            or questType == QuestType.MARKET_REFRESH
            or questType == QuestType.VIDEO_CLAIM
            or questType == QuestType.EVENT_WEEKLY_QUEST_COMPLETE
            or questType == QuestType.SPECIFIC_BUNDLE_PURCHASE
            or questType == QuestType.LIMIT_BUNDLE_FREE_CLAIM
            or questType == QuestType.DOMAIN_STAGE_PASS
            or questType == QuestType.DOMAIN_JOIN_QUEST
            or questType == QuestType.DOMAIN_CHALLENGE_BY_DAY
            or questType == QuestType.EVENT_COMPLETED_COLLECTION_QUEST
            or questType == QuestType.DEFENSE_STAGE_PASS
            or questType == QuestType.EVENT_SKIN_CHALLENGE_QUEST
            or questType == QuestType.WISH_NEW_YEAR_X_TIME
            or questType == QuestType.CAMPAIGN_CLAIM_IDLE_CHEST_TIME
            or questType == QuestType.REGRESS_HEROES
            or questType == QuestType.RECYCLE_HEROES
            or questType == QuestType.RISING_HERO
            or questType == QuestType.START_TAVERN_QUEST
            or questType == QuestType.REPLACE_HERO_QUEST
            or questType == QuestType.UPGRADE_ITEM_STAR_QUEST
            or questType == QuestType.WIN_IN_GAME_MODE_QUEST then
        return buffer:GetInt()
    elseif questType == QuestType.HAND_OF_MIDAS_USE_CONSECUTIVE
            or questType == QuestType.GUILD_BOSS_CHALLENGE_CONSECUTIVE
            or questType == QuestType.LOGIN_CONSECUTIVE
            or questType == QuestType.DAILY_QUEST_COMPLETE_CONSECUTIVE
            or questType == QuestType.DAILY_QUEST_COMPLETE_CUMULATIVE
            or questType == QuestType.DUNGEON_STAGE_PASS
            or questType == QuestType.IAP_PACK
            or questType == QuestType.LOGIN_DAILY then
        return buffer:GetShort()
    elseif questType == QuestType.CAMPAIGN_CLAIM_GOLD
            or questType == QuestType.MARKET_BUY_MONEY
            or questType == QuestType.MARKET_SPEND
            or questType == QuestType.MONEY_EARN
            or questType == QuestType.MONEY_SPEND
            or questType == QuestType.EVENT_ZODIAC_MONEY_SPEND
            or questType == QuestType.EVENT_AIRYUU_TREASURE_OPEN
            or questType == QuestType.EVENT_DRAGON_TOWER_BUILDING
            or questType == QuestType.EVENT_SEASONAL_QUEST
            or questType == QuestType.CAMPAIGN_AUTO_TRAIN_TIME then
        return buffer:GetLong()
    elseif questType == QuestType.SUMMONER_LEVEL_UP then
        return zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
    elseif questType == QuestType.CAMPAIGN_STAGE_PASS then
        return zg.playerData:GetCampaignData().stageCurrent
    elseif questType == QuestType.VIP_LEVEL_REACH then
        return zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).vipLevel
    elseif questType == QuestType.SUMMONER_EVOLVE then
        return zg.playerData:GetMethod(PlayerDataMethod.SUMMONER).star
    elseif questType == QuestType.TOWER_STAGE_PASS then
        return zg.playerData:GetMethod(PlayerDataMethod.TOWER).levelCurrent
    else
        XDebug.Error(string.format("Missing QuestType: %s", tostring(questType)))
        return 0
    end
end

--- @param listQuestData List|QuestUnitInBound
function QuestDataInBound.SortQuestByData(listQuestData)
    local count = listQuestData:Count()
    local index = 1
    for _ = 1, count do
        --- @type QuestUnitInBound
        local questData = listQuestData:Get(index)
        if questData.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            listQuestData:RemoveByIndex(index)
            listQuestData:Insert(questData, 1)
        elseif questData.questState == QuestState.COMPLETED then
            listQuestData:RemoveByIndex(index)
            listQuestData:Insert(questData, count)
            index = index - 1
        end
        index = index + 1
    end
    return listQuestData
end

--- @param listQuestData List|QuestUnitInBound
function QuestDataInBound.SortQuestByQuestId(listQuestData)
    local count = listQuestData:Count()
    for i = 1, count do
        for j = i + 1, count do
            --- @type QuestUnitInBound
            local questI = listQuestData:Get(i)
            --- @type QuestUnitInBound
            local questJ = listQuestData:Get(j)
            local requireI = questI.questId
            local requireJ = questJ.questId
            if requireJ < requireI then
                local tmp = questI
                listQuestData:RemoveByIndex(i)
                listQuestData:Insert(questJ, i)
                listQuestData:RemoveByIndex(j)
                listQuestData:Insert(tmp, j)
            end
        end
    end
    return listQuestData
end

--- @param listQuestData List|QuestUnitInBound
--- @param questId number
--- @param opCode OpCode
function QuestDataInBound.SetCompleteQuestById(listQuestData, questId, opCode)
    for i = 1, listQuestData:Count() do
        --- @type QuestUnitInBound
        local questData = listQuestData:Get(i)
        if questData.questId == questId then
            questData.questState = QuestState.COMPLETED
            break
        end
    end
    local questDataInBound = zg.playerData:GetQuest()
    if opCode == OpCode.QUEST_DAILY_CLAIM or opCode == OpCode.QUEST_TREE_CLAIM then
        questDataInBound:CheckLocalNotification()
    elseif opCode == OpCode.QUEST_ACHIEVEMENT_CLAIM then
        questDataInBound.achievementQuestInBound:CheckNotification()
    else
        questDataInBound:CheckLocalNotification()
    end
end

--- @param timeNotify number
function QuestDataInBound:IsQuestNotifyTimeStepAvailable(timeNotify)
    if self.lastTimeUpdateNotify == nil then
        return true
    end
    return (timeNotify - self.lastTimeUpdateNotify) > 3
end

--- @return string
--- @param groupId number
function QuestDataInBound.GetAchievementGroupNameById(groupId)
    return LanguageUtils.LocalizeCommon("achievement_tittle_group_" .. groupId)
end

--- @return string
--- @param groupId number
function QuestDataInBound.GetQuestTreeTittleByGroupId(groupId)
    return LanguageUtils.LocalizeCommon("quest_tree_tittle_group_" .. groupId)
end

--- @return string
--- @param questId number
function QuestDataInBound.GetLocalizeQuestTreeName(questId)
    return LanguageUtils.LocalizeQuestTreeName("quest_tree_" .. questId)
end

--- @return number
--- @param x QuestUnitInBound
--- @param y QuestUnitInBound
function QuestDataInBound.SortQuestByGroupId(x, y)
    if y.groupId > x.groupId then
        return -1
    else
        return 1
    end
end

--- @param obj QuestItemView
--- @param dataIndex number
function QuestDataInBound.OnCreateQuestItem(obj, dataIndex, listQuestData, questDataConfig, onClaimClick, onGoClick,
                                            extraReward)
    --- @type QuestUnitInBound
    local questData = listQuestData:Get(dataIndex)
    if questData == nil then
        return
    end

    local questId = questData.questId
    --- @type QuestElementConfig
    local questElementConfig = questDataConfig:Get(questId)

    local questType = questElementConfig:GetQuestType()
    if questData.number == QuestConfig.GetFromPlayerData then
        if questType == QuestType.SUMMONER_LEVEL_UP then
            questData.number = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
        elseif questType == QuestType.SUMMONER_EVOLVE then
            questData.number = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER).star
        elseif questType == QuestType.CAMPAIGN_STAGE_PASS then
            questData.number = zg.playerData:GetCampaignData().stageCurrent
            questElementConfig:GetMainRequirementTarget(1)
            if questData.number == questElementConfig:GetMainRequirementTarget() then
                questData.number = 1
            else
                questData.number = 0
            end
        elseif questType == QuestType.TOWER_STAGE_PASS then
            questData.number = zg.playerData:GetMethod(PlayerDataMethod.TOWER).levelCurrent
        elseif questType == QuestType.VIP_LEVEL_REACH then
            questData.number = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).vipLevel
        end
    end
    if questType == QuestType.DAILY_QUEST_COMPLETE then
        local completedQuest = 0
        for k = 1, listQuestData:Count() do
            --- @type QuestUnitInBound
            if listQuestData:Get(k).quest_state == QuestState.COMPLETED then
                completedQuest = completedQuest + 1
            end
        end
        questElementConfig:OverrideMainReq(listQuestData:Count() - 1 - 1)
    end
    local recordProgress = nil
    if QuestDataInBound.IsConsecutiveQuest(questType) then
        recordProgress = zg.playerData:GetQuest():GetRecordProgressByKey(questElementConfig:GetKeyRecordProgress())
    end
    obj:SetData(questElementConfig, questData, recordProgress, extraReward)

    if questData.questState ~= QuestState.COMPLETED
            and questData.questState ~= QuestState.LOCKED then
        obj:AddClaimListener(function()
            if onClaimClick ~= nil then
                onClaimClick(questData.questId)
            end
        end)
        obj:AddGoListener(function()
            if onGoClick ~= nil then
                onGoClick(questData.questId, questElementConfig)
            end
        end)
    end
end

--- @param readInjectData boolean
function QuestDataInBound.RequestClaimQuest(opCode, id, onSuccess, readInjectData)
    local onReceived = function(result)
        --- @type List
        local rewardList
        local questId
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            questId = buffer:GetInt()
            rewardList = NetworkUtils.GetRewardInBoundList(buffer)
            if readInjectData then
                rewardList = NetworkUtils.AddInjectRewardInBoundList(buffer, rewardList)
            end
        end
        local onRequestSuccess = function()
            if onSuccess ~= nil then
                onSuccess(rewardList)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onRequestSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(opCode, UnknownOutBound.CreateInstance(PutMethod.Int, id), onReceived)
end

--- @param ids List
--- @param readInjectData boolean
function QuestDataInBound.RequestClaimMultiQuest(opCode, ids, onSuccess, readInjectData)
    require("lua.client.core.network.event.eventNewServerWeek.MultiQuestIdOutBound")
    local multiQuestIdOutBound = MultiQuestIdOutBound(ids)
    local onReceived = function(result)
        --- @type List
        local rewardList
        local questId
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            --questId = buffer:GetInt()
            rewardList = NetworkUtils.GetRewardInBoundList(buffer)
            if readInjectData then
                rewardList = NetworkUtils.AddInjectRewardInBoundList(buffer, rewardList)
            end
        end
        local onRequestSuccess = function()
            if onSuccess ~= nil then
                onSuccess(rewardList)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onRequestSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(opCode, multiQuestIdOutBound, onReceived)
end

--- @param readInjectData boolean
function QuestDataInBound.RequestClaimAllQuestReturnListQuestId(opCode, id, onSuccess, readInjectData)
    local onReceived = function(result)
        --- @type List
        local rewardList
        --- @type List
        local listQuestId = List()
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            for _ = 1, buffer:GetByte(), 1 do
                listQuestId:Add(buffer:GetInt())
            end
            rewardList = NetworkUtils.GetRewardInBoundList(buffer)
            if readInjectData then
                rewardList = NetworkUtils.AddInjectRewardInBoundList(buffer, rewardList)
            end
        end
        local onRequestSuccess = function()
            if onSuccess ~= nil then
                onSuccess(rewardList, listQuestId)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onRequestSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    local outBound
    if id then
        outBound = UnknownOutBound.CreateInstance(PutMethod.Int, id)
    else
        outBound = nil
    end
    NetworkUtils.Request(opCode, outBound, onReceived)
end

--- @param questId number
--- @param questElementConfig QuestElementConfig
--- @param onGoQuest function
function QuestDataInBound.GoQuest(questId, questElementConfig, onGoQuest, isHideMain)
    if questElementConfig == nil then
        return
    end
    --- @type FeatureType
    local feature, data = questElementConfig:GetFeatureMappingData()
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(feature) == false then
        return
    end
    FeatureMapping.GoToFeature(feature, isHideMain, onGoQuest, data)
end

--- @return number
--- @param questId number
function QuestDataInBound.GetQuestTreeIdByQuestId(questId)
    return math.floor(questId / 100)
end

--- @return List
--- @param buffer UnifiedNetwork_ByteBuf
--- @param questConfig Dictionary<number, QuestElementConfig>
function QuestDataInBound.ReadListQuestFromBuffer(buffer, questConfig, size)
    local listQuestData = List()
    local sizeOfList = size or buffer:GetShort()
    local previousQuestId
    for _ = 1, sizeOfList do
        --- @type QuestUnitInBound
        local unit = QuestUnitInBound()
        unit:ReadBuffer(buffer)
        previousQuestId = unit.questId
        --- @type QuestElementConfig
        local questElementConfig = questConfig:Get(unit.questId)
        if questElementConfig ~= nil then
            local questType = questElementConfig:GetQuestType()
            unit.number = QuestDataInBound.GetQuestProgressDataFromBuffer(buffer, questType)
            unit.config = questElementConfig
            listQuestData:Add(unit)
        else

        end
    end
    return listQuestData
end

--- @return List
--- @param buffer UnifiedNetwork_ByteBuf
--- @param questConfig Dictionary<number, QuestElementConfig>
function QuestDataInBound.ReadListDailyQuestFromBuffer(buffer, questConfig, size)
    local listQuestData = List()
    local sizeOfList = size or buffer:GetShort()
    for _ = 1, sizeOfList do
        --- @type QuestUnitInBound
        local unit = QuestUnitInBound()
        unit:ReadBuffer(buffer)
        --- @type QuestElementConfig
        local questElementConfig = questConfig:Get(unit.questId)
        if questElementConfig ~= nil then
            local questType = questElementConfig:GetQuestType()
            unit.number = QuestDataInBound.GetQuestProgressDataFromBuffer(buffer, questType)
            unit.config = questElementConfig
            listQuestData:Add(unit)
        else
            print("WTF???????????????????????????", " daily not found quest unit ", unit.questId)
        end
    end
    return listQuestData
end

--- @param questId number
--- @param questDataType QuestDataType
--- @param questElementConfig QuestElementConfig
function QuestDataInBound.RequestSelectedQuestData(questId, questDataType, questElementConfig, callback)
    local onReceived = function(result)
        --- @type QuestUnitInBound
        local loadedData = QuestUnitInBound()
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            loadedData:ReadBuffer(buffer)
            loadedData.number = QuestDataInBound.GetQuestProgressDataFromBuffer(buffer, questElementConfig:GetQuestType())
        end
        local onSuccess = function()
            callback(loadedData)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, nil)
    end
    NetworkUtils.Request(OpCode.QUEST_DATA_GET,
            UnknownOutBound.CreateInstance(PutMethod.Int, questId, PutMethod.Byte, questDataType),
            onReceived, false)
end

--- @param questType QuestType
function QuestDataInBound.IsConsecutiveQuest(questType)
    return questType == QuestType.LOGIN_CONSECUTIVE
            or questType == QuestType.DAILY_QUEST_COMPLETE_CONSECUTIVE
            or questType == QuestType.GUILD_BOSS_CHALLENGE_CONSECUTIVE
            or questType == QuestType.HAND_OF_MIDAS_USE_CONSECUTIVE
            or questType == QuestType.CASINO_SPIN_HERO_FRAGMENT_WITHOUT
            or questType == QuestType.CASINO_SPIN_MONEY_WITHOUT
            or questType == QuestType.PROPHET_TREE_SUMMON_WITHOUT
            or questType == QuestType.SUMMON_HERO_WITHOUT
end

--- @param listQuestData List
function QuestDataInBound.HasDoneNotClaimQuest(listQuestData)
    if (listQuestData == nil) then
        return false
    end
    --- @param v QuestUnitInBound
    for k, v in pairs(listQuestData:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
    return false
end

function QuestDataInBound.FilterHiddenQuest(listQuestData)
    local totalHidden = 0
    --- @type QuestUnitInBound
    local questData
    local questCount = listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN or questUnitData.questState == QuestState.LOCKED then
            listQuestData:RemoveByIndex(i)
            totalHidden = totalHidden + 1
        end
    end
    if questData ~= nil then
        questData.number = questData.number - totalHidden
    end
    return listQuestData
end
