--- @class UIKazetsuBossLayout : UIEventKazetsuLayout
UIKazetsuBossLayout = Class(UIKazetsuBossLayout, UIEventKazetsuLayout)

--- @param view UIEventView
function UIKazetsuBossLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventValentineConfig
    self.eventConfig = nil
    --- @type
    self.listReward = List()
    --- @type ListSkillView
    self.listSkillView = nil
    --- @type WorldSpaceHeroView
    self.worldSpaceHeroView = nil

    --- @type number
    self.heroId = HeroConstants.KAZETSU_HERO_ID
    self.skinId = HeroConstants.KAZETSU_HERO_ID
    --- @type UIKazetsuChallengeLayoutConfig
    self.layoutConfig = nil

    --- @type EventValentineBossChallengeConfig
    self.bossChallengeConfig = nil
    --- @type RewardInBound
    self.staminaInBound = nil
    UIEventKazetsuLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIKazetsuBossLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("kazetsu_boss_layout", self.anchor)
    UIEventKazetsuLayout.InitLayoutConfig(self, inst)
    self.listSkillView = ListSkillView(self.layoutConfig.iconSkillSystem, U_Vector2(0.5, 0), self.layoutConfig.iconSkillPreview)
    self.layoutConfig.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(self.heroId))
    self:InitButtonListener()
    self:InitLocalization()
    local onCreateItem = function(obj, index)
        ---@type  BossChallengeRewardMilestoneData
        local bossMilestoneReward =  self.bossChallengeConfig.listBossDamageRewardConfig:Get(index + 1)
        obj:SetIconData(bossMilestoneReward.listInstantReward, bossMilestoneReward.listAllReward, index + 1)
    end

    self.scrollReward = UILoopScroll(self.layoutConfig.scroll, UIPoolType.ChestKazetsuItemView, onCreateItem)
end

function UIKazetsuBossLayout:InitButtonListener()
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
end

function UIKazetsuBossLayout:InitLocalization()
    UIEventKazetsuLayout.InitLocalization(self)
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("kazetsu_boss_title")
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("kazetsu_boss_des")
    self.layoutConfig.textRewardTitle.text = LanguageUtils.LocalizeCommon("reward")
    self.layoutConfig.textButton.text = LanguageUtils.LocalizeCommon("challenge")
    self.layoutConfig.heroNameTxt.text = LanguageUtils.LocalizeNameHero(self.heroId)
    self.layoutConfig.textTicket.text = LanguageUtils.LocalizeCommon("remaining_attempts")
end

function UIKazetsuBossLayout:OnShow()
    UIEventKazetsuLayout.OnShow(self)
    self.bossChallengeConfig = self.eventConfig:GetBossChallengeConfig()
    self.staminaInBound = self.bossChallengeConfig.challengePriceList:Get(1)

    self.scrollReward:Resize(self.bossChallengeConfig.listBossDamageRewardConfig:Count())
    self:ShowUiTurn()
    self.listSkillView:SetDataHero(HeroResource.CreateInstance(nil, self.heroId, 13, 1), false)

    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
        self.layoutConfig.iconHero.texture = renderTexture
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


function UIKazetsuBossLayout:ShowUiTurn()
    self.layoutConfig.textTurnLeft.text = string.format("%s/%s",
            InventoryUtils.Get(ResourceType.Money, self.staminaInBound.id),
            self.bossChallengeConfig.defaultStamina)
end

function UIKazetsuBossLayout:OnHide()
    UIEventKazetsuLayout.OnHide(self)
    self.scrollReward:Hide()
    self.listSkillView:ReturnPool()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

function UIKazetsuBossLayout:OnClickButtonChallenge()
    if InventoryUtils.IsEnoughSingleResourceRequirement(self.staminaInBound, false) then
        self:ShowFormation()
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
    end
end

--- @return void
function UIKazetsuBossLayout:ShowFormation()
    ---@type DefenderTeamData
    local dataStage = self.bossChallengeConfig:GetDefenderTeamData()
    ---@type BattleTeamInfo
    local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
    --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
    local result = {}
    result.gameMode = GameMode.EVENT_KAZETSU_BOSS
    result.battleTeamInfo = battleTeamInfo
    result.powerDefenderTeam = dataStage:GetPowerTeam()
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation)
        local data = {}
        data.tab = EventKazetsuTab.BOSS
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

            self.view:UpdateNotificationByTab(self.eventKazetsuTab)
        end
        NetworkUtils.RequestAndCallback(OpCode.EVENT_KAZETSU_BOSS_CHALLENGE,
                BattleFormationOutBound(uiFormationTeamData),
                callbackSuccess,
                SmartPoolUtils.LogicCodeNotification, onBufferReading)
    end
    PopupMgr.HidePopup(self.model.uiName)
    PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end

--- @return void
function UIKazetsuBossLayout:OnClickLeaderBoard()
    PopupMgr.ShowPopup(UIPopupName.UIKazetsuBossLeaderboard)
end



function UIKazetsuBossLayout:OnClickBuyTurn()
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
            NetworkUtils.Request(OpCode.EVENT_KAZETSU_STAMINA_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, numberReturn), callback)
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


