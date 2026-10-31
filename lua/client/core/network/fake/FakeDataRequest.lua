require "lua.client.core.network.fake.FakeDataMethod"
require "lua.client.scene.ui.home.uiFormation.UIFormationTeamData"

--- @class FakeDataRequest
FakeDataRequest = Class(FakeDataRequest)

--- @return void
function FakeDataRequest:Ctor()

end

--- @return void
---@param id number
---@param number number
function FakeDataRequest.FakeHeroFragment(id, number)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_HERO_FRAGMENT)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.HERO_FRAGMENT_COLLECTION)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Int, id, PutMethod.Short, number), callback, false)
end

--- @return void
---@param id number
---@param star number
---@param number number
function FakeDataRequest.FakeHero(id, star, level, number)
    local bitmask = 0
    if id ~= nil and id > 0 then
        bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_HERO)
        local callback = function(result)
            local onSuccess = function()
                XDebug.Log("Fake success")
                PlayerDataRequest.Request(PlayerDataMethod.HERO_COLLECTION)
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                PutMethod.Long, bitmask, PutMethod.Int, id, PutMethod.Byte, star, PutMethod.Int, level, PutMethod.Short, number), callback, false)
    else
        bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_AVAILABLE_HERO)
        local callback = function(result)
            local onSuccess = function()
                XDebug.Log("Fake success")
                PlayerDataRequest.Request(PlayerDataMethod.HERO_COLLECTION)
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                PutMethod.Long, bitmask, PutMethod.Byte, star, PutMethod.Int, level), callback, false)
    end
end

--- @return void
---@param id number
---@param number number
function FakeDataRequest.FakeItem(id, number)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_ITEM)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.ITEM_COLLECTION)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Int, id, PutMethod.Short, number), callback, false)
end

--- @return void
---@param id number
---@param number number
function FakeDataRequest.FakeArtifact(id, number)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_ARTIFACT)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.ITEM_COLLECTION)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Int, id, PutMethod.Short, number), callback, false)
end

--- @return void
---@param id number
---@param number number
function FakeDataRequest.FakeSkin(id, number)
    XDebug.Log(id .. "Fake skin" .. number)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_SKIN)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.ITEM_COLLECTION)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Int, id, PutMethod.Short, number), callback, false)
end

--- @return void
---@param id number
---@param number number
function FakeDataRequest.FakeSkinFragment(id, number)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_SKIN_FRAGMENT)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.ITEM_COLLECTION)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Int, id, PutMethod.Short, number), callback, false)
end

--- @return void
function FakeDataRequest.FakeClearSubscription()
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.CLEAR_SUBSCRIPTION_PACK)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.IAP)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask), callback, false)
end

--- @return void
function FakeDataRequest.FakeClearArenaPass()
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.CLEAR_ARENA_PASS_PURCHASE)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Clear Arena pass success")
            zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_ARENA_PASS).lastTimeRequest = nil
            RxMgr.notificationEventIap:Next()
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask), callback, false)
end

--- @return void
function FakeDataRequest.FakeClearDailyQuestPass()
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.CLEAR_DAILY_QUEST_PASS_PURCHASE)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Clear Daily Quest pass success")
            zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_DAILY_QUEST_PASS).lastTimeRequest = nil
            RxMgr.notificationEventIap:Next()
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask), callback, false)
end

--- @return void
function FakeDataRequest.FakeClearProgressGroup()
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.CLEAR_PROGRESS_GROUP)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.IAP)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask), callback, false)
end

--- @return void
---@param id number
---@param number number
function FakeDataRequest.FakeArtifactFragment(id, number)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_ARTIFACT_FRAGMENT)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.ITEM_COLLECTION)
        end
        local onFailed = function(logicCode)
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Int, id, PutMethod.Short, number), callback, false)
end

--- @return void
---@param id number
---@param number number
function FakeDataRequest.FakeMoney(id, number)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.SET_MONEY)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            InventoryUtils.Add(ResourceType.Money, id, -InventoryUtils.GetMoney(id) + number)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Byte, id, PutMethod.Long, number), callback, false)
end

