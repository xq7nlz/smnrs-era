require "lua.client.core.network.guild.GuildBossMonthlyStatisticsInBound"
require "lua.client.scene.ui.home.uiGuildDailyBoss.guildDailyBossWorld.GuildDailyBossWorld"

--- @class UIGuildDailyBossView : UIBaseView
UIGuildDailyBossView = Class(UIGuildDailyBossView, UIBaseView)

--- @return void
--- @param model UIGuildDailyBossModel
function UIGuildDailyBossView:Ctor(model)
    --- @type UIGuildDailyBossConfig
    self.config = nil
    --- @type Dictionary -- {bossId, unlockLevel}
    self.dataUnlockConfig = nil
    --- @type MoneyBarLocalView
    self.moneyBarView = nil
    --- @type GuildBossConfig
    self.csv = nil
    --- @type Dictionary
    self.rewardMilestoneDict = nil

    ---@type string
    self.localizeUnlockGuild = ""

    --- @type GuildDailyBossWorld
    self.guildDailyBossWorld = nil
    --- @type GuildBossDataInBound
    self.guildBossDataInBound = nil
    --- @type GuildBasicInfoInBound
    self.guildBasicInfoInBound = nil

    --- @type Dictionary
    self.chestTableDict = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildDailyBossModel
    self.model = model
end

--- @return void
function UIGuildDailyBossView:OnReadyCreate()
    ---@type UIGuildDailyBossConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()
    self:_InitDataConfig()
    self:InitWorldView()
end

function UIGuildDailyBossView:_InitButtonListener()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonSmash.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSmash()
    end)
    self.config.buttonBattle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattle()
    end)
    self.config.buttonLog.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLog()
    end)
    self.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
    self.config.btnNext.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSwitchBoss(true)
    end)
    self.config.btnPrev.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSwitchBoss(false)
    end)
    self.config.btnSecret.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickMysteryBoss()
    end)
    self.config.monthlyReward.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickMonthlyReward()
    end)
end

function UIGuildDailyBossView:InitLocalization()
    self.config.textBattle.text = LanguageUtils.LocalizeCommon("battle")
    self.config.textSmash.text = LanguageUtils.LocalizeCommon("smash")
    self.config.textSelfDamage.text = LanguageUtils.LocalizeCommon("self_damage")
    self.config.textGuildDamage.text = LanguageUtils.LocalizeCommon("guild_damage")
    self.config.textMasterOnly.text = LanguageUtils.LocalizeCommon("only_leader_can_change_boss")
    self.config.textMonthlyReward.text = LanguageUtils.LocalizeCommon("monthly_reward")
end

function UIGuildDailyBossView:_InitDataConfig()
    self.csv = ResourceMgr.GetGuildBossConfig()
    local guildBossIdConfig = self.csv:GetGuildBossIdConfig()
    self.dataUnlockConfig = Dictionary()
    for level, bossId in pairs(guildBossIdConfig) do
        if self.dataUnlockConfig:IsContainKey(bossId) == false then
            self.dataUnlockConfig:Add(bossId, level)
        end
        local minLevel = self.dataUnlockConfig:Get(bossId)
        if level < minLevel then
            self.dataUnlockConfig:Add(bossId, level)
            minLevel = level
        end
    end
end

function UIGuildDailyBossView:OnClickSmash()
    local canSmash = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GUILD_BOSS_STAMINA, 1))
    if canSmash then
        local data = {}
        data.moneyType = MoneyType.GUILD_BOSS_STAMINA
        data.number = 1
        data.minInput = 1
        data.maxInput = 1

        data.callbackSmash = function(number)
            self:_OnConfirmSmashFromPopup(number)
        end
        PopupMgr.ShowPopup(UIPopupName.UIPopupSmash, data)
    end
end

function UIGuildDailyBossView:_BackToView()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildDailyBoss, nil, UIPopupName.UIFormation2)
end

