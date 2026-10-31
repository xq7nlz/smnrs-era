require "lua.client.core.network.battleFormation.BattleFormationOutBound"

ArenaRequest = Class(ArenaRequest)

---@param dictFormation Dictionary
function ArenaRequest.SetFormationArenaTeam(dictFormation, callbackSuccess, callbackFailed)
    require("lua.client.core.network.arenaTeam.ArenaTeamFormationOutBound")
    NetworkUtils.RequestAndCallback(OpCode.ARENA_TEAM_FORMATION_SAVE, ArenaTeamFormationOutBound(dictFormation),
            function()
                for i, v in pairs(dictFormation:GetItems()) do
                    zg.playerData:GetFormationInBound().arenaTeamDict:Add(i, v)
                end
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
            end, callbackFailed, nil, true, true)
end

--- @return void
---@param resultBattleClose Subject
function ArenaRequest.RequestBattleArena(opponentId, attackerTeam, callbackSuccess, callbackFailed, isSkip, resultBattleClose)
    local callback = function(result)
        ---@type ArenaSingleChallengeInBound
        local arenaSingleChallengeInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            arenaSingleChallengeInBound = ArenaSingleChallengeInBound(buffer)
        end
        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess(arenaSingleChallengeInBound)
            end
            if InventoryUtils.CanUseFreeTurnArena() then
                InventoryUtils.Sub(ResourceType.Money, MoneyType.ARENA_FREE_CHALLENGE_TURN, 1)
            else
                InventoryUtils.Sub(ResourceType.Money, MoneyType.ARENA_TICKET, 1)
            end
            ---@type ArenaData
            local arenaData = zg.playerData:GetArenaData()
            if arenaData.arenaRecordDataInBound ~= nil then
                arenaData.arenaRecordDataInBound.needRequest = true
            end
            zg.playerData.rewardList = RewardInBound.GetItemIconDataList(arenaSingleChallengeInBound.arenaChallengeReward.rewards)
            zg.playerData:AddListRewardToInventory()

            if isSkip == true then
                ClientBattleData.SetCalculationBattle(function()
                    arenaSingleChallengeInBound.arenaChallengeReward.battleResult.seedInBound:Initialize()
                    zg.battleMgr:RunVirtualBattle(attackerTeam,
                            arenaSingleChallengeInBound.defender:CreateBattleTeamInfo(arenaSingleChallengeInBound.defender.playerLevel, BattleConstants.DEFENDER_TEAM_ID)
                    , GameMode.ARENA, nil, RunMode.FAST, arenaSingleChallengeInBound.arenaChallengeReward.battleResult.battleLog)
                end)

                local data = {}

                if arenaSingleChallengeInBound.arenaChallengeReward.battleResult.isWin then
                    data.callbackClose = function()
                        PopupMgr.HidePopup(UIPopupName.UIVictory)
                        if resultBattleClose ~= nil then
                            resultBattleClose:Next()
                        end
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIVictory, data)
                else
                    data.callbackClose = function()
                        PopupMgr.HidePopup(UIPopupName.UIDefeat)
                        if resultBattleClose ~= nil then
                            resultBattleClose:Next()
                        end
                    end
                    data.callbackUpgrade = function(popupName)
                        if popupName == UIPopupName.UIHeroCollection then
                            PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                        end
                        PopupMgr.ShowPopup(popupName, nil, UIPopupHideType.HIDE_ALL)
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIDefeat, data)
                end
            else
                zg.battleMgr:RunCalculatedBattleScene(attackerTeam,
                        arenaSingleChallengeInBound.defender:CreateBattleTeamInfo(arenaSingleChallengeInBound.defender.playerLevel, BattleConstants.DEFENDER_TEAM_ID),
                        GameMode.ARENA, nil, nil, arenaSingleChallengeInBound.arenaChallengeReward.battleResult.battleLog)
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.ARENA, PlayerDataMethod.ARENA_GROUP_RANKING, PlayerDataMethod.ARENA_SERVER_RANKING })
                ArenaRequest.RequestArenaOpponent()
            end
            RxMgr.mktTracking:Next(MktTrackingType.arena, 1)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFailed ~= nil then
                callbackFailed()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    --zg.playerData:CheckDataLinking(function ()
    NetworkUtils.Request(OpCode.ARENA_CHALLENGE, UnknownOutBound.CreateInstance(PutMethod.Long, opponentId), callback)
    --end, true)
