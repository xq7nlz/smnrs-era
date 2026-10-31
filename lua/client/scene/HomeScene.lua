require "lua.client.scene.BaseScene"

--- @class HomeScene : BaseScene
local HomeScene = Class(HomeScene, BaseScene)

--- @return void
--- @param sceneMgr SceneMgr
function HomeScene:Ctor(sceneMgr)
    --- @type SceneMgr
    self.sceneMgr = sceneMgr
    --- @type boolean
    BaseScene.Ctor(self, SceneConfig.HomeScene)

    require("lua.client.scene.ui.home.FeatureMapping")
end

--- @return void
function HomeScene:ActiveScene(data)
    BaseScene.ActiveScene(self)
    self:ShowSceneState(data)
end

--- @return void
function HomeScene:ShowCampaign(data)
    local showPVE = function(autoNextBattle)
        CampaignDetailTeamFormationInBound.Validate(function()
            PopupMgr.ShowPopup(UIPopupName.UISelectMapPVE, { ["fromBattleScreen"] = true })
        end)
    end
    require("lua.client.scene.ui.home.uiSelectMapPVE.UISelectMapPVEView")
    if UISelectMapPVEView.CheckIsNextMap() == true then
        if ClientBattleData.battleResult == nil or ClientBattleData.battleResult.winnerTeam == BattleConstants.ATTACKER_TEAM_ID then
            PopupMgr.ShowPopup(UIPopupName.UIWorldMap, { ["isPlaySwitchNextMap"] = true, ["callbackClose"] = function()
                CampaignDetailTeamFormationInBound.Validate(function()
                    --XDebug.Log("SHOW POPUP PVE NOW HOANGPL 3")
                    PopupMgr.ShowAndHidePopup(UIPopupName.UISelectMapPVE, nil, UIPopupName.UIWorldMap)
                end)
            end })
        else
            -- XDebug.Log("SHOW POPUP PVE NOW HOANGPL 1")
            showPVE()
        end
    else
        if data ~= nil and data.isNextStage == true then
            UISelectMapPVEView.ShowFormation()
        else
            -- XDebug.Log("SHOW POPUP PVE NOW HOANGPL 2")
            local autoNextBattle = PlayerSettingData.isAutoNextBattle
            showPVE(autoNextBattle)
        end
    end
end

