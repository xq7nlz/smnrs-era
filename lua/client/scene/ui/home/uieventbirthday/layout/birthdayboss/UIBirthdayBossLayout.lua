--- @class UIBirthdayBossLayout : UIEventBirthdayLayout
UIBirthdayBossLayout = Class(UIBirthdayBossLayout, UIEventBirthdayLayout)

--- @param view UIEventView
function UIBirthdayBossLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventBirthdayConfig
    self.eventConfig = nil
    --- @type
    self.listReward = List()
    --- @type ListSkillView
    self.listSkillView = nil
    --- @type WorldSpaceHeroView
    self.worldSpaceHeroView = nil

    --- @type number
    self.heroId = HeroConstants.CELESTIAL_HERO_ID
    self.skinId = HeroConstants.CELESTIAL_HERO_ID
    --- @type UIBirthdayChallengeLayoutConfig
    self.layoutConfig = nil

    --- @type EventBirthdayBossChallengeConfig
    self.bossChallengeConfig = nil
    --- @type RewardInBound
    self.staminaInBound = nil
    UIEventBirthdayLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIBirthdayBossLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("birthday_boss_layout", self.anchor)
    UIEventBirthdayLayout.InitLayoutConfig(self, inst)
    self.listSkillView = ListSkillView(self.layoutConfig.iconSkillSystem, U_Vector2(0.5, 0), self.layoutConfig.iconSkillPreview)
    self:InitButtonListener()
    self:InitLocalization()
    local onCreateItem = function(obj, index)
        ---@type  BossChallengeRewardMilestoneData
        local bossMilestoneReward = self.bossChallengeConfig.listBossDamageRewardConfig:Get(index + 1)
        obj:SetIconData(bossMilestoneReward.listInstantReward, bossMilestoneReward.listAllReward, index + 1)
    end

    self.scrollReward = UILoopScroll(self.layoutConfig.scroll, UIPoolType.ChestBirthdayItemView, onCreateItem)
end

function UIBirthdayBossLayout:InitButtonListener()
    self.layoutConfig.buttonChallenge.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonChallenge()
    end)
    self.layoutConfig.buttonBuyTurn.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuyTurn()
    end)
    self.layoutConfig.buttonLeaderBoard.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLeaderBoard()
    end)
    self.layoutConfig.buttonNavigateToDarkLight.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnNavigateToDarkLight()
    end)

    self.layoutConfig.buttonHelpPreboss.onClick:AddListener(
            function()
                self:OnClickHelpInfo()
                zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            end
    )
end

function UIBirthdayBossLayout:OnNavigateToDarkLight()
    self.view:SelectTab(EventBirthdayTab.DARK_LIGHT)
end

function UIBirthdayBossLayout:OnClickHelpInfo()
    local helpText = LanguageUtils.LocalizeHelpInfo("event_2nd_birthday_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, helpText)
end

function UIBirthdayBossLayout:InitLocalization()
    UIEventBirthdayLayout.InitLocalization(self)
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("birthday_boss_title")
    self.layoutConfig.toDarkLight.text = LanguageUtils.LocalizeCommon("navigate_to_dark_light")
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("birthday_boss_des")
    self.layoutConfig.textRewardTitle.text = LanguageUtils.LocalizeCommon("reward")
    self.layoutConfig.textButton.text = LanguageUtils.LocalizeCommon("challenge")
    self.layoutConfig.textTicket.text = LanguageUtils.LocalizeCommon("remaining_attempts")
    self.layoutConfig.preBossDesc.text = LanguageUtils.LocalizeCommon("preboss_des")
end

function UIBirthdayBossLayout:OnShow()
    UIEventBirthdayLayout.OnShow(self)
    self:InitLocalization()
    if self.eventModel.selectSideId < 5 then
        self.layoutConfig.PreBossLayout:SetActive(true)
        self.layoutConfig.iconHero.gameObject:SetActive(false)
        return
    else
        self.layoutConfig.iconHero.gameObject:SetActive(true)
        self.layoutConfig.PreBossLayout:SetActive(false)
    end
    self.bossChallengeConfig = self.eventModel:GetConfig().bossConfig
    self.staminaInBound = self.bossChallengeConfig.challengePriceList:Get(1)
    self.scrollReward:Resize(self.bossChallengeConfig.listBossDamageRewardConfig:Count())
    self:ShowUiTurn()
    self.heroId = self.eventModel:GetOppositeHeroId()
    local isLight = ClientConfigUtils.GetFactionIdByHeroId(self.heroId) == HeroFactionType.LIGHT
    self.layoutConfig.bgDark:SetActive(not isLight)
    self.layoutConfig.bgLight:SetActive(isLight)
    self.listSkillView:SetDataHero(HeroResource.CreateInstance(nil, self.heroId, 13, 1), false)
    local factionType = ClientConfigUtils.GetFactionIdByHeroId(self.heroId)
    self.layoutConfig.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(factionType)
    self.layoutConfig.heroNameTxt.text = LanguageUtils.LocalizeNameHero(self.heroId)
    self.layoutConfig.glow.color = UIUtils.text_dark_color_with_faction_type[factionType]
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(2000, 2000, 24, U_RenderTextureFormat.ARGB32)
        self.layoutConfig.iconHero.texture = renderTexture
        self.worldSpaceHeroView:SetSizeCamera(5)
        self.worldSpaceHeroView:Init(renderTexture)
    end
    local heroResource = HeroResource()
    local heroItem = Dictionary()
    --heroItem:Add(7, self.skinId)

    heroResource:SetData(-1, self.heroId, 13, 1, heroItem)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(11000, 11000, 0)
    self.worldSpaceHeroView.config.bg:SetActive(false)
end

function UIBirthdayBossLayout:ShowUiTurn()
    self.layoutConfig.textTurnLeft.text = string.format("%s/%s",
            InventoryUtils.Get(ResourceType.Money, self.staminaInBound.id),
            self.bossChallengeConfig.defaultStamina)
end

function UIBirthdayBossLayout:OnHide()
    UIEventBirthdayLayout.OnHide(self)
    self.scrollReward:Hide()
    self.listSkillView:ReturnPool()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

function UIBirthdayBossLayout:OnClickButtonChallenge()
    if InventoryUtils.IsEnoughSingleResourceRequirement(self.staminaInBound, false) then
        local remainingTime = zg.timeMgr:GetRemainingTime()
        local blockTime = self.eventConfig:GetChallengeConfig().blockDuration
        if remainingTime > blockTime then
            self:ShowFormation()
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("time_out"))
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
    end
