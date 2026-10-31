require("lua.client.scene.ui.home.uiEventLunarPath.uiEventLunarPathLayout.uiEventLunarBossLayout.UILunarBossChapterItemView")
require("lua.client.core.network.event.eventLunarNewYear.EventLunarBossDetailInBound")

--- @class UIEventLunarBossLayout : UIEventLunarPathLayout
UIEventLunarBossLayout = Class(UIEventLunarBossLayout, UIEventLunarPathLayout)

--- @param view UIEventView
function UIEventLunarBossLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventLunarPathModel
    self.eventModel = nil
    --- @type EventLunarPathConfig
    self.eventConfig = nil
    ---@type List
    self.listReward = List()
    ---@type List
    self.listChapterView = List()
    ---@type List
    self.listChapterBossConfig = List()
    ---@type WorldSpaceHeroView
    self.worldSpaceHeroView = nil
    ---@type MoneyBarView
    self.moneyBarView = nil
    ---@type LunarBossConfig
    self.currentBossPreview = nil
    ---@type number
    self.currentChap = 0
    ---@type number
    self.passChap = 0
    ---@type number
    self.selfDamage = 0
    ---@type number
    self.guildDamage = 0
    ---@type number
    self.hpPercent = 1
    ---@type boolean
    self.isClearBoss = false
    ---@type UIEventLunarBossConfig
    self.layoutConfig = nil
    ---@type number
    self.stamina = 1

    UIEventLunarPathLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventLunarBossLayout:UpdateDataBoss()
    if self.eventModel.eventLunarBossData ~= nil then
        self.currentChap = self.eventModel.eventLunarBossData.currentChap
        self.passChap = self.eventModel.eventLunarBossData.recentPassedChap
        self.isClearBoss = self.currentChap == self.passChap
    else
        self.currentChap = 0
        self.passChap = 0
        self.isClearBoss = 0
    end
end

---@param eventLunarBossDetailInBound EventLunarBossDetailInBound
function UIEventLunarBossLayout:UpdateDataBossDetail(eventLunarBossDetailInBound)
    local isClaim = self.eventModel.receivedRewardHistory:Get(self.currentBossPreview.chapter) == true
    if eventLunarBossDetailInBound == nil then
        self.layoutConfig.textGuildDamageValue.transform.parent.gameObject:SetActive(false)
        self.layoutConfig.textSelfDamageValue.transform.parent.gameObject:SetActive(false)
        self.layoutConfig.bgBossHpBar.fillAmount = 1
        self.layoutConfig.textHp.text = "100%"
    else
        self.layoutConfig.textGuildDamageValue.transform.parent.gameObject:SetActive(true)
        self.layoutConfig.textSelfDamageValue.transform.parent.gameObject:SetActive(true)
        local battleTeamInfo = self.currentBossPreview.defenderTeam:GetBattleTeamInfo()
        if eventLunarBossDetailInBound:IsClearChapter() then
            self.layoutConfig.bgBossHpBar.fillAmount = 0
        else
            self.layoutConfig.bgBossHpBar.fillAmount = ClientConfigUtils.GetPercentHpBattle(battleTeamInfo, eventLunarBossDetailInBound.listHeroStateInBound)
        end
        self.layoutConfig.textHp.text = string.format("%s%%", math.floor(self.layoutConfig.bgBossHpBar.fillAmount * 100))
        self.layoutConfig.textGuildDamageValue.text = tostring(eventLunarBossDetailInBound.totalDamageDeal)
        self.layoutConfig.textSelfDamageValue.text = tostring(eventLunarBossDetailInBound.playerDamageDeal)
        if isClaim == false and eventLunarBossDetailInBound.isClaim == true then
            isClaim = true
            self.eventModel.receivedRewardHistory:Add(eventLunarBossDetailInBound.chapter, true)
        end
    end
    self:SetClaimReward(isClaim)
end