function FakeDataRequest.FakeABTest(_key, _id)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ABTEST_CONFIG)
    local callback = function(result)
        local onSuccess = function()
            zg.playerData:SetABTesting(_key, _id)
            if _key == FirebaseRemoteConfigKey.Campaign then
                ResourceMgr.GetCampaignDataConfig():InitData(_id)
                XDebug.Log(string.format("Fake campaign ABTest Data %s", _id))
            elseif _key == FirebaseRemoteConfigKey.CampaignReward then
                ResourceMgr.GetCampaignRewardConfig():InitData(_id)
                XDebug.Log(string.format("Fake campaign reward ABTest Data %s", _id))
            elseif _key == FirebaseRemoteConfigKey.ProgressPack then
                ResourceMgr.GetPurchaseConfig():GetCashShop():InitProgressPack(_id)
                XDebug.Log(string.format("Fake flash sale ABTest Data %s", _id))
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.String, _key, PutMethod.Int, _id), callback, false)
end

--- @return void
---@param id number
---@param number number
function FakeDataRequest.FakeResource(type, id, number)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.RESOURCE)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            InventoryUtils.Add(type, id, number)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Int, type, PutMethod.Int, id, PutMethod.Int, number, PutMethod.Int, 0), callback, false)
end

--- @return void
---@param id number
---@param number number
function FakeDataRequest.FakeQuickBattleTicket(id, number, success)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_CAMPAIGN_QUICK_BATTLE_TICKET)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.CAMPAIGN)
            if success ~= nil then
                success()
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Int, id, PutMethod.Short, number), callback, false)
end

--- @return void
---@param id number
function FakeDataRequest.FakeVip(id)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.SET_VIP)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.VIP)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Byte, id), callback, false)
end

--- @return void
---@param id number
function FakeDataRequest.FakeProgressGroupId(id, callbackSuccess)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_PROGRESS_GROUP)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
            end)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Int, id), callback, false)
end

--- @return void
---@param lv number
---@param star number
function FakeDataRequest.FakeSummoner(lv, star)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.SET_SUMMONER_INFO)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.BASIC_INFO, PlayerDataMethod.SUMMONER)
            zg.playerData:UpdatePlayerInfoOnOthersUI("level", lv)
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Byte, star, PutMethod.Short, lv), callback, false)
end

--- @return void
function FakeDataRequest.FakeResetSummon(summonType, time)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.DECREASE_SUMMON_TIME)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.SUMMON)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Byte, summonType, PutMethod.Int, time), callback, false)
end

--- @return void
function FakeDataRequest.FakeDungeonTime(isOnTime, minute)
    --local bitmask = 0
    --bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.SET_DUNGEON_ON_TIME)
    --local callback = function(result)
    --    local onSuccess = function()
    --        XDebug.Log("Fake success")
    --        PlayerDataRequest.Request(PlayerDataMethod.DUNGEON_DATA)
    --    end
    --    local onFailed = function()
    --        XDebug.Log("Fake Failed")
    --    end
    --    NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    --end
    --NetworkUtils.Request(OpCode.TEST_FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Bool, isOnTime, PutMethod.Int, minute), callback)
end

--- @return void
function FakeDataRequest.FakeResetDungeon(resetLevel)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.RESET_DUNGEON)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.DUNGEON)
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Short, resetLevel), callback, false)
end

--- @return void
function FakeDataRequest.FakeLevelTower(level)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.RESET_TOWER)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.TOWER)
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Short, level), callback, false)
end

--- @return void
---@param refreshTime number
---@param lastLoginTime number
---@param isReset boolean
function FakeDataRequest.FakeDayTime(serverTime, refreshTime, lastLoginTime, isReset)
    --local bitmask = BitUtils.TurnOn(0, FakeDataMethod.SET_NEW_DAY_TIME)
    --local callback = function(result)
    --    local onSuccess = function()
    --        XDebug.Log("Fake success")
    --        local timeOrigin
    --        if isReset == false then
    --            local deltaTime = refreshTime - serverTime
    --            XDebug.Log("delta Time: " .. deltaTime)
    --            zg.timeMgr:SetServerTime(serverTime + zg.timeMgr:GetRemainingTime(serverTime) - deltaTime)
    --        else
    --            timeOrigin = 0
    --        end
    --    end
    --    local onFailed = function()
    --        XDebug.Log("Fake Failed")
    --    end
    --    NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    --end
    --XDebug.Log("bitmask" .. bitmask)
    --NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
    --        PutMethod.Long, bitmask, PutMethod.Long, refreshTime, PutMethod.Long, lastLoginTime, PutMethod.Bool, isReset), callback, false)
end

--- @return void
function FakeDataRequest.FakeResetBlackMarket()
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.REFRESH_MARKET)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.MARKET)
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask), callback, false)
end

--- @return void
---@param stage number
function FakeDataRequest.FakeResetCampaign(stage)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.RESET_CAMPAIGN)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.CAMPAIGN)
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Int, stage), callback, false)
end