function UIGuildDailyBossView:OnClickBattle()
    local canBattle = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GUILD_BOSS_STAMINA, 1))
    if canBattle then
        --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
        local data = {}
        data.gameMode = GameMode.GUILD_BOSS
        data.battleTeamInfo = self.guildBossDataInBound.battleTeamInfo
        data.callbackPlayBattle = function(uiFormationTeamData, callback)
            local callbackSuccess = function(battleResultInBound, injectorRewardList)
                local rewards = self.csv:GetGuildParticipateRewardConfig():Get(self.model.currentBossTier)
                zg.playerData.rewardList = RewardInBound.GetItemIconDataList(rewards)
                if callback ~= nil then
                    callback(nil, nil, nil, battleResultInBound.battleLog)
                end
                InventoryUtils.Sub(ResourceType.Money, MoneyType.GUILD_BOSS_STAMINA, 1)
                self:ClaimParticipateReward(1, false, injectorRewardList)
                self:OnSuccessChallengeBoss()
            end
            local onFailed = function()
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
                self:_BackToView()
            end
            BattleFormationRequest.BattleRequest(OpCode.GUILD_BOSS_CHALLENGE, uiFormationTeamData, nil, callbackSuccess, onFailed)
        end
        data.callbackClose = function()
            self:_BackToView()
        end
        PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, data, UIPopupName.UIGuildDailyBoss)
    end
end

function UIGuildDailyBossView:OnClickMonthlyReward()
    PopupUtils.ShowLeaderBoard(LeaderBoardType.GUILD_BOSS_RANKING)
end

function UIGuildDailyBossView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("guid_daily_boss_info")
    info = string.gsub(info, "{1}", tostring(self.csv:GetCommonGuildBossConfig().maxGuildBossStamina))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

function UIGuildDailyBossView:OnClickLog()
    if self.guildBossDataInBound.guildBoss.bossStatisticsInBound ~= nil then
        PopupMgr.ShowPopup(UIPopupName.UIPopupDamageStats, { ["bossStatisticsInBound"] = self.guildBossDataInBound.guildBoss.bossStatisticsInBound })
    end
end

function UIGuildDailyBossView:OnReadyShow()
    self.config.buttonLog.gameObject:SetActive(false)
    self.config.selfDamage.text = "0"
    self.config.guildDamage.text = "0"

    self.guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    if self.guildBasicInfoInBound.isHaveGuild ~= true then
        local touchObject = TouchUtils.Spawn("UIGuildDailyBossView:OnReadyShow")
        Coroutine.start(function()
            coroutine.yield(1)
            touchObject:Enable()
            self:OnServerNotificationGuildKicked()
        end)
    end
    self.guildDailyBossWorld:Show()
    self.guildBossDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BOSS)
    GuildBossDataInBound.Validate(function()
        self:OnSuccessRequestBossData()
    end)
    if self.serverNotificationListener == nil then
        self.serverNotificationListener = RxMgr.guildMemberKicked:Subscribe(RxMgr.CreateFunction(self, self.OnServerNotificationGuildKicked))
    end
    self:ShowMoneyBar()
end

function UIGuildDailyBossView:ShowMoneyBar()
    self.moneyBarView = MoneyBarLocalView(self.config.moneyBarInfo)
    self.moneyBarView:SetIconData(MoneyType.GUILD_BOSS_STAMINA)
    self.moneyBarView:SetBuyText(self.csv:GetCommonGuildBossConfig().maxGuildBossStamina)
end

function UIGuildDailyBossView:InitWorldView()
    self.guildDailyBossWorld = GuildDailyBossWorld(self.config.guildDailyBossWorld, self)
end

function UIGuildDailyBossView:OnSuccessRequestBossData()
    self.guildBossDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BOSS)
    local guildLevel = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO).guildInfo.guildLevel
    self.model.highestBossTier = self.csv:GetBossTierByGuildLevel(guildLevel)
    self.model:SetGuildBossDataInBound(self.guildBossDataInBound)

    if self.guildBossDataInBound.isHaveGuildBoss == true then
        self.model.currentBossTier = self.guildBossDataInBound.guildBoss.bossId
    else
        self.model.currentBossTier = 1
    end
    self:ShowSelectedBossData()
    self:ShowBossRewardMilestones(self.model.currentBossTier)
end

function UIGuildDailyBossView:ShowSelectedBossData()
    self.config.otherBossInfo:SetActive(false)
    self.config.buttonLog.gameObject:SetActive(true)

    self.config.selfDamage.text = tostring(self.model.selfDamage)
    self.config.guildDamage.text = tostring(self.model.currentTotalGuildDamage)

    self.config.currentBossInfo:SetActive(true)

    self:ShowGuildBossView()
    self:ShowRewardInfo()
