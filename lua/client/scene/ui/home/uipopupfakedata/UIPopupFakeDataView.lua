require "lua.client.core.network.fake.FakeDataRequest"

--- @class UIPopupFakeDataView : UIBaseView
UIPopupFakeDataView = Class(UIPopupFakeDataView, UIBaseView)

--- @return void
--- @param model UIPopupFakeDataModel
function UIPopupFakeDataView:Ctor(model)
    ---@type UIPopupFakeDataConfig
    self.config = nil
    --- @type number
    self.serverTime = nil
    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UIPopupFakeDataModel
    self.model = model
end

--- @return void
function UIPopupFakeDataView:OnReadyCreate()
    ---@type UIPopupFakeDataConfig
    self.config = UIBaseConfig(self.uiTransform)

    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.fakeABFireBase)
    config.button.onClick:AddListener(function()

        local idType = tonumber(config.inputField1.text) -- hoangpl fake campaign
        local key = ClientConfigUtils.GetKeyByTypeNumber(idType)
        local idCampaign = tonumber(config.inputField2.text) -- hoangpl fake campaign
        --[[		local onSuccess = function()
                    zg.playerData:SetABTesting(FirebaseRemoteConfigKey.Campaign, idCampaign)
                end
                local onFail =  function()
                    SmartPoolUtils.ShowShortNotification("Fake failed")
                end]]
        FakeDataRequest.FakeABTest(key, idCampaign)
        --NetworkUtils.RequestAndCallback(OpCode.REMOTE_CONFIG_AB_TEST_DATA_SET, UnknownOutBound.CreateInstance(PutMethod.String,FirebaseRemoteConfigKey.Campaign,PutMethod.Int,idCampaign),onSuccess, onFail, nil, false)
        --FakeDataRequest.FakeHeroFragment()
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.hero)
    config.button.onClick:AddListener(function()
        local star = 1
        if config.inputField2.text ~= nil and tonumber(config.inputField2.text) ~= nil then
            star = tonumber(config.inputField2.text)
        end
        local level = 1
        if config.inputField3.text ~= nil and tonumber(config.inputField3.text) ~= nil then
            level = tonumber(config.inputField3.text)
        end
        local number = 1
        if config.inputField4.text ~= nil and tonumber(config.inputField4.text) ~= nil then
            number = tonumber(config.inputField4.text)
        end

        FakeDataRequest.FakeHero(tonumber(config.inputField1.text), star, level, number)
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.heroFragment)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeHeroFragment(tonumber(config.inputField1.text), tonumber(config.inputField2.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.itemEquip)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeItem(tonumber(config.inputField1.text), tonumber(config.inputField2.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.artifact)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeArtifact(tonumber(config.inputField1.text), tonumber(config.inputField2.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.skin)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeSkin(tonumber(config.inputField1.text), tonumber(config.inputField2.text) or 1)
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.skinFragment)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeSkinFragment(tonumber(config.inputField1.text), tonumber(config.inputField2.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.clearSubscription)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeClearSubscription()
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.clearArenaPass)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeClearArenaPass()
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.clearDailyQuestPass)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeClearDailyQuestPass()
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.clearProgressGroup)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeClearProgressGroup()
        zg.playerData.remoteConfig.showedMasterBlackSmithLoginTime = nil
        zg.playerData:SaveRemoteConfig()
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.artifactFragment)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeArtifactFragment(tonumber(config.inputField1.text), tonumber(config.inputField2.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.money)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeMoney(tonumber(config.inputField1.text), tonumber(config.inputField2.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.quickBattleTicket)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeQuickBattleTicket(tonumber(config.inputField1.text), tonumber(config.inputField2.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.vip)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeVip(tonumber(config.inputField1.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.progressPack)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeProgressGroupId(tonumber(config.inputField1.text))

        require "lua.client.scene.ui.rate.UserRate"
        UserRate.CheckRate(true)
    end)

    local config = UIBaseConfig(self.config.summon)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeResetSummon(tonumber(config.inputField1.text), tonumber(config.inputField2.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.trialMonthlyStage)
    config.button.onClick:AddListener(function()
        IapDataInBound.SetAutoShowedTrialMonthlyByCampaignStage(-1, function()
            XDebug.Log("Fake success")
        end)
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.summoner)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeSummoner(tonumber(config.inputField1.text), tonumber(config.inputField2.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.setDungeonTime)
    config.button.onClick:AddListener(function()
        local isOnTime = false
        if tonumber(config.inputField1.text) ~= nil and tonumber(config.inputField1.text) > 0 then
            isOnTime = true
        end
        FakeDataRequest.FakeDungeonTime(isOnTime, tonumber(config.inputField2.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.resetDungeon)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeResetDungeon(tonumber(config.inputField1.text))
    end)

    ---@type ItemFakeDataConfig
    self.configNewDayTime = UIBaseConfig(self.config.newDayTime)
    self.configNewDayTime.button.onClick:AddListener(function()
        local isReset = false
        if tonumber(self.configNewDayTime.inputField3.text) ~= nil and tonumber(self.configNewDayTime.inputField3.text) > 0 then
            isReset = true
        end
        FakeDataRequest.FakeDayTime(self.serverTime, tonumber(self.configNewDayTime.inputField1.text), tonumber(self.configNewDayTime.inputField2.text), isReset)
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.resetTower)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeLevelTower(tonumber(config.inputField1.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.campaign)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeResetCampaign(tonumber(config.inputField1.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.arena)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeElo(tonumber(config.inputField1.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.arenaTeam)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeTeamElo(tonumber(config.inputField1.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.heroFood)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeHeroFood(tonumber(config.inputField1.text), tonumber(config.inputField2.text), tonumber(config.inputField3.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.growthPack)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeGrowthPack(tonumber(config.inputField1.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.guildLevel)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeGuildLevel(tonumber(config.inputField1.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.tutorial)
    config.button.onClick:AddListener(function()
        local step = 0
        local success = false
        local summon = 0
        if tonumber(config.inputField1.text) ~= nil then
            step = tonumber(config.inputField1.text)
        end
        if tonumber(config.inputField2.text) ~= nil and tonumber(config.inputField2.text) > 0 then
            success = true
        end
        if tonumber(config.inputField3.text) ~= nil then
            summon = tonumber(config.inputField3.text)
        end
        FakeDataRequest.FakeTutorial(step, success, summon)
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.speedUpTime)
    config.button.onClick:AddListener(function()
        PlayerData.ClearAllData()
        FakeDataRequest.FakeSpeedUpTime(tonumber(config.inputField1.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.speedUpTimeRemoteConfig)
    config.button.onClick:AddListener(function()
        zg.playerData.remoteConfig.lastTimeShowPopupDeletePublisher = zg.timeMgr:GetServerTime() - tonumber(config.inputField1.text)
        zg.playerData:SaveRemoteConfig()
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.offlineTime)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeOfflineTime(tonumber(config.inputField1.text) * TimeUtils.SecondADay, function()
            PlayerDataRequest.RequestAllData(nil, nil, false)
            self:SyncTimeServer()
        end)
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.domainDay)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeDomainChallengeDay(tonumber(config.inputField1.text), function()
            PlayerDataRequest.RequestAllData(nil, nil, false)
            self:SyncTimeServer()
        end)
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.idleDefenseMode)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeIdleDefense(tonumber(config.inputField1.text), tonumber(config.inputField2.text), function()
            DefenseModeInbound.Validate(nil, true)
        end)
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.guildWar)
    config.button.onClick:AddListener(function()
        local server = nil
        if not StringUtils.IsNilOrEmpty(config.inputField3.text) then
            server = tonumber(config.inputField3.text)
        end
        FakeDataRequest.FakeRegisterGuildWar(tonumber(config.inputField1.text), tonumber(config.inputField2.text), server)
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.registerAcc)
    config.button.onClick:AddListener(function()
        local server = ServerListInBound.GetServerRegister()
        if not StringUtils.IsNilOrEmpty(config.inputField3.text) then
            server = tonumber(config.inputField3.text)
        end
        FakeDataRequest.FakeRegisterAcc(config.inputField1.text, config.inputField2.text, server)
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.guildJoin)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeJoinGuild(config.inputField1.text, config.inputField2.text, tonumber(config.inputField3.text))
    end)

    ---@type ItemFakeDataConfig
    local config = UIBaseConfig(self.config.resource)
    config.button.onClick:AddListener(function()
        FakeDataRequest.FakeResource(tonumber(config.inputField1.text), tonumber(config.inputField2.text), tonumber(config.inputField3.text))
    end)

    -----@type ItemFakeDataConfig
    --local config = UIBaseConfig(self.config.friendAdd)
    --config.button.onClick:AddListener(function ()
    --	local server = nil
    --	if not StringUtils.IsNilOrEmpty(config.inputField3.text) then
    --		server = tonumber(config.inputField3.text)
    --	end
    --	FakeDataRequest.FakeAddFriend(tonumber(config.inputField1.text), tonumber(config.inputField2.text), server)
    --end)

    self.config.buttonResetBlackMarket.onClick:AddListener(function()
        FakeDataRequest.FakeResetBlackMarket()
    end)
    self.config.buttonClearHeroes.onClick:AddListener(function()
        FakeDataRequest.FakeClearHeroes()
    end)
    self.config.buttonClearItems.onClick:AddListener(function()
        FakeDataRequest.FakeClearItems()
    end)
    self.config.buttonResetSummoner.onClick:AddListener(function()
        FakeDataRequest.FakeResetSummoner()
    end)
    self.config.buttonScoutBoss.onClick:AddListener(function()
        FakeDataRequest.FakeScoutBoss()
    end)
    self.config.buttonFakeAll.onClick:AddListener(function()
        -- clear all heroes
        local bitmask = 0
        bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.CLEAR_ALL_HEROES)
        NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask), function()
            -- fake money
            bitmask = 0
            bitmask = BitUtils.TurnOn(bitmask, FakeDataMethod.SET_MONEY)
            NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                    PutMethod.Long, bitmask, PutMethod.Byte, 0, PutMethod.Long, 1000000000000), nil, false)
            NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                    PutMethod.Long, bitmask, PutMethod.Byte, 1, PutMethod.Long, 10000000), nil, false)
            NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                    PutMethod.Long, bitmask, PutMethod.Byte, 10, PutMethod.Long, 1000000000), nil, false)
            NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                    PutMethod.Long, bitmask, PutMethod.Byte, 30, PutMethod.Long, 100000), nil, false)
            NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                    PutMethod.Long, bitmask, PutMethod.Byte, 31, PutMethod.Long, 100000), nil, false)
            NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                    PutMethod.Long, bitmask, PutMethod.Byte, 40, PutMethod.Long, 100000), nil, false)
            NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                    PutMethod.Long, bitmask, PutMethod.Byte, 60, PutMethod.Long, 100000), nil, false)
            NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                    PutMethod.Long, bitmask, PutMethod.Byte, 61, PutMethod.Long, 100000), nil, false)
            NetworkUtils.Request(OpCode.FAKE_DATA, UnknownOutBound.CreateInstance(
                    PutMethod.Long, bitmask, PutMethod.Byte, 80, PutMethod.Long, 1000000000), nil, false)
            -- fake hero
            FakeDataRequest.FakeHero(nil, 7, 140, 5)
            -- fake summoner
            FakeDataRequest.FakeSummoner(99, 7)
            -- wait for refresh playerDat
            Coroutine.start(function()
                local touchObject = TouchUtils.Spawn("buttonFakeAll")
                for i = 1, 10 do
                    print("count: " .. tostring(10 - i))
                    coroutine.waitforseconds(1)
                end
                touchObject:Enable()
                PopupMgr.HidePopup(self.model.uiName)
                print("Request all data !!!")
            end)
        end, true, false)
    end)

    if IS_IOS_PLATFORM then
        self.config.buttonShowMediationDebugger.onClick:AddListener(function()
            zgUnity.ironSrc:ShowMediationDebugger()
        end)
    end
