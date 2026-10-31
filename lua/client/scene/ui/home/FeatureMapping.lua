local OnClickCampaign = function(isHideMain, isBlurMain, callbackSuccess, data)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.CAMPAIGN) then
        local callback = function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "campaign")
            isBlurMain = isHideMain
            UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
                PopupMgr.ShowPopup(UIPopupName.UISelectMapPVE)
            end)
        end
        CampaignDetailTeamFormationInBound.Validate(callback)
    end
end

local OnClickSummonCircleRemake = function(isHideMain, isBlurMain, callbackSuccess, data)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.SUMMON) then
        local callBack = function()
            UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
                PopupMgr.ShowPopup(UIPopupName.UIHeroSummonRemake, data)
            end)
        end
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "summon_circle_remake")
        local eventRateUp = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_RATE_UP)
        if eventRateUp ~= nil and eventRateUp:IsOpening() then
            eventRateUp:RequestEventData(callBack)
        else
            callBack()
        end
    end
end

--- @param data MarketType
local OnClickBlackMarket = function(isHideMain, isBlurMain, callbackSuccess, data)
    data = data or MarketType.BLACK_MARKET
    local goToShop = function()
        if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.BLACK_MARKET) then
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "black_market")
            local data = { ["marketType"] = data,
                           ["callbackClose"] = function()
                               PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIMarket)
                           end
            }
            UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
                PopupMgr.ShowPopup(UIPopupName.UIMarket, data)
            end)
        end
    end

    if data == MarketType.GUILD_MARKET then
        if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.GUILD) == false then
            return
        end
        GuildBasicInfoInBound.Validate(function()
            --- @type GuildBasicInfoInBound
            local guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
            if guildBasicInfoInBound.isHaveGuild == false then
                SmartPoolUtils.LogicCodeNotification(LogicCode.GUILD_NOT_FOUND)
                return
            end
            goToShop()
        end)
        return
    end
    goToShop()
end

local OnClickGuild = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.GUILD) then
        local onSuccessLoadBasicInfo = function()
            isBlurMain = isHideMain
            UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
                if zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO).isHaveGuild ~= true then
                    PopupMgr.ShowPopup(UIPopupName.UIGuildApply)
                else
                    PopupMgr.ShowPopup(UIPopupName.UIGuildArea)
                end
            end)
        end
        GuildBasicInfoInBound.Validate(onSuccessLoadBasicInfo)
    end
end

local OnClickCasino = function(isHideMain, isBlurMain, callbackSuccess, casinoType)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.CASINO) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "wishing")
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            local data = {}
            data.casinoType = casinoType
            data.callbackClose = function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIPopupSelectWheel)
            end
            PopupMgr.ShowPopup(UIPopupName.UIPopupSelectWheel, data)
        end)
    end
end

local OnClickTavern = function(isHideMain, isBlurMain, callbackSuccess, data)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.TAVERN) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "tavern")
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            PopupMgr.ShowPopup(UIPopupName.UITavern, data)
        end)
    end
end