end

--- @return void
function ArenaRequest.RequestBattleArenaTeamById(playerId, playerName, playerLevel, playerAvatar, callbackSuccess, callbackFailed, isSkip, resultBattleClose)
    local callback = function(result)
        ---@type ArenaTeamChallengeInBound
        local arenaTeamChallengeInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            require "lua.client.core.network.arenaTeam.ArenaTeamChallengeInBound"
            arenaTeamChallengeInBound = ArenaTeamChallengeInBound(buffer)
            arenaTeamChallengeInBound.rewards = NetworkUtils.AddInjectRewardInBoundList(buffer, arenaTeamChallengeInBound.rewards)
        end
        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess(arenaTeamChallengeInBound)
            end
            InventoryUtils.Sub(ResourceType.Money, MoneyType.ARENA_TEAM_TICKET, 1)

            ---@type BasicInfoInBound
            local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
            zg.battleMgr.attacker = {
                ["avatar"] = basicInfoInBound.avatarData:GetMyPlayerAvatar(),
                ["level"] = basicInfoInBound.level,
                ["name"] = basicInfoInBound.name,
                ["score"] = arenaTeamChallengeInBound.attackerElo,
                ["scoreChange"] = arenaTeamChallengeInBound.eloChange
            }
            zg.battleMgr.defender = {
                ["avatar"] = playerName,
                ["level"] = playerLevel,
                ["name"] = playerAvatar,
                ["score"] = arenaTeamChallengeInBound.defenderElo,
                ["scoreChange"] = arenaTeamChallengeInBound.eloChange
            }

            ---@type ArenaData
            local arenaData = zg.playerData:GetArenaData()
            --if arenaData.arenaRecordDataInBound ~= nil then
            --    arenaData.arenaRecordDataInBound.needRequest = true
            --end
            zg.playerData.rewardList = RewardInBound.GetItemIconDataList(arenaTeamChallengeInBound.rewards)
            zg.playerData:AddListRewardToInventory()
            zg.playerData:GetArenaData():CacheData(arenaTeamChallengeInBound)

            if isSkip == true then
                local data = {}
                data.gameMode = GameMode.ARENA_TEAM


                if arenaTeamChallengeInBound.isWin then
                    data.callbackClose = function()
                        PopupMgr.HidePopup(UIPopupName.UIVictory)
                        if resultBattleClose ~= nil then
                            resultBattleClose()
                        end
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIVictory, data)
                else
                    data.callbackClose = function()
                        PopupMgr.HidePopup(UIPopupName.UIDefeat)
                        if resultBattleClose ~= nil then
                            resultBattleClose()
                        end
                    end
                    data.callbackUpgrade = function(popupName)
                        if popupName == UIPopupName.UIHeroCollection then
                            PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                        end
                        PopupMgr.ShowPopup(popupName, nil, UIPopupHideType.HIDE_ALL)
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIDefeat, data)
                end
            else
                arenaData.arenaTeamBattleData = ArenaTeamBattleData.CreateByArenaTeamChallengeInBound(arenaTeamChallengeInBound)
                arenaData.indexArenaTeam = 1
                BattleMgr.RunArenaTeamBattle(arenaData.arenaTeamBattleData, arenaData.indexArenaTeam, nil, arenaData.arenaTeamBattleData.listBattleDetail:Get(arenaData.indexArenaTeam).battleLog)
            end
            RxMgr.mktTracking:Next(MktTrackingType.arenaTeam, 1)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFailed ~= nil then
                callbackFailed()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.ARENA_TEAM_CHALLENGE, UnknownOutBound.CreateInstance(PutMethod.Long, playerId), callback)