--- @return void
---@param elo number
function FakeDataRequest.FakeElo(elo)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.FAKE_ELO)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.ARENA)
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Short, elo), callback, false)
end

--- @return void
---@param elo number
function FakeDataRequest.FakeTeamElo(elo)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.FAKE_TEAM_ELO)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.ARENA_TEAM)
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Short, elo), callback, false)
end

--- @return void
function FakeDataRequest.FakeClearItems()
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.CLEAR_ALL_ITEMS)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.ITEM_COLLECTION)
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask), callback, false)
end

--- @return void
function FakeDataRequest.FakeClearHeroes(success)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.CLEAR_ALL_HEROES)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.HERO_COLLECTION)
            if success ~= nil then
                success()
            end
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask), callback, false)
end

--- @return void
function FakeDataRequest.FakeResetSummoner()
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.RESET_SUMMONER)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.Request(PlayerDataMethod.SUMMONER)
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask), callback, false)
end

--- @return void
function FakeDataRequest.FakeScoutBoss(callbackSuccess)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.RESET_FRIEND_SCOUT_BOSS_TIME)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.FRIEND }, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
            end)
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask), callback, false)
end

--- @return void
---@param heroFoodType HeroFoodType
---@param star number
---@param number number
function FakeDataRequest.FakeHeroFood(heroFoodType, star, number)
    local bitmask = BitUtils.TurnOn(0, FakeDataMethod.ADD_HERO_FOOD)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.HERO_EVOLVE_FOOD })
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    XDebug.Log("bitmask" .. bitmask)
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
            PutMethod.Long, bitmask, PutMethod.Byte, heroFoodType, PutMethod.Byte, star, PutMethod.Int, number), callback, false)
end

--- @return void
---@param groupId number
function FakeDataRequest.FakeGrowthPack(groupId)
    print("Fake Growth pack ", groupId)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_GROWTH_PACK)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP })
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    XDebug.Log("bitmask " .. bitmask)
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Int, groupId), callback, false)
end

--- @return void
---@param lv number
function FakeDataRequest.FakeGuildLevel(lv)
    print("Fake Growth pack ", lv)
    local bitmask = 0
    bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.GUILD_LEVEL)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("Fake success")
            --PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP })
        end
        local onFailed = function()
            XDebug.Log("Fake Failed")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    XDebug.Log("bitmask " .. bitmask)
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Byte, lv), callback, false)
end

--- @return void
function FakeDataRequest.FakeTutorial(step, success, summon)
    require("lua.client.core.network.tutorial.TutorialOutBound")
    --local bitmask = BitUtils.TurnOn(0, FakeDataMethod.FAKE_TUTORIAL)
    --local callback = function(result)
    --    local onSuccess = function()
    --        XDebug.Log("FakeTutorial success")
    if zg.playerData:GetMethod(PlayerDataMethod.TUTORIAL) ~= nil then
        ---@type TutorialOutBound
        local outBound = TutorialOutBound()
        ---@param v TutorialBase
        for i, v in ipairs(TutorialData.GetListTutorial():GetItems()) do
            local stepId = v:GetStepId()
            if stepId ~= TutorialHeroFragment.stepId and stepId ~= TutorialEvolveSummoner.stepId and stepId ~= TutorialSwitchSummoner.stepId then
                outBound:AddStep(stepId)
                zg.playerData:GetMethod(PlayerDataMethod.TUTORIAL).listStepTutComplete:Add(stepId)
            end
        end
        NetworkUtils.Request(OpCode.TUTORIAL_STEP_SET, outBound)
    end
    if UIBaseView.IsActiveTutorial() then
        PopupMgr.HidePopup(UIPopupName.UITutorial)
    end
    --    end
    --    local onFailed = function()
    --        XDebug.Log("FakeTutorial Failed")
    --    end
    --    NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    --end
    --
    --NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
    --        PutMethod.Long, bitmask, PutMethod.Byte, 3), callback, false)
end

--- @return void
---@param time number
function FakeDataRequest.FakeSpeedUpTime(time, onSuccess)
    time = time or 0
    local bitmask = BitUtils.TurnOn(0, FakeDataMethod.SPEED_UP_TIME)
    local callback = function(result)
        local onRequestSuccess = function()
            print("FakeSpeedUpTime: " .. time)
            if onSuccess ~= nil then
                onSuccess()
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onRequestSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Long, time), callback, false)
end

