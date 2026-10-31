require "lua.client.core.network.dungeon.DungeonBindingSmashInBound"
require "lua.client.core.network.dungeon.DungeonBindingHeroOutBound"
require "lua.client.core.network.playerData.common.BattleResultInBound"
require "lua.client.core.network.dungeon.DungeonRewardInBound"

--- @class DungeonRequest
DungeonRequest = Class(DungeonRequest)

--- @return void
--- @param heroList List
--- @param callback function
function DungeonRequest.BindingHero(heroList, callback)
    local onReceived = function(result)
        local onFailed = function(logicCode)
            if logicCode == 5 then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("insert_least_one_hero"))
            else
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, DungeonBindingSmashInBound, callback, onFailed)
    end
    NetworkUtils.Request(OpCode.DUNGEON_HERO_BIND, DungeonBindingHeroOutBound(heroList), onReceived)
end

--- @return void
--- @param itemId number id pack shop in smash shop
function DungeonRequest.BuySmashShop(sellerId, itemId)
    assert(itemId)
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            local id = buffer:GetByte()
            RxMgr.buyCompleted:Next(true)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, nil, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.DUNGEON_SMASH_SHOP_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, sellerId, PutMethod.Byte, itemId), onReceived)
end

--- @return void
--- @param callback function
function DungeonRequest.Challenge(heroIndex, stage, callback, onFailed)
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            --- @type DungeonInBound
            local server = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
            server:ReadBufferChallenge(buffer)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, callback, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.DUNGEON_CHALLENGE, UnknownOutBound.CreateInstance(PutMethod.Byte, heroIndex, PutMethod.Int, stage), onReceived, onFailed)
end

--- @return void
--- @param heroIndexUse number
--- @param success function
function DungeonRequest.UseActiveBuff(heroIndexUse, activeBuffId, success, failed)
    NetworkUtils.RequestAndCallback(
            OpCode.DUNGEON_ACTIVE_BUFF_USE,
            UnknownOutBound.CreateInstance(PutMethod.Byte, heroIndexUse, PutMethod.Short, activeBuffId),
            success, failed)
end

--- @return void
--- @param isBuy boolean buy or skip
--- @param callback function
function DungeonRequest.BuyShop(isBuy, callback)
    NetworkUtils.RequestAndCallback(
            OpCode.DUNGEON_SHOP_BUY,
            UnknownOutBound.CreateInstance(PutMethod.Bool, isBuy),
            callback,
            SmartPoolUtils.LogicCodeNotification
    )
end

--- @param stage number
--- @param callback function
function DungeonRequest.GenerateBuff(stage, callback)
    local rewardList
    NetworkUtils.RequestAndCallback(
            OpCode.DUNGEON_BUFF_GENERATE,
            UnknownOutBound.CreateInstance(PutMethod.Short, stage),
            function()
                assert(rewardList)
                callback(rewardList)
            end,
            SmartPoolUtils.LogicCodeNotification,
            function(buffer)
                local dungeonReward = DungeonRewardInBound()
                dungeonReward:ReadBuffer(buffer)
                rewardList = dungeonReward.rewardList
            end
    )
end

--- @param stage number
--- @param callback function
function DungeonRequest.PickBuff(stage, buffIndex, callback)
    assert(buffIndex > 0)
    NetworkUtils.RequestAndCallback(
            OpCode.DUNGEON_BUFF_PICK,
            UnknownOutBound.CreateInstance(PutMethod.Short, stage, PutMethod.Byte, buffIndex - 1),
            callback,
            SmartPoolUtils.LogicCodeNotification
    )
end