end

function UIGuildDailyBossView:ShowRewardInfo()
    local currentRewardTier
    local nextRewardTier
    --- @type GuildDailyBossRewardConfig
    local dailyBossRewardConfig = ResourceMgr.GetGuildBossConfig():GetGuildDailyBossRewardConfig()
    for i = 1, self.model.currentBossTier do
        --- @type {min_damage, max_damage, number_random_reward}
        local rewardTierConfig = dailyBossRewardConfig:GetRewardTierConfigByTier(i)
        if self.model.currentTotalGuildDamage >= rewardTierConfig.min_damage then
            currentRewardTier = i
        end
    end
    if currentRewardTier ~= nil and currentRewardTier < dailyBossRewardConfig:GetMilestoneCount() - 1 then
        nextRewardTier = currentRewardTier + 1
    end
    self:SetDataChest(self.config.buttonCurrentChest, currentRewardTier, LanguageUtils.LocalizeCommon("current_reward"))
    self:SetDataChest(self.config.buttonNextChest, nextRewardTier, LanguageUtils.LocalizeCommon("next_reward"))
    if currentRewardTier == nil then
        self.config.requireDealDamage.text = LanguageUtils.LocalizeCommon("deal_damage_to_get_reward")
    end
    self.config.rewardInfo:SetActive(currentRewardTier ~= nil)
    self.config.requireDealDamage.gameObject:SetActive(currentRewardTier == nil)
end

--- @param bossTier number
function UIGuildDailyBossView:ShowOtherBossData(bossTier)
    self.config.currentBossInfo:SetActive(false)
    self.config.otherBossInfo:SetActive(true)

    self.guildDailyBossWorld:SetData(nil)
    self.config.btnSecret.gameObject:SetActive(true)

    self.config.textName.text = LanguageUtils.LocalizeCommon("random_boss")
    self.config.textLevel.text = string.format("%s %s", LanguageUtils.LocalizeCommon("level"), bossTier)

    self.config.buttonSelect.gameObject:SetActive(false)
    self.config.textMasterOnly.gameObject:SetActive(false)
    self.config.buttonRequireLevel:SetActive(false)

    --- @type GuildBasicInfoInBound
    local guildBasicInfo = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    --- @type GuildRole
    local selfRole = guildBasicInfo.guildInfo.selfRole
    local unlockLevel = self.dataUnlockConfig:Get(bossTier)
    if guildBasicInfo.guildInfo.guildLevel >= unlockLevel then
        if selfRole == GuildRole.LEADER or selfRole == GuildRole.SUB_LEADER then
            self.config.buttonSelect.onClick:RemoveAllListeners()
            self.config.buttonSelect.onClick:AddListener(function()
                zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
                local notice = "Do you want to select this boss to challenge" .. "\n"
                local nextDay = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
                notice = notice .. "The change will be applied in " .. TimeUtils.GetDeltaTime(nextDay - zg.timeMgr:GetServerTime())
                PopupUtils.ShowPopupNotificationYesNo(notice, nil,
                        function()
                            self:RequestSelectBoss(bossTier)
                        end)
            end)
            self.config.buttonSelect.gameObject:SetActive(true)
        else
            self.config.textMasterOnly.gameObject:SetActive(true)
        end
    else
        self.config.textRequireGuildLevel.text = string.format(LanguageUtils.LocalizeCommon("unlock_at_guild_x"), unlockLevel)
        self.config.buttonRequireLevel:SetActive(true)
    end
end

function UIGuildDailyBossView:ShowGuildBossView()
    if self.guildBossDataInBound.battleTeamInfo == nil then
        self.config.btnSecret.gameObject:SetActive(true)
        return
    end
    self.config.btnSecret.gameObject:SetActive(false)
    --- @return BattleTeamInfo
    local defenderTeam = self.guildBossDataInBound.battleTeamInfo
    --- @type HeroBattleInfo
    local bossInfo = defenderTeam.listHeroInfo:Get(1)
    local heroResource = HeroResource()
    heroResource:SetData(-1, bossInfo.heroId, bossInfo.star, bossInfo.level)
    heroResource.isBoss = true
    self.guildDailyBossWorld:SetData(heroResource)

    self.config.textName.text = LanguageUtils.LocalizeNameHero(heroResource.heroId)
    self.config.textLevel.text = string.format("%s %s", LanguageUtils.LocalizeCommon("level"), self.model.currentBossTier)