end

--- @return void
function UIPopupFakeDataView:OnReadyShow()
    require "lua.client.core.network.fake.FakeDataRequest"
    self:SyncTimeServer()
end

--- @return void
function UIPopupFakeDataView:SyncTimeServer()
    if self.configNewDayTime then
        zg.timeMgr:SyncClockTime(function(time)
            self.serverTime = time / 1000
            self.configNewDayTime.inputField1.text = tostring(self.serverTime + 10)
            self.configNewDayTime.inputField2.text = tostring(self.serverTime - 10)
            self.configNewDayTime.inputField3.text = tostring(0)
        end)
    end
    self.config.textPlayerId.text = tostring(PlayerSettingData.playerId)
    self.config.textToken.text = PlayerSettingData.authToken
    PlayerDataRequest.Request(PlayerDataMethod.STATISTICS)
end

function UIPopupFakeDataView:CheckLocalizeSkill()
    for i, heroId in pairs(ResourceMgr.GetHeroMenuConfig().listHeroCollection:GetItems()) do
        if heroId > 1000 then
            ---@type HeroDataEntry
            local heroDataEntry = ResourceMgr.GetServiceConfig():GetHeroes():GetHeroDataEntry(heroId)
            if heroDataEntry ~= nil then
                for skillId, v in pairs(heroDataEntry.allSkillDataDict:GetItems()) do
                    local localize = LanguageUtils.LocalizeSkillDescription(heroId, skillId, 1)
                    if string.find(localize, "nil_") ~= nil then
                        XDebug.Warning(string.format("Localize_%s_%s:  %s", heroId, skillId, localize))
                    end
                end
            end
        end
    end
    XDebug.Log("Finish Check Localize")
end