local OnClickArena = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.ARENA) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "arena")
        --- @type EventPopupModel
        local eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA)
        if eventPopupModel:IsOpening() then
            require "lua.client.core.network.arena.ArenaRequest"
            local checkArenaData = function(onSuccess)
                local arenaData = zg.playerData:GetMethod(PlayerDataMethod.ARENA)
                local arenaGroupRanking = zg.playerData:GetMethod(PlayerDataMethod.ARENA_GROUP_RANKING)
                local arenaRanking = zg.playerData:GetMethod(PlayerDataMethod.ARENA_SERVER_RANKING)
                if arenaRanking == nil or arenaData == nil or arenaGroupRanking == nil
                        or arenaData.containData == false or zg.timeMgr:GetServerTime() - arenaData.lastRequest > 30 then
                    local requestData = { PlayerDataMethod.ARENA,
                                          PlayerDataMethod.ARENA_SERVER_RANKING,
                                          PlayerDataMethod.ARENA_GROUP_RANKING,
                                          PlayerDataMethod.BASIC_INFO }
                    PlayerDataRequest.RequestAndCallback(requestData, onSuccess)
                else
                    if onSuccess ~= nil then
                        onSuccess()
                    end
                end
            end

            local showArena = function()
                isBlurMain = isHideMain
                if zg.playerData:GetFormationInBound().teamDict:IsContainKey(GameMode.ARENA) == false
                        or zg.playerData:GetMethod(PlayerDataMethod.ARENA).containData == false then
                    local result = {}
                    result.gameMode = GameMode.ARENA
                    result.tittle = LanguageUtils.LocalizeCommon("save")
                    result.callbackClose = function()
                        PopupMgr.ShowAndHidePopup(UIPopupName.UISelectArena, nil, UIPopupName.UIFormation2)
                        --PopupMgr.ShowPopup(UIPopupName.UISelectArena)
                    end
                    result.callbackPlayBattle = function(uiFormationTeamData)
                        ArenaRequest.SetFormationArena(uiFormationTeamData, function()
                            checkArenaData(function()
                                PopupMgr.HidePopup(UIPopupName.UIFormation2)
                                PopupMgr.ShowPopup(UIPopupName.UIArena2)
                            end)
                        end)
                    end
                    UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                        if callbackSuccess ~= nil then
                            callbackSuccess()
                        end
                        PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, result, UIPopupName.UISelectArena)
                    end)
                else
                    checkArenaData(function()
                        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                            if callbackSuccess ~= nil then
                                callbackSuccess()
                            end
                            --local data = {}
                            --data.callbackClose = function()
                            --    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIArena2)
                            --    PopupMgr.ShowPopup(UIPopupName.UISelectArena)
                            --end
                            PopupMgr.ShowAndHidePopup(UIPopupName.UIArena2, data, UIPopupName.UISelectArena)
                        end)
                    end)
                end
            end

            if zg.playerData:GetMethod(PlayerDataMethod.ARENA) == nil then
                local requestData = { PlayerDataMethod.ARENA, PlayerDataMethod.ARENA_GROUP_RANKING, PlayerDataMethod.ARENA_SERVER_RANKING, PlayerDataMethod.BASIC_INFO }
                PlayerDataRequest.RequestAndCallback(requestData, showArena)
            else
                showArena()
            end
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("season_end"))
        end
    end
end

local OnClickTower = function(isHideMain, isBlurMain, callbackSuccess, data)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.TOWER) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "tower")
        isBlurMain = isHideMain
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            PopupMgr.ShowPopup(UIPopupName.UITower, data)
        end)
    end
end

local OnClickBlacksmith = function(isHideMain, isBlurMain, callbackSuccess, data)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.BLACK_SMITH) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "blacksmith")
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            PopupMgr.ShowPopup(UIPopupName.UIBlackSmith, data)
        end)
    end
end

local OnClickDungeon = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.DUNGEON) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "dungeon")

        local show = function()
            local data = {}
            --- @type DungeonInBound
            local dungeonInBound = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
            ---@type EventPopupModel
            local eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.DUNGEON)
            UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
                if eventPopupModel:IsOpening() == true then
                    if dungeonInBound.bindingHeroList:Count() == 0 then
                        data.callbackClose = function()
                            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIDungeonFormation)
                        end
                        PopupMgr.ShowPopup(UIPopupName.UIDungeonFormation, data)
                        local season = eventPopupModel.timeData.season
                        if dungeonInBound.dungeonCheckInOpenSeason ~= eventPopupModel.timeData.season then
                            DungeonInBound.SetDungeonCheckInOpen(season, function()
                                dungeonInBound.dungeonCheckInOpenSeason = season
                            end)
                        end
                    else
                        data.callbackClose = function()
                            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIDungeonMain)
                        end
                        PopupMgr.ShowPopup(UIPopupName.UIDungeonMain, data)
                    end
                else
                    data.callbackClose = function()
                        PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIDungeonClosed)
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIDungeonClosed, data)
                end
            end)
        end

        local timeEventJob = Job(function(onSuccess, onFailed)
            EventInBound.ValidateEventModel(onSuccess)
        end)

        local dungeonJob = Job(function(onSuccess, onFailed)
            if zg.playerData:GetMethod(PlayerDataMethod.DUNGEON) == nil then
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.DUNGEON }, onSuccess, onFailed)
            else
                onSuccess()
            end
        end)

        --- @type Job
        local jobMultiple = timeEventJob + dungeonJob
        jobMultiple:Complete(show)
    end
end

local OnClickSummoner = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.SUMMONER) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "summoner")
        local data = {}
        data.callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UISwitchCharacter)
        end
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            PopupMgr.ShowPopup(UIPopupName.UISwitchCharacter, data)
        end)
    end
end