end

--- @param bossTier number
function UIGuildDailyBossView:OnSelectBossCallback(bossTier)
    if bossTier > self.model.highestBossTier then
        local unlockLevel = self.dataUnlockConfig:Get(bossTier)
        SmartPoolUtils.ShowShortNotification(string.format(self.localizeUnlockGuild, unlockLevel))
    else
        if bossTier ~= self.model.currentBossTier then
            self.guildBossDataInBound.selectedBossId = bossTier
            self:RequestSelectBoss(bossTier)
        end
    end
end

--- @param bossTier number
function UIGuildDailyBossView:RequestSelectBoss(bossTier)
    local onReceived = function(result)
        local onSuccess = function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("boss_changed_successful"))
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.GUILD_BOSS_SELECT, UnknownOutBound.CreateInstance(PutMethod.Int, bossTier), onReceived)
end

function UIGuildDailyBossView:_OnConfirmSmashFromPopup(number)
    --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
    local data = {}
    data.gameMode = GameMode.GUILD_BOSS
    data.battleTeamInfo = nil
    data.callbackPlayBattle = function(uiFormationTeamData, callback)
        self:_OnClickBattleFromUIFormationSmash(uiFormationTeamData, number)
    end
    data.callbackClose = function()
        self:_BackToView()
    end
    PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, data, UIPopupName.UIGuildDailyBoss)
end

--- @param injectorRewardList List
function UIGuildDailyBossView:_OnClickBattleFromUIFormationSmash(uiFormationTeamData, number)
    local onSuccess = function(battleResultInBound, injectorRewardList)
        InventoryUtils.Sub(ResourceType.Money, MoneyType.GUILD_BOSS_STAMINA, number)
        self:OnSuccessChallengeBoss()
        self:ClaimParticipateReward(number, true, injectorRewardList)
        self:_BackToView()
    end
    local onFailed = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        self:_BackToView()
    end

    BattleFormationRequest.BattleRequest(OpCode.GUILD_BOSS_CHALLENGE, uiFormationTeamData, nil, onSuccess, onFailed)
end

function UIGuildDailyBossView:OnServerNotificationGuildKicked()
    PopupUtils.BackToMainArea()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("guild_was_kicked"))
end

--- @param multiplier number
--- @param isShowPopup boolean
--- @param injectorRewardList List
function UIGuildDailyBossView:ClaimParticipateReward(multiplier, isShowPopup, injectorRewardList)
    local listRewardIcon = List()
    --- @type List -- RewardInBound
    local listReward = self.csv:GetGuildParticipateRewardConfig():Get(self.model.currentBossTier)
    for i = 1, listReward:Count() do
        --- @type RewardInBound
        local reward = listReward:Get(i)
        reward.number = reward:GetNumber() * multiplier
        reward:AddToInventory()
        listRewardIcon:Add(reward:GetIconData())
    end
    if injectorRewardList ~= nil and injectorRewardList:Count() > 0 then
        for i = 1, injectorRewardList:Count() do
            --- @type RewardInBound
            local reward = injectorRewardList:Get(i)
            reward:AddToInventory()
            listRewardIcon:Add(reward:GetIconData())
        end
    end
    if isShowPopup == true then
        PopupUtils.ShowRewardList(listRewardIcon)
    end
end

function UIGuildDailyBossView:OnSuccessChallengeBoss()
    local guildData = zg.playerData:GetGuildData()
    if guildData.guildBossMonthlyStatisticsData ~= nil then
        guildData.guildBossMonthlyStatisticsData.lastTimeRequest = nil
    end
    self.guildBossDataInBound.lastTimeRequest = nil
    zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO).lastChallengeBoss = zg.timeMgr:GetServerTime()
end

function UIGuildDailyBossView:OnClickBackOrClose()
    UIBaseView.OnClickBackOrClose(self)
    PopupMgr.ShowPopup(UIPopupName.UIGuildArea)
end