--- @return void
---@param time number
function FakeDataRequest.FakeOfflineTime(time, onSuccess)
    local bitmask = BitUtils.TurnOn(0, FakeDataMethod.OFFLINE_TIME)
    local callback = function(result)
        local onRequestSuccess = function()
            XDebug.Log("OFFLINE Time success")
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.COMEBACK }, onSuccess)
        end
        NetworkUtils.ExecuteResult(result, nil, onRequestSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    XDebug.Log("time in second: " .. time)
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Long, time), callback, false)
end

--- @return void
---@param day number
function FakeDataRequest.FakeDomainChallengeDay(day, onSuccess)
    local bitmask = BitUtils.TurnOn(0, FakeDataMethod.DOMAIN_CHALLENGE_DAY)
    local callback = function(result)
        local onRequestSuccess = function()
            XDebug.Log("DOMAINS CHALLENGE DAY success")
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.DOMAIN }, onSuccess)
        end
        NetworkUtils.ExecuteResult(result, nil, onRequestSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Int, day), callback, false)
end

--- @return void
--- @param summonType SummonType
--- @param isSingleSummon boolean
--- @param isUseGem boolean
function FakeDataRequest.Summon(summonType, isSingleSummon, isUseGem, callbackSuccess, callbackFailed)
    --TouchUtils.Disable()
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            SummonResultInBound(buffer)
        end

        local onSuccess = function()
            if callbackSuccess then
                callbackSuccess()
            end
            --XDebug.Log("Summon hero success")
        end
        local onFailed = function(error)
            SmartPoolUtils.LogicCodeNotification(error)
            if callbackFailed then
                callbackFailed()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.SUMMON_HERO, UnknownOutBound.CreateInstance(
            PutMethod.Byte, summonType, PutMethod.Bool, isSingleSummon, PutMethod.Bool, isUseGem), onReceived, false)
end

function FakeDataRequest.FakeFirstPurchase(packId)
    local bitmask = BitUtils.TurnOn(0, FakeDataMethod.FAKE_ADD_FIRST_TIME_PACK)
    local callback = function(result)
        local onSuccess = function()
            XDebug.Log("FAKE_ success")
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Int, packId), callback, false)
end

function FakeDataRequest.FakeJoinGuild(name, range, guildId)
    local log = ""
    local count = 0
    local split = range:Split("-")
    local x = tonumber(split[1])
    local y = tonumber(split[2])
    ---@type Job
    local jobMulti = nil
    for i = x, y do
        local userName = name .. i
        local pass = SHA2.shaHex256("123456")
        local logIn = Job(function(success, fail)
            XDebug.Log("login" .. i)
            LoginUtils.LoginByUPHash(userName, pass, success, fail)
        end)

        local fakeCampaign = Job(function(success, fail)
            local bitmask = 0
            bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.RESET_CAMPAIGN)
            local callback = function(result)
                NetworkUtils.ExecuteResult(result, nil, success, fail)
            end
            NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Int, 505005), callback, false)
        end)

        local joinGuid = Job(function(success, fail)
            local callback = function(result)
                NetworkUtils.ExecuteResult(result, nil, success, fail)
            end
            NetworkUtils.Request(OpCode.GUILD_REQUEST_JOIN, UnknownOutBound.CreateInstance(PutMethod.Int, guildId), callback, false)
        end)

        ---@type Job
        local job = logIn .. fakeCampaign .. joinGuid
        local jobAcc = Job(function(success, fail)
            job:Complete(function()
                count = count + 1
                log = log .. "," .. i
                success()
            end, function()
                success()
            end)
        end)
        if jobMulti == nil then
            jobMulti = jobAcc
        else
            jobMulti = jobMulti .. jobAcc
        end
    end

    jobMulti:Complete(function()
        PopupUtils.ShowPopupNotificationOK(string.format("REGISTER %s : %s", count, log))
    end)
end