end

--- @return void
---@param arenaTeamOpponentInfo ArenaTeamOpponentInfo
function ArenaRequest.RequestBattleArenaTeam(arenaTeamOpponentInfo, callbackSuccess, callbackFailed, isSkip, resultBattleClose)
    ArenaRequest.RequestBattleArenaTeamById(arenaTeamOpponentInfo.playerId, arenaTeamOpponentInfo:GetAvatar(),
            arenaTeamOpponentInfo:GetLevel(), arenaTeamOpponentInfo:GetName(),
            callbackSuccess, callbackFailed, isSkip, resultBattleClose)
end

--- @return void
---@param arenaTeamBotOpponentInfo ArenaTeamBotOpponentInfo
function ArenaRequest.RequestBotBattleArenaTeam(arenaTeamBotOpponentInfo, callbackSuccess, callbackFailed, isSkip, resultBattleClose)
    local botId = arenaTeamBotOpponentInfo.botId
    local botName = arenaTeamBotOpponentInfo.botName
    local botAvatar = arenaTeamBotOpponentInfo.botAvatar
    local botLevel = arenaTeamBotOpponentInfo:GetLevel()
    local callback = function(result)
        ---@type ArenaTeamChallengeBotInBound
        local arenaTeamChallengeBotInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            require "lua.client.core.network.arenaTeam.ArenaTeamChallengeBotInBound"
            arenaTeamChallengeBotInBound = ArenaTeamChallengeBotInBound(buffer)
            arenaTeamChallengeBotInBound.rewards = NetworkUtils.AddInjectRewardInBoundList(buffer, arenaTeamChallengeBotInBound.rewards)
        end
        local onSuccess = function()
            arenaTeamChallengeBotInBound:SetBotData(botId)
            if callbackSuccess ~= nil then
                callbackSuccess(arenaTeamChallengeBotInBound)
            end
            InventoryUtils.Sub(ResourceType.Money, MoneyType.ARENA_TEAM_TICKET, 1)

            ---@type BasicInfoInBound
            local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
            zg.battleMgr.attacker = {
                ["avatar"] = basicInfoInBound.avatarData:GetMyPlayerAvatar(),
                ["level"] = basicInfoInBound.level,
                ["name"] = basicInfoInBound.name,
                ["score"] = arenaTeamChallengeBotInBound.attackerElo,
                ["scoreChange"] = arenaTeamChallengeBotInBound.eloChange
            }
            zg.battleMgr.defender = {
                ["avatar"] = botAvatar,
                ["level"] = botLevel,
                ["name"] = botName,
                ["score"] = arenaTeamChallengeBotInBound.defenderElo,
                ["scoreChange"] = arenaTeamChallengeBotInBound.eloChange
            }

            ---@type ArenaData
            local arenaData = zg.playerData:GetArenaData()
            zg.playerData.rewardList = RewardInBound.GetItemIconDataList(arenaTeamChallengeBotInBound.rewards)
            zg.playerData:AddListRewardToInventory()
            zg.playerData:GetArenaData():CacheData(arenaTeamChallengeBotInBound)

            if isSkip == true then
                local data = {}
                data.gameMode = GameMode.ARENA_TEAM


                if arenaTeamChallengeBotInBound.isWin then
                    data.callbackClose = function()
                        PopupMgr.HidePopup(UIPopupName.UIVictory)
                        if resultBattleClose ~= nil then
                            resultBattleClose()
                        end
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIVictory, data)
                else
                    data.callbackClose = function()
                        PopupMgr.HidePopup(UIPopupName.UIDefeat)
                        if resultBattleClose ~= nil then
                            resultBattleClose()
                        end
                    end
                    data.callbackUpgrade = function(popupName)
                        if popupName == UIPopupName.UIHeroCollection then
                            PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                        end
                        PopupMgr.ShowPopup(popupName, nil, UIPopupHideType.HIDE_ALL)
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIDefeat, data)
                end
            else
                arenaData.arenaTeamBattleData = ArenaTeamBattleData.CreateByArenaTeamChallengeInBound(arenaTeamChallengeBotInBound)
                arenaData.indexArenaTeam = 1
                BattleMgr.RunArenaTeamBattle(arenaData.arenaTeamBattleData, arenaData.indexArenaTeam, nil, arenaData.arenaTeamBattleData.listBattleDetail:Get(arenaData.indexArenaTeam).battleLog)
            end
            RxMgr.mktTracking:Next(MktTrackingType.arenaTeam, 1)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFailed ~= nil then
                callbackFailed()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.ARENA_TEAM_BOT_CHALLENGE,
            UnknownOutBound.CreateInstance(PutMethod.Int, botId, PutMethod.String, botName, PutMethod.Int, botAvatar),
            callback)