--- @param isNext boolean
function UIGuildDailyBossView:OnClickSwitchBoss(isNext)
    if isNext and self.model.currentBossTier < self.dataUnlockConfig:Count() then
        self.model.currentBossTier = self.model.currentBossTier + 1
    elseif not isNext and self.model.currentBossTier > 1 then
        self.model.currentBossTier = self.model.currentBossTier - 1
    else
        return
    end
    self.config.buttonLog.gameObject:SetActive(false)
    self.config.selfDamage.text = "0"
    self.config.guildDamage.text = "0"

    self:ShowBossRewardMilestones(self.model.currentBossTier)
    if self.guildBossDataInBound.isHaveGuildBoss
            and self.model.currentBossTier == self.guildBossDataInBound.guildBoss.bossId then
        self:ShowSelectedBossData()
    else
        self:ShowOtherBossData(self.model.currentBossTier)
    end
end

function UIGuildDailyBossView:ShowButtonSwitchState()
    self.config.btnNext.gameObject:SetActive(self.model.currentBossTier < self.dataUnlockConfig:Count())
    self.config.btnPrev.gameObject:SetActive(self.model.currentBossTier > 1)
end

function UIGuildDailyBossView:ShowBossRewardMilestones(bossTier)
    self:ReturnPoolMilestones()
    --- @type GuildDailyBossRewardConfig
    local dailyBossRewardConfig = ResourceMgr.GetGuildBossConfig():GetGuildDailyBossRewardConfig()
    local achievedMilestone = 0
    for i = 1, bossTier do
        local milestone = self:GetMilestoneReward(i)
        --- @type {min_damage, max_damage, number_random_reward}
        local rewardTierConfig = dailyBossRewardConfig:GetRewardTierConfigByTier(i)
        milestone:SetData(i, rewardTierConfig.min_damage)
        if self.model.currentTotalGuildDamage >= rewardTierConfig.min_damage then
            achievedMilestone = achievedMilestone + 1
        end
        if self.guildBossDataInBound.guildBoss ~= nil
                and self.guildBossDataInBound.guildBoss.bossId == bossTier then
            milestone:EnableHighlight(self.model.currentTotalGuildDamage >= rewardTierConfig.min_damage)
        else
            milestone:EnableHighlight(false)
        end
        milestone:AddSelectListener(function()
            self:OpenChestByTier(i)
        end)
    end
    if self.guildBossDataInBound.guildBoss.bossId == bossTier and achievedMilestone > 0 then
        if achievedMilestone == bossTier then
            self.config.progressBar.fillAmount = 1
        else
            UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.config.milestones)
            --- @type UnityEngine_RectTransform
            local a = self.config.milestones:GetChild(achievedMilestone - 1):GetComponent(ComponentName.UnityEngine_RectTransform)
            self.config.progressBar.fillAmount = a.anchoredPosition3D.x / self.config.milestones.sizeDelta.x
        end
    else
        self.config.progressBar.fillAmount = 0
    end

    self:ShowButtonSwitchState()
end

--- @return GuildDailyBossMilestoneReward
--- @param stage number
function UIGuildDailyBossView:GetMilestoneReward(stage)
    if self.rewardMilestoneDict == nil then
        self.rewardMilestoneDict = Dictionary()
    end
    local milestone = self.rewardMilestoneDict:Get(stage)
    if milestone == nil then
        milestone = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.GuildDailyBossMilestoneReward, self.config.milestones)
        self.rewardMilestoneDict:Add(milestone, milestone)
    end
    return milestone
end

function UIGuildDailyBossView:Hide()
    UIBaseView.Hide(self)
    if self.serverNotificationListener ~= nil then
        self.serverNotificationListener:Unsubscribe()
        self.serverNotificationListener = nil
    end
    self.guildDailyBossWorld:Hide()
    if self.moneyBarView ~= nil then
        self.moneyBarView:RemoveListener()
    end
    self:ReturnPoolMilestones()
end

function UIGuildDailyBossView:ReturnPoolMilestones()
    if self.rewardMilestoneDict ~= nil then
        --- @param v GuildDailyBossMilestoneReward
        for _, v in pairs(self.rewardMilestoneDict:GetItems()) do
            v:ReturnPool()
        end
    end
    self.rewardMilestoneDict = Dictionary()
end