function UIEventLunarBossLayout:IsClearBoss(chapter)
    return chapter < self.currentChap or ((self.isClearBoss == true) and (chapter == self.currentChap))
end

function UIEventLunarBossLayout:OnShow()
    UIEventLunarPathLayout.OnShow(self)
    self:UpdateDataBoss()
    self.stamina = self.eventConfig:GetStaminaBossConfig()
    self.layoutConfig.textTicket.text = tostring(self.stamina)
    self.listChapterBossConfig = self.eventConfig:GetListLunarBossConfig()
    ---@param v LunarBossConfig
    for i, v in ipairs(self.listChapterBossConfig:GetItems()) do
        --- @type UILunarBossChapterItemView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UILunarBossChapterItemView, self.layoutConfig.layerBossChapter)
        iconView:SetData(v.chapter, v.pointRequire, function()
            self:OnClickBoss(v)
        end)
        self.listChapterView:Add(iconView)
    end

    if self.moneyBarView == nil then
        self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBar)
        self.moneyBarView:SetIconData(MoneyType.EVENT_LUNAR_NEW_YEAR_CHALLENGE_STAMINA, true)
        self.moneyBarView:AddListener(function()
            self:ShowBuyTicket()
        end)
    end

    self:UpdateChapterBossProgress()

    self:ShowCurrentBoss(math.max(self.currentChap, 1))
end

function UIEventLunarBossLayout:UpdateChapterBossProgress()
    ---@param v UILunarBossChapterItemView
    for i, v in ipairs(self.listChapterView:GetItems()) do
        v:SetUnlockBoss(self.currentChap, self.passChap)
    end
    local point = InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_LUNAR_NEW_GUILD_POINT)
    if self.eventModel.eventLunarBossData ~= nil then
        point = point + self.eventModel.eventLunarBossData.totalGuildPoint
    end
    self.layoutConfig.textGuildPoint.text = point
    local lassPointChapterClear = 0
    self.layoutConfig.progressBar.fillAmount = 1
    ---@param v LunarBossConfig
    for i, v in ipairs(self.listChapterBossConfig:GetItems()) do
        if v.pointRequire <= point then
            lassPointChapterClear = v.pointRequire
        else
            self.layoutConfig.progressBar.fillAmount = (1 / self.listChapterBossConfig:Count()) * (i - 1 + (point - lassPointChapterClear) / (v.pointRequire - lassPointChapterClear))
            break
        end
    end
end

function UIEventLunarBossLayout:SetClaimReward(isClaim)
    --XDebug.Log(isClaim)
    ---@param iconView RewardInBound
    for i, iconView in ipairs(self.listReward:GetItems()) do
        iconView:ActiveMaskSelect(isClaim)
    end
end