local OnClickRaiseLevel = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.RAISE_LEVEL) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "ui_raise_level")
        Coroutine.start(function()
            local timeToWaitServer = 0.2
            coroutine.waitforseconds(timeToWaitServer)
            PlayerRaiseLevelInbound.Validate(function()
                local data = {}
                data.callbackClose = function()
                    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIRaiseLevelHero)
                end
                UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                    if callbackSuccess ~= nil then
                        callbackSuccess()
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIRaiseLevelHero, data)
                end)
            end)
        end)
    end
end

local OnClickAltar = function(isHideMain, isBlurMain, callbackSuccess)

end

local OnClickRaid = function(isHideMain, isBlurMain, callbackSuccess, raidModeType)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.RAID) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "raid")
        isBlurMain = isHideMain
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            local data = {}
            data.raidType = raidModeType
            data.callbackClose = function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIRaid)
            end
            PopupMgr.ShowPopup(UIPopupName.UIRaid, data)
        end)
    end
end

local OnClickDomains = function(isHideMain, isBlurMain, callbackSuccess)
    DomainInBound.Validate(function()
        ---@type DomainInBound
        local domainInBound = zg.playerData:GetDomainInBound()
        if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.DOMAINS) then
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "domains")
            isBlurMain = isHideMain
            UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
                local showLobby = function()
                    PopupMgr.ShowPopup(UIPopupName.UILobbyDomain)
                end

                local showTeam = function()
                    PopupMgr.ShowPopup(UIPopupName.UIDomainTeam)
                end

                local showFormation = function()
                    local data = {}
                    data.callbackClose = function()
                        PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIFormationDomain)
                    end
                    data.callbackSave = function()
                        PopupMgr.HidePopup(UIPopupName.UIFormationDomain)
                        showLobby()
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIFormationDomain, data)
                end

                local showDomainMap = function()
                    PopupMgr.ShowPopup(UIPopupName.UIDomainsStageMap)
                end

                if domainInBound.domainContributeHeroListInBound.listHeroContribute:Count() > 0 then
                    if domainInBound.isInCrew == true then
                        if domainInBound:IsInBattle() then
                            showDomainMap()
                        else
                            showTeam()
                        end
                    else
                        showLobby()
                    end
                else
                    showFormation()
                end
            end)
        end
    end)
end

local OnClickProphetSummon = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.PROPHET_TREE) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "prophet_tree")
        local data = {}
        data.callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UITempleSummon)
        end
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            PopupMgr.ShowPopup(UIPopupName.UITempleSummon, data)
        end)
    end
end

local OnClickHandOfMidas = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.HAND_OF_MIDAS) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "hand_of_midas")
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            local data = {}
            data.callbackClose = function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIHandOfMidas)
            end
            PopupMgr.ShowPopup(UIPopupName.UIHandOfMidas, data)
        end)
    end
end

local OnClickFriend = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.FRIENDS) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "friend")
        PlayerFriendInBound.Validate(function()
            UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
                local data = {}
                data.callbackClose = function()
                    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIFriend)
                end
                PopupMgr.ShowPopup(UIPopupName.UIFriend, data)
            end)
        end)
    end
end

local OnClickSocialFriend = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.FRIENDS) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "friend")
        PlayerFriendInBound.Validate(function()
            UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
                local data
                require "lua.client.scene.ui.home.uiCommunityTotal.UICommunityTotalView"
                data = CommunityTotalTab.Friend
                PopupMgr.ShowPopup(UIPopupName.UICommunityTotal, data)
            end)
        end)
    end
end

local OnClickInventory = function(isHideMain, isBlurMain, callbackSuccess, tab)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.INVENTORY) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "inventory")
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            local data = {}
            data.tab = tab
            data.callbackClose = function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIInventory)
            end
            PopupMgr.ShowPopup(UIPopupName.UIInventory, data)
        end)
    end
end

local OnClickMail = function(isHideMain, isBlurMain, callbackSuccess)
    --- @type MailDataInBound
    local inbound = zg.playerData:GetMethod(PlayerDataMethod.MAIL)

    local requestPlayerMail = Job(function(onSuccess, onFailed)
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.MAIL }, function()
            inbound = zg.playerData:GetMethod(PlayerDataMethod.MAIL)
            if onSuccess ~= nil then
                onSuccess()
            end
        end, onFailed)
    end)

    local requestMailData = Job(function(onSuccess, onFailed)
        inbound:RequestMailData(onSuccess, onFailed)
    end)

    local requestTransactionMailData = Job(function(onSuccess, onFailed)
        inbound:RequestTransactionMailData(onSuccess, onFailed)
    end)

    ---@type Job
    local jobCanShowMain
    if inbound == nil then
        jobCanShowMain = requestPlayerMail .. (requestMailData + requestTransactionMailData)
    elseif inbound.needRequest == true then
        jobCanShowMain = (requestMailData + requestTransactionMailData)
    end
    local show = function()
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            local data = {}
            data.callbackClose = function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIMail)
            end
            PopupMgr.ShowPopup(UIPopupName.UIMail, data)
        end)
    end
    if jobCanShowMain ~= nil then
        jobCanShowMain:Complete(function()
            show()
        end)
    else
        show()
    end