end

--- @return void
function UIBirthdayBossLayout:ShowFormation()
    ---@type DefenderTeamData
    local dataStage = self.eventModel:GetOppositeBossData()
    ---@type BattleTeamInfo
    local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
    --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
    local result = {}
    result.gameMode = GameMode.EVENT_BIRTHDAY_BOSS
    result.battleTeamInfo = battleTeamInfo
    result.powerDefenderTeam = dataStage:GetPowerTeam()
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation)
        local data = {}
        data.tab = EventBirthdayTab.BOSS
        PopupMgr.ShowPopup(self.model.uiName, data)
    end
    result.callbackPlayBattle = function(uiFormationTeamData, callback)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            self:GetModelConfig()
            require "lua.client.core.network.event.eventXmasModel.ChristmasChallengeBossInBound"
            --- @type ChristmasChallengeBossInBound
            self.eventModel.eventBossChallengeInBound = ChristmasChallengeBossInBound(buffer)
        end
        local callbackSuccess = function()
            InventoryUtils.SubSingleRewardInBound(self.staminaInBound)
            zg.playerData.rewardList = RewardInBound.GetItemIconDataList(self.eventModel.eventBossChallengeInBound.listReward)
            zg.playerData:AddListRewardToInventory()
            zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
            if callback ~= nil then
                callback()
            end

            self.view:UpdateNotificationByTab(self.eventBirthdayTab)
        end
        NetworkUtils.RequestAndCallback(OpCode.EVENT_BIRTHDAY_BOSS_CHALLENGE,
                BattleFormationOutBound(uiFormationTeamData),
                callbackSuccess,
                SmartPoolUtils.LogicCodeNotification, onBufferReading)
    end
    PopupMgr.HidePopup(self.model.uiName)
    PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end

--- @return void
function UIBirthdayBossLayout:OnClickLeaderBoard()
    PopupMgr.ShowPopup(UIPopupName.UIEventBirthdayBossLeaderBoard)
end

function UIBirthdayBossLayout:OnClickBuyTurn()
    self:GetModelConfig()
    local maxCountBuyTurn = self.bossChallengeConfig.maxNumberBuy - self.eventModel.numberBuyBossTurn
    if maxCountBuyTurn > 0 then
        local callback = function(numberReturn, priceTotal)
            local callback = function(result)
                local onSuccess = function()
                    InventoryUtils.Sub(self.bossChallengeConfig.staminaPrice.type, self.bossChallengeConfig.staminaPrice.id, priceTotal)
                    InventoryUtils.Add(ResourceType.Money, self.staminaInBound.id, numberReturn)
                    self.eventModel:BuyBossTurnSuccess(numberReturn)
                    self:ShowUiTurn()
                end
                local onFailed = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                end
                NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
            end
            NetworkUtils.Request(OpCode.EVENT_BIRTHDAY_STAMINA_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, numberReturn), callback)
        end
        ---@type PopupBuyItemData
        local dataPurchase = PopupBuyItemData()
        dataPurchase:SetData(ResourceType.Money, self.bossChallengeConfig.staminaPrice.id, 1, 1, maxCountBuyTurn,
                self.bossChallengeConfig.staminaPrice.id, self.bossChallengeConfig.staminaPrice.number,
                callback, LanguageUtils.LocalizeCommon("buy_turn"),
                LanguageUtils.LocalizeCommon("buy"), false)

        PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItemString, dataPurchase)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_buy_turn_daily"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end