--- @param tier number
function UIGuildDailyBossView:OpenChestByTier(tier)
    local guildBossRewards = ResourceMgr.GetGuildBossConfig():GetGuildDailyBossRewardConfig()
    --- @type List -- {res_type, res_id, res_number, res_data}
    local listFixedRewards = guildBossRewards:GetListFixedRewardByTier(tier)

    --- @type {listItemData, iconChest, chestName, chestInfo}
    local data = {}
    data.listItemData = List()
    data.iconChest = ResourceLoadUtils.LoadChestIcon(tier)
    data.chestName = LanguageUtils.LocalizeChestRewardDailyBoss(string.format("chest_%d_name", tier))
    data.chestInfo = LanguageUtils.LocalizeChestRewardDailyBoss(string.format("chest_%d_info", tier))
    for i = 1, listFixedRewards:Count() do
        --- @type {res_type, res_id, res_number, res_data}
        local fixedReward = listFixedRewards:Get(i)
        --- @type ItemIconData
        local itemIconData = ItemIconData()
        itemIconData:SetData(fixedReward.res_type, fixedReward.res_id, fixedReward.res_number)
        data.listItemData:Add(itemIconData)
    end

    local randomItemCount = guildBossRewards:GetRewardTierConfigByTier(tier).number_random_reward
    for _ = 1, randomItemCount do
        --- @type ItemIconData
        local itemIconData = ItemIconData()
        itemIconData:SetData(ResourceType.Money, MoneyType.Random, nil)
        data.listItemData:Add(itemIconData)
    end

    PopupMgr.ShowPopup(UIPopupName.UIPopupPackOfItems, data)
end

function UIGuildDailyBossView:OnClickMysteryBoss()
    local guildBossDefenderTeamConfig = self.csv:GetGuildBossDefenderTeamConfig()
    local listDefenderTeamData = guildBossDefenderTeamConfig:GetListDefenderTeam(self.model.currentBossTier)
    local listHeroBattleInfo = List()

    for i = 1, listDefenderTeamData:Count() do
        --- @type DefenderTeamData
        local defenderTeamData = listDefenderTeamData:Get(i)
        --- @type BattleTeamInfo
        local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(defenderTeamData)
        for k = 1, battleTeamInfo.listHeroInfo:Count() do
            --- @type HeroBattleInfo
            local heroBattleInfo = battleTeamInfo.listHeroInfo:Get(k)
            --- @type {heroBattleInfo : HeroBattleInfo, battleTeamInfo : BattleTeamInfo}
            local info = {}
            info.heroBattleInfo = heroBattleInfo
            info.battleTeamInfo = battleTeamInfo
            listHeroBattleInfo:Add(info)
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UIPreviewDailyBoss, listHeroBattleInfo)
end

--- @param chestAnchor UnityEngine_RectTransform
function UIGuildDailyBossView:SetDataChest(chestAnchor, tier, info)
    if tier == nil then
        chestAnchor.gameObject:SetActive(false)
        return
    end
    if self.chestTableDict == nil then
        self.chestTableDict = Dictionary()
    end
    --- @type {img : UnityEngine_UI_Image, txtName : UnityEngine_UI_Text, info : UnityEngine_UI_Text, btn : UnityEngine_UI_Button}
    local chestTable = self.chestTableDict:Get(chestAnchor)
    if chestTable == nil then
        chestTable = {}
        chestTable.img = chestAnchor:Find("icon_chest"):GetComponent(ComponentName.UnityEngine_UI_Image)
        chestTable.txtName = chestAnchor:Find("chest_name"):GetComponent(ComponentName.UnityEngine_UI_Text)
        chestTable.info = chestAnchor:Find("chest_info"):GetComponent(ComponentName.UnityEngine_UI_Text)
        chestTable.btn = chestAnchor:Find("icon_chest"):GetComponent(ComponentName.UnityEngine_UI_Button)
        self.chestTableDict:Add(chestAnchor, chestTable)
    end
    chestTable.img.sprite = ResourceLoadUtils.LoadChestIcon(tier)
    chestTable.img:SetNativeSize()
    chestTable.txtName.text = LanguageUtils.LocalizeChestRewardDailyBoss(string.format("chest_%d_name", tier))
    chestTable.info.text = info
    chestTable.btn.onClick:RemoveAllListeners()
    chestTable.btn.onClick:AddListener(function()
        self:OpenChestByTier(tier)
    end)
    chestAnchor.gameObject:SetActive(true)
end