end

local OnClickMastery = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.MASTERY) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "mastery")
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            local data = {}
            data.callbackClose = function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIMastery)
            end
            PopupMgr.ShowPopup(UIPopupName.UIMastery, data)
        end)
    end
end

local OnClickArenaTeam = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.ARENA_TEAM) then
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "ARENA3V3")
        --- @type EventPopupModel
        local eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA_TEAM)
        if eventPopupModel ~= nil and eventPopupModel:IsOpening() == true then
            require "lua.client.core.network.arena.ArenaRequest"
            local checkArenaTeamData = function(onSuccess)
                if zg.playerData:GetMethod(PlayerDataMethod.ARENA).containData == false or zg.timeMgr:GetServerTime() - zg.playerData:GetMethod(PlayerDataMethod.ARENA).lastRequest > 30 then
                    local requestData = { PlayerDataMethod.ARENA, PlayerDataMethod.ARENA_GROUP_RANKING, PlayerDataMethod.ARENA_SERVER_RANKING, PlayerDataMethod.BASIC_INFO }
                    PlayerDataRequest.RequestAndCallback(requestData, onSuccess)
                else
                    if onSuccess ~= nil then
                        onSuccess()
                    end
                end
            end

            local showArena = function()
                isBlurMain = isHideMain
                if zg.playerData:GetFormationInBound().arenaTeamDict:Count() < 6
                then
                    local result = {}
                    result.listTeamFormation = List()
                    for i = 1, 3 do
                        local teamFormation = zg.playerData:GetFormationInBound():GetArenaTeam(1, i)
                        result.listTeamFormation:Add(teamFormation)
                    end
                    --result.listHeroIgnor = ClientConfigUtils.GetListHeroIgnor(1, 1)
                    result.callbackClose = function()
                        PopupMgr.ShowAndHidePopup(UIPopupName.UISelectArena, nil, UIPopupName.UIFormationArenaTeam)
                    end
                    ---@param listTeamFormation List
                    result.callbackPlayBattle = function(listTeamFormation)
                        local canSave = true
                        ---@param v TeamFormationInBound
                        for i, v in ipairs(listTeamFormation:GetItems()) do
                            if v:IsContainHeroInFormation() == false then
                                canSave = false
                            end
                        end
                        if canSave == true then
                            local dict = Dictionary()
                            ---@param v TeamFormationInBound
                            for i, v in ipairs(listTeamFormation:GetItems()) do
                                dict:Add(1000 + i, v)
                                dict:Add(2000 + i, v)
                            end
                            require("lua.client.core.network.arena.ArenaRequest")
                            ArenaRequest.SetFormationArenaTeam(dict, function()
                                ArenaTeamInBound.Validate(function()
                                    PopupMgr.HidePopup(UIPopupName.UIFormationArenaTeam)
                                    PopupMgr.ShowPopup(UIPopupName.UIArenaTeam)
                                end, true)
                            end)
                        else
                            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("select_hero_all_formation"))
                        end
                    end
                    UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                        if callbackSuccess ~= nil then
                            callbackSuccess()
                        end
                        PopupMgr.ShowAndHidePopup(UIPopupName.UIFormationArenaTeam, result, UIPopupName.UISelectArena)
                    end)
                else
                    ArenaTeamInBound.Validate(function()
                        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                            if callbackSuccess ~= nil then
                                callbackSuccess()
                            end
                            --local data = {}
                            --data.callbackClose = function()
                            --    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIArenaTeam)
                            --    PopupMgr.ShowPopup(UIPopupName.UISelectArena)
                            --end
                            PopupMgr.ShowAndHidePopup(UIPopupName.UIArenaTeam, data, UIPopupName.UISelectArena)
                        end)
                    end)
                end
            end
            showArena()
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("season_end"))
        end

    end
end