--- @return void
function HomeScene:ShowSceneState(data)
    if data ~= nil and data.popup ~= nil then
        --if data.popup == UIPopupName.UIHeroCollection then
        --    PopupMgr.ShowPopup(UIPopupName.UIMainArea)
        --end
        PopupMgr.ShowPopup(data.popup)
    else
        local gameMode = self.sceneMgr.gameMode
        if gameMode == GameMode.TOWER or gameMode == GameMode.TOWER_RECORD then
            PopupMgr.ShowPopup(UIPopupName.UITower, true)
        elseif gameMode == GameMode.CAMPAIGN then
            self:ShowCampaign(data)
        elseif gameMode == GameMode.DUNGEON then
            PopupMgr.ShowPopup(UIPopupName.UIDungeonMain)
        elseif gameMode == GameMode.ARENA then
            PopupMgr.ShowPopup(UIPopupName.UIArena2)
        elseif gameMode == GameMode.ARENA_TEAM or gameMode == GameMode.ARENA_TEAM_RECORD then
            PopupMgr.ShowPopup(UIPopupName.UIArenaTeam)
        elseif gameMode == GameMode.RAID or gameMode == GameMode.RAID_HERO_FRAGMENT then
            PopupMgr.ShowPopup(UIPopupName.UIRaid, { ["callbackClose"] = function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIRaid)
            end })
        elseif gameMode == GameMode.GUILD_DUNGEON then
            PopupMgr.ShowPopup(UIPopupName.UIGuildDungeon)
        elseif gameMode == GameMode.GUILD_BOSS then
            PopupMgr.ShowPopup(UIPopupName.UIGuildDailyBoss)
        elseif gameMode == GameMode.MAIN_AREA then
            PopupMgr.ShowPopup(UIPopupName.UIMainArea)
        elseif gameMode == GameMode.FRIEND_BATTLE then
            --TODO Logic cu
            --PopupMgr.ShowPopup(UIPopupName.UIFriend)
            --TODO Logic moi
            PopupMgr.ShowPopup(UIPopupName.UICommunityTotal, CommunityTotalTab.Friend)
        elseif gameMode == GameMode.OUT_GAME_LONG_TIME then
            PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            --PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeDisconnectReasonCode(DisconnectReason.OUT_GAME_LONG_TIME))
        elseif gameMode == GameMode.DOWNLOAD then
            PopupMgr.ShowPopup(UIPopupName.UIDownload)
        elseif gameMode == GameMode.GUILD_WAR then
            PopupMgr.ShowPopup(UIPopupName.UIGuildWarPhase3Main)
        elseif gameMode == GameMode.EVENT_KAZETSU_TRIAL then
            local data = { tab = EventKazetsuTab.TRIAL }
            PopupMgr.ShowPopup(UIPopupName.UIEventKazetsu, data)
        elseif gameMode == GameMode.MID_AUTUMN_ARENA_RECORD then
            local data = { tab = MidAutumnTab.ARENA }
            PopupMgr.ShowPopup(UIPopupName.UIEventMidAutumn, data)
        elseif gameMode == GameMode.CHRISTMAS_ARENA_RECORD then
            local data = { tab = ChristmasTab.ARENA }
            PopupMgr.ShowPopup(UIPopupName.UIEventChristmas, data)
        elseif gameMode == GameMode.EVENT_BOSS_CHALLENGE then
            local data = { tab = EventBossChallengeTab.CHALLENGE_TOWER }
            PopupMgr.ShowPopup(UIPopupName.UIEventBossChallenge, data)
        elseif gameMode == GameMode.EVENT_AIRYUU_TRIAL then
            local data = { tab = EventAiryuuTab.HERO_TRIAL }
            PopupMgr.ShowPopup(UIPopupName.UIEventAiryuu, data)
        elseif gameMode == GameMode.EVENT_SKIN_CHALLENGE then
            PopupMgr.ShowPopup(UIPopupName.UIEventSkinChallenge, nil)
        elseif gameMode == GameMode.DEFENSE_MODE then
            --- @type DefenseModeInbound
            local defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
            local data = defenseModeInbound.defenseRecordData.selectedData
            PopupMgr.ShowPopup(UIPopupName.UIDefenseMap, data)
        elseif gameMode == GameMode.EVENT_CHRISTMAS then
            if EventInBound.IsEventOpening(EventTimeType.EVENT_XMAS) then
                local data = {}
                data.tab = XmasTab.FROSTY_IGNATIUS
                PopupMgr.ShowPopup(UIPopupName.UIEventXmas, data)
            else
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            end
        elseif gameMode == GameMode.EVENT_LUNAR_NEW_YEAR_GUILD_BOSS then
            if EventInBound.IsEventOpening(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022) then
                local data = {}
                data.tab = LunarPathTab.BOSS
                PopupMgr.ShowPopup(UIPopupName.UIEventLunarPath, data)
            else
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            end
        elseif gameMode == GameMode.EVENT_VALENTINE_BOSS then
            if EventInBound.IsEventOpening(EventTimeType.EVENT_VALENTINE) then
                local data = {}
                data.tab = ValentineTab.LOVE_CHALLENGE
                PopupMgr.ShowPopup(UIPopupName.UIEventValentine, data)
            else
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            end
        elseif gameMode == GameMode.EVENT_KAZETSU_BOSS then
            if EventInBound.IsEventOpening(EventTimeType.EVENT_KAZETSU) then
                local data = {}
                data.tab = EventKazetsuTab.BOSS
                PopupMgr.ShowPopup(UIPopupName.UIEventKazetsu, data)
            else
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            end
        elseif gameMode == GameMode.EVENT_AIRYUU_TRIAL then
            if EventInBound.IsEventOpening(EventTimeType.EVENT_AIRYUU) then
                local data = {}
                data.tab = EventAiryuuTab.HERO_TRIAL
                PopupMgr.ShowPopup(UIPopupName.UIEventAiryuu, data)
            else
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            end
        elseif gameMode == GameMode.EVENT_FINDE_BOSS then
            if EventInBound.IsEventOpening(EventTimeType.EVENT_FINDE_BOSS) then
                PopupMgr.ShowPopup(UIPopupName.UIEventHeroBoss)
            else
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            end
        elseif gameMode == GameMode.EVENT_SEASONAL_ROYAL_CHALLENGE then
            if EventInBound.IsEventOpening(EventTimeType.EVENT_SEASONAL) then
                local data = {}
                data.tab = EventSeasonalTab.ROYAL_CHALLENGE
                PopupMgr.ShowPopup(UIPopupName.UIEventSeasonal, data)
            else
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            end
        elseif gameMode == GameMode.EVENT_BIRTHDAY_BOSS then
            if EventInBound.IsEventOpening(EventTimeType.EVENT_BIRTHDAY) then
                local data = {}
                data.tab = EventBirthdayTab.BOSS
                PopupMgr.ShowPopup(UIPopupName.UIEventBirthday, data)
            else
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            end
        elseif gameMode == GameMode.EVENT_NEW_HERO then
            if EventInBound.IsEventOpening(EventTimeType.EVENT_NEW_HERO_SPIN) then
                local data = {}
                data.eventType = EventTimeType.EVENT_NEW_HERO_SPIN
                PopupMgr.ShowPopup(UIPopupName.UIEventNewHero, data)
            else
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            end
        elseif gameMode == GameMode.TUT_BATTLE then
            PopupMgr.ShowPopup(UIPopupName.UIMainArea)
        elseif gameMode == GameMode.DEFENSE_MODE_RECORD then
            --- @type DefenseModeInbound
            local defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
            local data = defenseModeInbound.defenseRecordData.selectedData
            PopupMgr.ShowPopup(UIPopupName.UIDefenseMap, data)
        elseif gameMode == GameMode.EVENT_NEW_HERO_BOSS then
            local data = {}
            data.eventType = EventTimeType.EVENT_NEW_HERO_BOSS_CHALLENGE
            PopupMgr.ShowPopup(UIPopupName.UIEventNewHero, data)
        elseif gameMode == GameMode.DOMAINS or gameMode == GameMode.DOMAINS_RECORD then
            PopupMgr.ShowPopup(UIPopupName.UIDomainsStageMap, data)
        else


            PopupMgr.ShowPopup(UIPopupName.UICheckData)
        end
    end
    self.sceneMgr.gameMode = nil
end

return HomeScene