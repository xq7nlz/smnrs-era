--- @class UIEventFrostyIgnatiusLayout : UIEventXmasLayout
UIEventFrostyIgnatiusLayout = Class(UIEventFrostyIgnatiusLayout, UIEventXmasLayout)

--- @param view UIEventView
function UIEventFrostyIgnatiusLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventXmasModel
    self.eventModel = nil
    --- @type EventXmasConfig
    self.eventConfig = nil
    ---@type
    self.listReward = List()
    ---@type ListSkillView
    self.listSkillView = nil
    ---@type WorldSpaceHeroView
    self.worldSpaceHeroView = nil

    ---@type number
    self.heroId = 50011
    ---@type UIEventIgnatiusConfig
    self.layoutConfig = nil

    UIEventXmasLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventFrostyIgnatiusLayout:OnShow()
    UIEventXmasLayout.OnShow(self)
    local listIgnatiusConfig = self.eventConfig:GetListIgnatiusConfig()
    ---@param v BossChallengeRewardMilestoneData
    for i, v in ipairs(listIgnatiusConfig:GetItems()) do
        --- @type ChestIgnatiusItemView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ChestIgnatiusItemView, self.layoutConfig.iconItemRewardPool)
        iconView:SetIconData(v.listInstantReward, v.listAllReward, i)
        self.listReward:Add(iconView)
    end
    self.layoutConfig.textTicket.text = string.format("%s %s", LanguageUtils.LocalizeCommon("remaining_attempts"), InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_STAMINA))

    self.listSkillView:SetDataHero(HeroResource.CreateInstance(nil, self.heroId, 7, 1), false)

    self:ShowBossView()
end

function UIEventFrostyIgnatiusLayout:ShowBossView()
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
    heroItem:Add(7, 50011001)
    heroResource:SetData(-1, 50011, 7, 1, heroItem)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(0, 100, 0)
    self.worldSpaceHeroView.config.bg:SetActive(false)
end

function UIEventFrostyIgnatiusLayout:OnHide()
    UIEventXmasLayout.OnHide(self)
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

function UIEventFrostyIgnatiusLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("xmas_frosty_ignatius", self.anchor)
    UIEventXmasLayout.InitLayoutConfig(self, inst)
    self.listSkillView = ListSkillView(self.layoutConfig.iconSkillSystem , U_Vector2(0.5,0), self.layoutConfig.iconSkillPreview)
    self.layoutConfig.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(self.heroId))
    self:InitButtonListener()
    self:InitLocalization()
end


function UIEventFrostyIgnatiusLayout:InitButtonListener()
    self.layoutConfig.buttonChallenge.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonChallenge()
    end)
    self.layoutConfig.buttonRanking.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ShowLeaderBoard()
    end)
end

function UIEventFrostyIgnatiusLayout:InitLocalization()
    UIEventXmasLayout.InitLocalization(self)
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("event_ignatius_desc")
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_ignatius_name")
    self.layoutConfig.textRewardTitle.text = LanguageUtils.LocalizeCommon("reward")
    self.layoutConfig.textButton.text = LanguageUtils.LocalizeCommon("challenge")
    self.layoutConfig.heroNameTxt.text = LanguageUtils.LocalizeNameHero(self.heroId)
end

function UIEventFrostyIgnatiusLayout:OnClickButtonChallenge()
    if InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_STAMINA) > 0 then
        self:ShowFormation()
    else
        SmartPoolUtils.NotiLackResource(MoneyType.EVENT_CHRISTMAS_STAMINA)
    end
end

function UIEventFrostyIgnatiusLayout:ShowLeaderBoard()
    PopupUtils.ShowLeaderBoard(LeaderBoardType.IGNATIUS_SEASON_RANKING)
end

--- @return void
function UIEventFrostyIgnatiusLayout:ShowFormation()
    ---@type DefenderTeamData
    local dataStage = self.eventConfig:GetDefenderTeamData()
    ---@type BattleTeamInfo
    local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
    --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
    local result = {}
    result.gameMode = GameMode.EVENT_CHRISTMAS
    result.battleTeamInfo = battleTeamInfo
    result.powerDefenderTeam = dataStage:GetPowerTeam()
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation)
        local data = {}
        data.tab = 2
        PopupMgr.ShowPopup(UIPopupName.UIEventXmas, data)
    end
    result.callbackPlayBattle = function(uiFormationTeamData, callback)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            ---@type ChristmasChallengeBossInBound
            self.eventModel.christmasChallengeBossInBound = ChristmasChallengeBossInBound(buffer)
        end
        local callbackSuccess = function()
            if self.eventModel.eventIgnatiusRankingInBound ~= nil then
                self.eventModel.eventIgnatiusRankingInBound.lastTimeRequest = nil
            end
            InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_STAMINA, 1)
            zg.playerData.rewardList = RewardInBound.GetItemIconDataList(self.eventModel.christmasChallengeBossInBound.listReward)
            zg.playerData:AddListRewardToInventory()
            if callback ~= nil then
                callback()
            end
            zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
        end

        --zg.playerData:CheckDataLinking(function ()
            require("lua.client.core.network.event.eventXmasModel.ChristmasChallengeBossOutBound")
            NetworkUtils.RequestAndCallback(OpCode.EVENT_CHRISTMAS_CHALLENGE_BOSS, ChristmasChallengeBossOutBound(BattleFormationOutBound(uiFormationTeamData), 1), callbackSuccess,
                    SmartPoolUtils.LogicCodeNotification, onBufferReading)
        --end, true)

    end
    PopupMgr.HidePopup(UIPopupName.UIEventXmas)
    PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end