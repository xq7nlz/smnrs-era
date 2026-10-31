--- @class UIEventValentineLoveChallengeLayout : UIEventValentineLayout
UIEventValentineLoveChallengeLayout = Class(UIEventValentineLoveChallengeLayout, UIEventValentineLayout)

--- @param view UIEventView
function UIEventValentineLoveChallengeLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventValentineModel
    self.eventModel = nil
    --- @type EventValentineConfig
    self.eventConfig = nil
    --- @type
    self.listReward = List()
    --- @type ListSkillView
    self.listSkillView = nil
    --- @type WorldSpaceHeroView
    self.worldSpaceHeroView = nil

    --- @type number
    self.heroId = 50001
    self.skinId = 50001001
    --- @type UIValentineLoveChallengeLayoutConfig
    self.layoutConfig = nil

    --- @type EventValentineBossChallengeConfig
    self.bossChallengeConfig = nil
    --- @type RewardInBound
    self.staminaInBound = nil
    UIEventValentineLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventValentineLoveChallengeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("valentine_love_challenge", self.anchor)
    UIEventValentineLayout.InitLayoutConfig(self, inst)
    self.listSkillView = ListSkillView(self.layoutConfig.iconSkillSystem, U_Vector2(0.5, 0), self.layoutConfig.iconSkillPreview)
    self.layoutConfig.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(self.heroId))
    self:InitButtonListener()
    self:InitLocalization()
end

function UIEventValentineLoveChallengeLayout:InitButtonListener()
    self.layoutConfig.buttonChallenge.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonChallenge()
    end)
    self.layoutConfig.buttonBuyTurn.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuyTurn()
    end)
end

function UIEventValentineLoveChallengeLayout:InitLocalization()
    UIEventValentineLayout.InitLocalization(self)
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("valentine_love_challenge_title")
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("valentine_love_challenge_des")
    self.layoutConfig.textRewardTitle.text = LanguageUtils.LocalizeCommon("reward")
    self.layoutConfig.textButton.text = LanguageUtils.LocalizeCommon("challenge")
    self.layoutConfig.heroNameTxt.text = LanguageUtils.LocalizeNameHero(self.heroId)
    self.layoutConfig.textTicket.text = LanguageUtils.LocalizeCommon("remaining_attempts")
end

function UIEventValentineLoveChallengeLayout:OnShow()
    UIEventValentineLayout.OnShow(self)
    self.bossChallengeConfig = self.eventConfig:GetBossChallengeConfig()
    self.staminaInBound = self.bossChallengeConfig.challengePriceList:Get(1)

    ---@param v BossChallengeRewardMilestoneData
    for i, v in ipairs(self.bossChallengeConfig.listBossDamageRewardConfig:GetItems()) do
        --- @type ChestIgnatiusItemView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ChestIgnatiusItemView, self.layoutConfig.iconItemRewardPool)
        iconView:SetIconData(v.listInstantReward, v.listAllReward, i)
        self.listReward:Add(iconView)
    end
    self:ShowUiTurn()
    self.listSkillView:SetDataHero(HeroResource.CreateInstance(nil, self.heroId, 7, 1), false)

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
    heroItem:Add(7, self.skinId)
    heroResource:SetData(-1, self.heroId, 7, 1, heroItem)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(11000, 11000, 0)
    self.worldSpaceHeroView.config.bg:SetActive(false)
end

function UIEventValentineLoveChallengeLayout:ShowUiTurn()
    self.layoutConfig.textTurnLeft.text = string.format("%s/%s",
            InventoryUtils.Get(ResourceType.Money, self.staminaInBound.id),
            self.bossChallengeConfig.defaultStamina)
end

function UIEventValentineLoveChallengeLayout:OnHide()
    UIEventValentineLayout.OnHide(self)
    --- @param v ChestIgnatiusItemView
    for _, v in ipairs(self.listReward:GetItems()) do
        v:ReturnPool()
    end
    self.listReward:Clear()
    self.listSkillView:ReturnPool()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

function UIEventValentineLoveChallengeLayout:OnClickButtonChallenge()
    if InventoryUtils.IsEnoughSingleResourceRequirement(self.staminaInBound, false) then
        self:ShowFormation()
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
    end
end

--- @return void
function UIEventValentineLoveChallengeLayout:ShowFormation()
    ---@type DefenderTeamData
    local dataStage = self.bossChallengeConfig:GetDefenderTeamData()
    ---@type BattleTeamInfo
    local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
    --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
    local result = {}
    result.gameMode = GameMode.EVENT_VALENTINE_BOSS
    result.battleTeamInfo = battleTeamInfo
    result.powerDefenderTeam = dataStage:GetPowerTeam()
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation)
        local data = {}
        data.tab = 2
        PopupMgr.ShowPopup(self.model.uiName, data)
    end
    result.callbackPlayBattle = function(uiFormationTeamData, callback)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
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

            self.view:UpdateNotificationByTab(self.valentineTab)
        end
        NetworkUtils.RequestAndCallback(OpCode.EVENT_VALENTINE_BOSS_CHALLENGE,
                BattleFormationOutBound(uiFormationTeamData),
                callbackSuccess,
                SmartPoolUtils.LogicCodeNotification, onBufferReading)
    end
    PopupMgr.HidePopup(self.model.uiName)
    PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end

function UIEventValentineLoveChallengeLayout:OnClickBuyTurn()
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
            NetworkUtils.Request(OpCode.EVENT_VALENTINE_STAMINA_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, numberReturn), callback)
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