function UIEventLunarBossLayout:UpdateCurrentBoss(chapter)
    self.layoutConfig.selectBoss:SetParent(self.layoutConfig.layerBossChapter:GetChild(chapter))
    self.layoutConfig.selectBoss.localPosition = U_Vector3.zero
    self.currentBossPreview = self.listChapterBossConfig:Get(chapter)
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
        self.layoutConfig.iconHero.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    ---@type HeroBattleInfo
    local heroBattleInfo = self.currentBossPreview.defenderTeam:GetBattleTeamInfo().listHeroInfo:Get(1)
    local heroResource = HeroResource()
    heroResource:SetData(-1, heroBattleInfo.heroId, heroBattleInfo.star, 1, nil)
    self.layoutConfig.heroNameTxt.text = LanguageUtils.LocalizeNameHero(heroBattleInfo.heroId)
    self.layoutConfig.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(heroBattleInfo.heroId))
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(12000, 12000, 0)
    self.worldSpaceHeroView.config.bg:SetActive(false)

    self.layoutConfig.iconArrow.gameObject:SetActive(chapter < self.listChapterBossConfig:Count())
    self.layoutConfig.iconArrowBack.gameObject:SetActive(chapter > 1)

    local isClearBoss = self:IsClearBoss(chapter)
    if chapter <= self.passChap then
        self.worldSpaceHeroView.previewHero.clientHero:OnCompleteGettingFreezed(EffectLogType.PETRIFY)
    end
    if chapter == self.currentChap then
        self.layoutConfig.buttonBackCurrentBoss.gameObject:SetActive(false)
        if isClearBoss == true then
            self.layoutConfig.buttonChallenge.gameObject:SetActive(false)
        else
            self.layoutConfig.buttonChallenge.gameObject:SetActive(true)
        end
    else
        if self.currentChap > 0 then
            self.layoutConfig.buttonBackCurrentBoss.gameObject:SetActive(true)
            self.layoutConfig.buttonChallenge.gameObject:SetActive(false)
        else
            self.layoutConfig.buttonBackCurrentBoss.gameObject:SetActive(false)
            self.layoutConfig.buttonChallenge.gameObject:SetActive(false)
        end
    end

    self:ReturnPoolListReward()
    ---@param v RewardInBound
    for _, v in ipairs(self.currentBossPreview.listReward:GetItems()) do
        --- @type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.reward)
        iconView:SetIconData(v:GetIconData())
        iconView:RegisterShowInfo()
        self.listReward:Add(iconView)
    end
end

function UIEventLunarBossLayout:ShowCurrentBoss(chapter)
    zg.playerData.currentChapterLunarBoss = chapter
    self:UpdateCurrentBoss(chapter)

    ---@param eventLunarBossDetailInBound EventLunarBossDetailInBound
    EventLunarBossDetailInBound.CheckData(chapter, function (eventLunarBossDetailInBound, chapterReturn)
        if chapterReturn == self.currentBossPreview.chapter then
            if chapterReturn >= self.currentChap and eventLunarBossDetailInBound ~= nil then
                self.eventModel.eventLunarBossData = eventLunarBossDetailInBound.eventLunarBossData
                self:RefreshUI()
            end
            self:UpdateDataBossDetail(eventLunarBossDetailInBound)
        end
    end)
end

function UIEventLunarBossLayout:RefreshUI()
    self:UpdateDataBoss()
    self:UpdateChapterBossProgress()
    self:UpdateCurrentBoss(self.currentBossPreview.chapter)
end

function UIEventLunarBossLayout:ReturnPoolListReward()
    ---@param v IconView
    for i, v in ipairs(self.listReward:GetItems()) do
        v:ReturnPool()
    end
    self.listReward:Clear()
end

function UIEventLunarBossLayout:OnHide()
    UIEventLunarPathLayout.OnHide(self)

    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end

    ---@param v IconView
    for i, v in ipairs(self.listChapterView:GetItems()) do
        v:ReturnPool()
    end
    self.listChapterView:Clear()

    if self.moneyBarView ~= nil then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end

    self:ReturnPoolListReward()
end

function UIEventLunarBossLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_boss", self.anchor)
    UIEventLunarPathLayout.InitLayoutConfig(self, inst)
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEventLunarBossLayout:ShowBuyTicket()
    self.view:OnClickSelectTab(LunarPathTab.SHOP)
end

---@param bossConfig LunarBossConfig
function UIEventLunarBossLayout:OnClickBoss(bossConfig)
    if bossConfig.chapter ~= self.currentBossPreview.chapter then
        self:ShowCurrentBoss(bossConfig.chapter)
    end
end

function UIEventLunarBossLayout:OnClickNextChapter()
    self:ShowCurrentBoss(self.currentBossPreview.chapter + 1)
end

function UIEventLunarBossLayout:OnClickBackChapter()
    self:ShowCurrentBoss(self.currentBossPreview.chapter - 1)
end

function UIEventLunarBossLayout:OnClickCurrentBoss()
    self:ShowCurrentBoss(self.currentChap)
end