function FakeDataRequest.FakeRegisterGuildWar(x, y, clusterId)
    local log = ""
    local count = 0
    ---@type Job
    local jobMulti = nil
    for i = x, y do
        local userName = "test" .. i
        local pass = SHA2.shaHex256("123456")
        local logIn = Job(function(success, fail)
            XDebug.Log("login" .. i)
            LoginUtils.LoginByUPHash(userName, pass, success, fail)
        end)

        local serverList = Job(function(success, fail)
            XDebug.Log("serverList ")
            require "lua.client.core.network.serverList.ServerListInBound"
            ServerListInBound.Request(success, fail)
        end)

        local switchServer = Job(function(success, fail)
            if clusterId ~= nil then
                XDebug.Log("switchServer clusterId " .. clusterId)
                ---@type List
                local listServerId = zg.playerData:GetServerListInBound():GetServers(clusterId)
                local serverId = nil
                ---@type PlayerServerListInBound
                local serverList = zg.playerData:GetMethod(PlayerDataMethod.SERVER_LIST)
                if serverList ~= nil then
                    ---@param v PlayerServerData
                    for i, v in ipairs(serverList.listPlayer:GetItems()) do
                        if listServerId:IsContainValue(v.serverId) then
                            serverId = v.serverId
                            break
                        end
                    end
                end
                if serverId ~= nil then
                    XDebug.Log("switchServer serverId " .. serverId)
                    LoginUtils.SwitchServer(serverId, success)
                else
                    fail()
                end
            else
                success()
            end
        end)

        local requestPlayerData = Job(function(success, fail)
            XDebug.Log("requestPlayerData" .. i)
            PlayerDataRequest.RequestAllData(success, fail, false)
        end)
        local registerGuildWar = Job(function(success, fail)
            local team = zg.playerData:GetFormationInBound().teamDict:Get(GameMode.GUILD_WAR)
            if team == nil then
                team = zg.playerData:GetFormationInBound().teamDict:Get(GameMode.CAMPAIGN)
            end
            if team ~= nil then
                XDebug.Log("registerGuildWar" .. i)
                UIFormationTeamData.CreateByTeamFormationInBound(team)
                NetworkUtils.RequestAndCallback(OpCode.GUILD_WAR_MEMBER_REGISTER, BattleFormationOutBound(UIFormationTeamData.CreateByTeamFormationInBound(team)),
                        success, fail)
            else
                if fail ~= nil then
                    fail()
                end
            end
        end)
        ---@type Job
        local job = logIn .. requestPlayerData .. serverList .. switchServer .. registerGuildWar
        local jobAcc = Job(function(success, fail)
            job:Complete(function()
                count = count + 1
                log = log .. "," .. i
                success()
            end, function()
                success()
            end)
        end)
        if jobMulti == nil then
            jobMulti = jobAcc
        else
            jobMulti = jobMulti .. jobAcc
        end
    end

    jobMulti:Complete(function()
        PopupUtils.ShowPopupNotificationOK(string.format("REGISTER %s : %s", count, log))
    end)
end

function FakeDataRequest.FakeRegisterAcc(name, range, clusterId)
    local log = ""
    local count = 0
    ---@type Job
    local jobMulti = nil
    local split = range:Split("-")
    local x = tonumber(split[1])
    local y = tonumber(split[2])
    local server = 1

    local requestPlayerData = Job(function(success, fail)
        XDebug.Log("requestPlayerData")
        PlayerDataRequest.RequestAllData(success, fail, false)
    end)

    local serverList = Job(function(success, fail)
        XDebug.Log("serverList ")
        require "lua.client.core.network.serverList.ServerListInBound"
        ServerListInBound.Request(success, fail)
    end)

    local switchServer = Job(function(success, fail)
        if clusterId ~= nil then
            XDebug.Log("switchServer clusterId " .. clusterId)
            ---@type List
            local listServerId = zg.playerData:GetServerListInBound():GetServers(clusterId)
            server = listServerId:Get(1)
            success()
        else
            success()
        end
    end)

    for i = x, y do
        local userName = name .. i
        --local pass = SHA2.shaHex256("123456")
        local logIn = Job(function(success, fail)
            XDebug.Log("login" .. i)
            LoginUtils.RegisterByUP(userName, "123456", server, success, fail)
        end)

        local changeName = Job(function(onSuccess, onFailed)
            NetworkUtils.RequestAndCallback(OpCode.PLAYER_NAME_CHANGE, UnknownOutBound.CreateInstance(PutMethod.String, string.format("%s_%s", userName, clusterId)), onSuccess, onSuccess)
        end)

        local summon = Job(function(onSuccess, onFailed)
            local bitmask = 0
            bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.ADD_HERO)
            NetworkUtils.RequestAndCallback(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                    PutMethod.Long, bitmask, PutMethod.Int, 20003, PutMethod.Byte, 5, PutMethod.Int, 1, PutMethod.Short, 5), onSuccess, onSuccess)
        end)

        local requestPlayerData = Job(function(success, fail)
            PlayerDataRequest.RequestAllData(success, fail, false)
        end)

        local campaign = Job(function(success, fail)
            local teamFormation = TeamFormationInBound()
            teamFormation:SetDefaultTeam()
            ---@type List
            local listHero = InventoryUtils.Get(ResourceType.Hero)
            for i = 1, 1, -1 do
                ---@type HeroResource
                local heroResource = listHero:Get(i)
                teamFormation:AddHeroInventoryId(heroResource.inventoryId)
            end

            require "lua.client.scene.ui.home.uiFormation.UIFormationTeamData"
            require "lua.client.core.network.battleFormation.BattleFormationRequest"
            local uiFormationTeamData = UIFormationTeamData.CreateByTeamFormationInBound(teamFormation)
            BattleFormationRequest.BattleRequest(OpCode.CAMPAIGN_CHALLENGE, uiFormationTeamData, 101001, success, success)
        end)

        ---@type Job
        local job = logIn .. changeName .. summon .. requestPlayerData .. campaign
        local jobAcc = Job(function(success, fail)
            job:Complete(function()
                count = count + 1
                log = log .. "," .. i
                success()
            end, function()
                success()
            end)
        end)
        if jobMulti == nil then
            jobMulti = jobAcc
        else
            jobMulti = jobMulti .. jobAcc
        end
    end

    (requestPlayerData .. serverList .. switchServer .. jobMulti):Complete(function()
        PopupUtils.ShowPopupNotificationOK(string.format("REGISTER %s : %s", count, log))
    end)