local OnClickHeroList = function(isHideMain, isBlurMain, callbackSuccess)
    TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "hero_list")
    zg.playerData:CheckDataLinkingOrSupportList(function()
        UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            local data = {}
            data.callbackClose = function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIHeroCollection)
            end
            PopupMgr.ShowPopup(UIPopupName.UIHeroCollection, data)
        end)
    end, true)
end

local OnClickDefenseMode = function(isHideMain, isBlurMain, callbackSuccess)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.DEFENSE) then
        DefenseModeInbound.Validate(function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "defense")
            UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
                PopupMgr.ShowAndHidePopup(UIPopupName.UIDefenseMap, nil, UIPopupName.UIMainArea)
            end)
        end)
    end
end

local OnClickIapShop = function(isHideMain, isBlurMain, callbackSuccess, data)
    TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "iap_shop")
    isBlurMain = isHideMain
    UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
        PopupMgr.ShowAndHidePopup(UIPopupName.UIIapShop,nil, UIPopupName.UIMainArea)
    end)
end

local OnClickRecycle = function(isHideMain, isBlurMain, callbackSuccess)
    UIBaseView.CheckBlurMain(isHideMain, isBlurMain, function()
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
        local data = {}
        data.isRecycleTab = true
        data.callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIHeroCollection)
        end
        PopupMgr.ShowPopup(UIPopupName.UIHeroCollection, data)
    end)
end

--- @param featureType FeatureType
local GoToFeature = function(featureType, isHideMain, _callbackSuccess, data)
    local callbackSuccess = function()
        if _callbackSuccess ~= nil then
            _callbackSuccess()
        end
    end
    local isBlurMain = isHideMain
    if featureType == FeatureType.CAMPAIGN then
        OnClickCampaign(true, false, callbackSuccess, data)
    elseif featureType == FeatureType.SUMMON then
        OnClickSummonCircleRemake(true, false, callbackSuccess, data)
    elseif featureType == FeatureType.ALTAR then
        OnClickAltar(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.BLACK_SMITH then
        OnClickBlacksmith(isHideMain, false, callbackSuccess, data)
    elseif featureType == FeatureType.TOWER then
        OnClickTower(isHideMain, false, callbackSuccess, data)
    elseif featureType == FeatureType.BLACK_MARKET then
        OnClickBlackMarket(isHideMain, false, callbackSuccess, data)
    elseif featureType == FeatureType.TAVERN then
        OnClickTavern(isHideMain, false, callbackSuccess, data)
    elseif featureType == FeatureType.PROPHET_TREE then
        OnClickProphetSummon(isHideMain, false, callbackSuccess, data)
    elseif featureType == FeatureType.DUNGEON then
        OnClickDungeon(isHideMain, false, callbackSuccess, data)
    elseif featureType == FeatureType.GUILD then
        OnClickGuild(true, false, callbackSuccess, data)
    elseif featureType == FeatureType.CASINO then
        OnClickCasino(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.ARENA then
        OnClickArena(true, false, callbackSuccess, data)
    elseif featureType == FeatureType.RAID then
        OnClickRaid(isHideMain, false, callbackSuccess, data)
    elseif featureType == FeatureType.FRIENDS then
        --OnClickFriend(isHideMain, isBlurMain, callbackSuccess, data)
        OnClickSocialFriend(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.HAND_OF_MIDAS then
        OnClickHandOfMidas(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.SUMMONER then
        OnClickSummoner(isHideMain, false, callbackSuccess, data)
    elseif featureType == FeatureType.INVENTORY then
        OnClickInventory(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.MASTERY then
        OnClickMastery(isHideMain, false, callbackSuccess, data)
    elseif featureType == FeatureType.ARENA_TEAM then
        OnClickArenaTeam(true, false, callbackSuccess, data)
    elseif featureType == FeatureType.MAIL then
        OnClickMail(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.HERO_LIST then
        OnClickHeroList(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.DEFENSE then
        OnClickDefenseMode(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.RAISE_LEVEL then
        OnClickRaiseLevel(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.DOMAINS then
        OnClickDomains(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.IAP_SHOP then
        OnClickIapShop(isHideMain, isBlurMain, callbackSuccess, data)
    elseif featureType == FeatureType.RECYCLE then
        OnClickRecycle(isHideMain, isBlurMain, callbackSuccess, data)
    else
        XDebug.Error(string.format("Missing Feature mapping: %s", tostring(featureType)))
    end
end

--- @class FeatureMapping
FeatureMapping = {}
FeatureMapping.GoToFeature = GoToFeature