function UIEventLunarBossLayout:RequestLunarBossStatistic(chapter, callbackSuccess, callbackFailed)
    if zg.playerData.dictLunarBossStatistic == nil then
        zg.playerData.dictLunarBossStatistic = Dictionary()
    end
    ---@type BossStatisticsInBound
    local bossStatisticsInBound = zg.playerData.dictLunarBossStatistic:Get(chapter)
    if bossStatisticsInBound == nil or bossStatisticsInBound.lastRequest == nil
            or (chapter == self.currentChap and zg.timeMgr:GetServerTime() - bossStatisticsInBound.lastRequest > 60) then
        local onReceived = function(result)
            ---@type BossStatisticsInBound
            local bossStatisticsInBound = nil
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                bossStatisticsInBound = BossStatisticsInBound(buffer, chapter)
            end
            --- @param logicCode LogicCode
            local onSuccess = function()
                zg.playerData.dictLunarBossStatistic:Add(chapter , bossStatisticsInBound)
                if callbackSuccess ~= nil then
                    callbackSuccess(bossStatisticsInBound)
                end
            end
            --- @param logicCode LogicCode
            local onFailed = function(logicCode)
                if callbackFailed ~= nil then
                    callbackFailed()
                end
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.EVENT_LUNAR_NEW_YEAR_BOSS_STATISTICS_GET, UnknownOutBound.CreateInstance(PutMethod.Int, chapter), onReceived, true)
    else
        if callbackSuccess ~= nil then
            callbackSuccess(bossStatisticsInBound)
        end
    end
end

function UIEventLunarBossLayout:OnClickLog()
    self:RequestLunarBossStatistic(self.currentBossPreview.chapter, function (bossStatisticsInBound)
        PopupMgr.ShowPopup(UIPopupName.UIPopupDamageStats, { ["bossStatisticsInBound"] = bossStatisticsInBound })
    end, function (logicCode)
        PopupMgr.ShowPopup(UIPopupName.UIPopupDamageStats)
    end)
end

function UIEventLunarBossLayout:InitButtonListener()
    self.layoutConfig.buttonChallenge.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonChallenge()
    end)
    self.layoutConfig.buttonRanking.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ShowLeaderBoard()
    end)
    self.layoutConfig.iconArrowBack.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackChapter()
    end)
    self.layoutConfig.iconArrow.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickNextChapter()
    end)
    self.layoutConfig.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLog()
    end)
    self.layoutConfig.buttonBackCurrentBoss.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCurrentBoss()
    end)
end

function UIEventLunarBossLayout:InitLocalization()
    UIEventLunarPathLayout.InitLocalization(self)
    self.layoutConfig.textButton.text = LanguageUtils.LocalizeCommon("challenge")
    self.layoutConfig.textBackCurrentBoss.text = LanguageUtils.LocalizeCommon("back_to_current")
    self.layoutConfig.textSelfDamage.text = LanguageUtils.LocalizeCommon("self_damage")
    self.layoutConfig.textGuildDamage.text = LanguageUtils.LocalizeCommon("guild_damage")
end

function UIEventLunarBossLayout:OnClickButtonChallenge()
    local staminaInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_LUNAR_NEW_YEAR_CHALLENGE_STAMINA, self.stamina)
    if InventoryUtils.IsEnoughSingleResourceRequirement(staminaInBound) then
        self:ShowFormation()
    end
end

function UIEventLunarBossLayout:ShowLeaderBoard()
    PopupUtils.ShowLeaderBoard(LeaderBoardType.LUNAR_BOSS_RANKING)
end