end

function FakeDataRequest.FakeAddFriend(x, y, clusterId)
    local friendId = PlayerSettingData.playerId
    local log = ""
    local count = 0
    ---@type Job
    local jobMulti = nil
    for i = x, y do
        local userName = "test" .. i
        local pass = SHA2.shaHex256("123456")
        local logIn = Job(function(success, fail)
            XDebug.Log("login" .. i)
            LoginUtils.LoginByUPHash(userName, pass, success, fail)
        end)

        local serverList = Job(function(success, fail)
            XDebug.Log("serverList ")
            require "lua.client.core.network.serverList.ServerListInBound"
            ServerListInBound.Request(success, fail)
        end)

        local switchServer = Job(function(success, fail)
            if clusterId ~= nil then
                XDebug.Log("switchServer clusterId " .. clusterId)
                ---@type List
                local listServerId = zg.playerData:GetServerListInBound():GetServers(clusterId)
                local serverId = nil
                ---@type PlayerServerListInBound
                local serverList = zg.playerData:GetMethod(PlayerDataMethod.SERVER_LIST)
                if serverList ~= nil then
                    ---@param v PlayerServerData
                    for i, v in ipairs(serverList.listPlayer:GetItems()) do
                        if listServerId:IsContainValue(v.serverId) then
                            serverId = v.serverId
                            break
                        end
                    end
                end
                if serverId ~= nil then
                    XDebug.Log("switchServer serverId " .. serverId)
                    LoginUtils.SwitchServer(serverId, success)
                else
                    fail()
                end
            else
                success()
            end
        end)

        local requestPlayerData = Job(function(success, fail)
            XDebug.Log("requestPlayerData" .. i)
            PlayerDataRequest.RequestAllData(success, fail, false)
        end)
        local addFriend = Job(function(success, fail)
            NetworkUtils.RequestAndCallback(OpCode.FRIEND_REQUEST_ADD, UnknownOutBound.CreateInstance(PutMethod.Long, friendId),
                    success, fail)
        end)
        ---@type Job
        local job = logIn .. requestPlayerData .. serverList .. switchServer .. addFriend
        local jobAcc = Job(function(success, fail)
            job:Complete(function()
                count = count + 1
                log = log .. "," .. i
                success()
            end, function()
                success()
            end)
        end)
        if jobMulti == nil then
            jobMulti = jobAcc
        else
            jobMulti = jobMulti .. jobAcc
        end
    end

    jobMulti:Complete(function()
        PopupUtils.ShowPopupNotificationOK(string.format("Add %s : %s", count, log))
    end)
end

--- @return void
function FakeDataRequest.FakeIdleDefense(land, stage, onSuccess)
    local bitmask = BitUtils.TurnOn(0, FakeDataMethod.DEFENSE_MODE_IDLE_STAGE)
    local callback = function(result)
        local onRequestSuccess = function()
            XDebug.Log("Fake DEFENSE_MODE_IDLE_STAGE success")
            if onSuccess ~= nil then
                onSuccess()
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onRequestSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask, PutMethod.Short, land, PutMethod.Int, stage), callback, false)
end