end

--- @return void
--- @param gameMode GameMode
--- @param recordId number
function ArenaRequest.RequestRevenge(gameMode, recordId)
    NetworkUtils.Request(OpCode.RECORD_REVENGE, UnknownOutBound.CreateInstance(PutMethod.Byte, gameMode, PutMethod.String, recordId), nil, false)
end

--- @return void
---@param uiFormationTeamData UIFormationTeamData
function ArenaRequest.SetFormationArena(uiFormationTeamData, callbackSuccess, callbackFailed)
    NetworkUtils.RequestAndCallback(OpCode.ARENA_FORMATION_SET, BattleFormationOutBound(uiFormationTeamData),
            function()
                zg.playerData:GetFormationInBound().teamDict:Add(GameMode.ARENA, TeamFormationInBound.CreateByFormationTeamData(uiFormationTeamData))
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
            end, callbackFailed, nil, true, true)
end

--- @return void
function ArenaRequest.RequestArenaOpponent(callbackSuccess, callbackFailed)
    local successFromServer = function(data)
        zg.playerData:GetArenaData().arenaOpponentInBound = data
    end
    NetworkUtils.SilentRequest(OpCode.ARENA_OPPONENT_FIND, nil, ArenaOpponentInBound, callbackSuccess, successFromServer, callbackFailed)
end

--- @return void
function ArenaRequest.RequestArenaTeamOpponent(callbackSuccess, callbackFailed)
    require("lua.client.core.network.arenaTeam.ArenaTeamOpponentInBound")
    local successFromServer = function(data)
        zg.playerData.arenaTeamOpponentInBound = data
    end
    NetworkUtils.SilentRequest(OpCode.ARENA_TEAM_OPPONENT_FIND, nil, ArenaTeamOpponentInBound, callbackSuccess, successFromServer, callbackFailed)
end

--- @return void
function ArenaRequest.RequestArenaRecord(gameMode, callbackSuccess, callbackFailed)
    local onReceived = function(result)
        local battleRecordDataInBound = nil
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            if gameMode == GameMode.ARENA then
                require("lua.client.core.network.battleRecord.BattleRecordDataInBound")
                battleRecordDataInBound = BattleRecordDataInBound(buffer)
            else
                require("lua.client.core.network.battleRecord.BattleRecordArenaInBound")
                battleRecordDataInBound = BattleRecordArenaInBound(buffer)
            end
        end
        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess(battleRecordDataInBound)
            end
        end
        local onFailed = function(logicCode)
            if callbackFailed ~= nil then
                callbackFailed()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.RECORD_LIST_GET, UnknownOutBound.CreateInstance(PutMethod.Byte, gameMode, PutMethod.Long, PlayerSettingData.playerId), onReceived)
end