--- @return void
function UIEventLunarBossLayout:ShowFormation()
    if self.eventModel.isInGuild
            and self.eventModel.eventLunarBossData.currentChap > self.eventModel.eventLunarBossData.recentPassedChap then
        ---@type LunarBossConfig
        local lunarBossConfig = self.eventConfig:GetLunarBossConfigByChapter(self.eventModel.eventLunarBossData.currentChap)
        ---@type DefenderTeamData
        local dataStage = lunarBossConfig.defenderTeam
        ---@type BattleTeamInfo
        local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
        --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
        local result = {}
        result.gameMode = GameMode.EVENT_LUNAR_NEW_YEAR_GUILD_BOSS
        result.battleTeamInfo = battleTeamInfo

        ---@type EventLunarBossDetailInBound
        local  eventLunarBossDetailInBound = EventLunarBossDetailInBound.GetCacheEventLunarBossDetailInBound(self.currentChap)
        ---@param listHeroStateInBound List
        local setDataDefenderTeam = function(listHeroStateInBound)
            if eventLunarBossDetailInBound ~= nil then
                --- @param v HeroStateInBound
                for _, v in pairs(listHeroStateInBound:GetItems()) do
                    result.battleTeamInfo:SetState(GameMode.GUILD_DUNGEON, v.isFrontLine, v.position, v.hp, v.power)
                end
            end
        end
        setDataDefenderTeam(eventLunarBossDetailInBound.listHeroStateInBound )

        result.powerDefenderTeam = dataStage:GetPowerTeam()
        result.callbackClose = function()
            PopupMgr.HidePopup(UIPopupName.UIFormation)
            local data = {}
            data.tab = 3
            PopupMgr.ShowPopup(UIPopupName.UIEventLunarPath, data)
        end
        result.callbackPlayBattle = function(uiFormationTeamData, callback)
            ---@type LunarChallengeBossInBound
            local lunarChallengeBossInBound = nil
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                require("lua.client.core.network.event.eventLunarNewYear.LunarChallengeBossInBound")
                lunarChallengeBossInBound = LunarChallengeBossInBound(buffer)
            end
            local callbackSuccess = function()
                if zg.playerData.dictLunarBossStatistic ~= nil then
                    ---@type BossStatisticsInBound
                    local bossStatisticsInBound = zg.playerData.dictLunarBossStatistic:Get(self.currentChap)
                    if bossStatisticsInBound ~= nil then
                        bossStatisticsInBound.lastRequest = nil
                    end
                end
                if zg.playerData.dictLunarBossRanking ~= nil then
                    ---@type EventLunarBossRankingInBound
                    local eventLunarBossRankingInBound = zg.playerData.dictLunarBossRanking:Get(self.currentChap)
                    if eventLunarBossRankingInBound ~= nil then
                        eventLunarBossRankingInBound.lastRequest = nil
                    end
                end

                eventLunarBossDetailInBound.lastTimeRequest = nil
                lunarChallengeBossInBound.battleResultInfo.seedInBound:Initialize()
                InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_LUNAR_NEW_YEAR_CHALLENGE_STAMINA, self.stamina)
                zg.playerData.rewardList = RewardInBound.GetItemIconDataList(lunarChallengeBossInBound.listReward)
                zg.playerData:AddListRewardToInventory()
                if callback ~= nil then
                    callback()
                end
                zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
                if lunarChallengeBossInBound.battleResultInfo.isWin then
                    EventInBound.RequestEventDataByType(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022)
                end
            end

            zg.playerData:CheckDataLinking(function()
                XDebug.Log(LogUtils.ToDetail(eventLunarBossDetailInBound))
                require("lua.client.core.network.event.eventLunarNewYear.LunarChallengeBossOutBound")
                NetworkUtils.RequestAndCallback(OpCode.EVENT_LUNAR_NEW_YEAR_BOSS_CHALLENGE, LunarChallengeBossOutBound(BattleFormationOutBound(uiFormationTeamData), 1, self.currentChap, eventLunarBossDetailInBound.bossCreateTime), callbackSuccess,
                        SmartPoolUtils.LogicCodeNotification, onBufferReading)
            end, true)

        end
        PopupMgr.HidePopup(UIPopupName.UIEventLunarPath)
        PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
    end
end