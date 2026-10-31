require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.bossChallenge.EventChallengeRewardResultInBound"

--- @class UIEventNewHeroBossChallengeLayout : UIEventNewHeroLayout
UIEventNewHeroBossChallengeLayout = Class(UIEventNewHeroBossChallengeLayout, UIEventNewHeroLayout)

function UIEventNewHeroBossChallengeLayout:Ctor(view, xmasTab, anchor)
    --- @type EventNewHeroBossChallengeModel
    self.eventModel = nil
    --- @type EventNewHeroBossChallengeConfig
    self.eventConfig = nil
    --- @type UINewHeroBossChallengeLayoutConfig
    self.layoutConfig = nil

    ---@type Dictionary
    self.dictItemView = nil
    ---@type WorldSpaceHeroView
    self.worldSpaceHeroView = nil
    ---@type ListSkillView
    self.listSkillView = nil

    --- @type number
    self.heroId = nil
    --- @type number
    self.heroStar = nil

    --- @type Dictionary
    self.rewardMilestoneDict = Dictionary()

    UIEventNewHeroLayout.Ctor(self, view, xmasTab, anchor)
end

function UIEventNewHeroBossChallengeLayout:OnShow()
    UIEventNewHeroLayout.OnShow(self)

    self:ShowBossView()

    self:InitLocalization()

    self:ShowBossRewardMilestones()

    self:ShowNumberAttack()
end

function UIEventNewHeroBossChallengeLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.dataId = self.eventModel.timeData.dataId
    self.eventConfig = self.eventModel:GetConfig()

    self.battleTeamInfo = self.eventConfig:GetDefenderTeam():GetBattleTeamInfo()
    --- @type HeroBattleInfo
    local heroBattleInfo = self.battleTeamInfo:GetListHero():Get(1)
    self.heroId = heroBattleInfo.heroId
    self.heroStar = heroBattleInfo.star

    self.layoutConfig.iconFaction.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(self.heroId))
    self.listSkillView = ListSkillView(self.layoutConfig.skillView, U_Vector2(0.5, 0), self.layoutConfig.skillPreview)
    self.layoutConfig.textBossName.text = LanguageUtils.LocalizeNameHero(self.heroId)
end

function UIEventNewHeroBossChallengeLayout:SetUpLayout()
    UIEventNewHeroLayout.SetUpLayout(self)
    self.view:EnableButtonLeaderBoard(true)
end

function UIEventNewHeroBossChallengeLayout:ShowBossView()
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
        self.layoutConfig.bossView.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    local heroResource = HeroResource()
    heroResource:SetData(-1, self.heroId, 7, 1)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(0, 100, 0)
    self.worldSpaceHeroView.config.bg:SetActive(false)

    self.listSkillView:SetDataHero(HeroResource.CreateInstance(nil, self.heroId, self.heroStar, 1), false)
end

function UIEventNewHeroBossChallengeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_hero_boss_challenge", self.anchor)
    UIEventNewHeroLayout.InitLayoutConfig(self, inst)

    self:InitButtons()
end

function UIEventNewHeroBossChallengeLayout:InitButtons()
    self.layoutConfig.buttonChallenge.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChallenge()
    end)
    self.view:SetOnClickLeaderBoard(function()
        self:OnClickLeaderBoard()
    end)
end

function UIEventNewHeroBossChallengeLayout:InitLocalization()
    self.layoutConfig.textTitle.text = LanguageUtils.LocalizeCommon("new_hero_boss_challenge_tittle_" .. self.dataId)
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("new_hero_boss_challenge_desc_" .. self.dataId)
    self.layoutConfig.textDamage.text = LanguageUtils.LocalizeCommon("highest_damage")
    self.layoutConfig.textChallenge.text = LanguageUtils.LocalizeCommon("challenge")
end

function UIEventNewHeroBossChallengeLayout:OnClickChallenge()
    --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
    local result = {}
    result.gameMode = GameMode.EVENT_NEW_HERO_BOSS
    result.battleTeamInfo = self.battleTeamInfo
    result.powerDefenderTeam = self.eventConfig:GetDefenderTeam():GetPowerTeam()
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation)
        local data = {}
        data.eventType = EventTimeType.EVENT_NEW_HERO_BOSS_CHALLENGE
        PopupMgr.ShowPopup(self.view.model.uiName, data)
    end
    result.callbackPlayBattle = function(uiFormationTeamData, callback)
        local callbackSuccess = function()
            zg.playerData.rewardList = RewardInBound.GetItemIconDataList(self.eventModel.eventChallengeRewardResultInBound.listReward)
            zg.playerData:AddListRewardToInventory()
            if callback ~= nil then
                callback()
            end
            zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
        end
        self.eventModel:RequestChallengeBoss(uiFormationTeamData, callbackSuccess)
    end
    PopupMgr.HidePopup(self.view.model.uiName)
    PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end

function UIEventNewHeroBossChallengeLayout:OnClickLeaderBoard()
    PopupUtils.ShowLeaderBoard(LeaderBoardType.NEW_HERO_BOSS_RANKING)
end

function UIEventNewHeroBossChallengeLayout:OnHide()
    UIEventNewHeroLayout.OnHide(self)
    self.listSkillView:ReturnPool()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end

    self:ReturnPoolMilestones()
end

function UIEventNewHeroBossChallengeLayout:ShowBossRewardMilestones()
    self.layoutConfig.textDamageValue.text = tonumber(self.eventModel.highestDamage)

    self:ReturnPoolMilestones()
    --- @type List
    local listBossChallengeReward = self.eventConfig:GetBossChallengeRewardList()
    local achievedMilestone = 0
    for i = 1, listBossChallengeReward:Count() do
        local milestone = self:GetMilestoneReward(i)
        --- @type BossChallengeRewardMilestoneData
        local bossChallengeRewardMilestoneData = listBossChallengeReward:Get(i)
        milestone:SetData(self:GetChestIconByMilestone(i), bossChallengeRewardMilestoneData.damage)
        if self.eventModel.highestDamage >= bossChallengeRewardMilestoneData.damage then
            achievedMilestone = achievedMilestone + 1
        end
        milestone:EnableHighlight(self.eventModel.highestDamage >= bossChallengeRewardMilestoneData.damage)
        milestone:AddSelectListener(function()
            self:OpenChestByMilestone(i)
        end)
    end
    if achievedMilestone == listBossChallengeReward:Count() then
        self.layoutConfig.progressBar.fillAmount = 1
    elseif achievedMilestone == 0 then
        self.layoutConfig.progressBar.fillAmount = 0
    else
        UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutConfig.milestoneBar)
        --- @type UnityEngine_RectTransform
        local a = self.layoutConfig.milestoneBar:GetChild(achievedMilestone - 1):GetComponent(ComponentName.UnityEngine_RectTransform)
        self.layoutConfig.progressBar.fillAmount = a.anchoredPosition3D.x / self.layoutConfig.milestoneBar.sizeDelta.x
    end
end

function UIEventNewHeroBossChallengeLayout:ReturnPoolMilestones()
    if self.rewardMilestoneDict ~= nil then
        --- @param v GuildDailyBossMilestoneReward
        for _, v in pairs(self.rewardMilestoneDict:GetItems()) do
            v:ReturnPool()
        end
    end
    self.rewardMilestoneDict:Clear()
end

--- @return GuildDailyBossMilestoneReward
--- @param stage number
function UIEventNewHeroBossChallengeLayout:GetMilestoneReward(stage)
    if self.rewardMilestoneDict == nil then
        self.rewardMilestoneDict = Dictionary()
    end
    local milestone = self.rewardMilestoneDict:Get(stage)
    if milestone == nil then
        milestone = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.GuildDailyBossMilestoneReward, self.layoutConfig.milestoneBar)
        self.rewardMilestoneDict:Add(milestone, milestone)
    end
    return milestone
end

--- @param milestone number
function UIEventNewHeroBossChallengeLayout:OpenChestByMilestone(milestone)
    --- @type BossChallengeRewardMilestoneData
    local bossChallengeRewardMilestoneData = self.eventConfig:GetBossChallengeRewardList():Get(milestone)

    --- @type {listItemData, iconChest, chestName, chestInfo}
    local data = {}
    local chestIcon = self:GetChestIconByMilestone(milestone)
    data.listItemData = bossChallengeRewardMilestoneData:GetAllIconDataList()
    data.iconChest = ResourceLoadUtils.LoadChestIcon(chestIcon)
    data.chestName = LanguageUtils.LocalizeChestRewardDailyBoss(string.format("chest_%d_name", chestIcon))
    data.chestInfo = string.format(LanguageUtils.LocalizeCommon("chest_boss_challenge_damage_info"), bossChallengeRewardMilestoneData.damage)

    PopupMgr.ShowPopup(UIPopupName.UIPopupPackOfItems, data)
end

function UIEventNewHeroBossChallengeLayout:ShowNumberAttack()
    local turnLeft = self.eventConfig.numberRewardPerDay - math.min(self.eventModel.numberChallenge, self.eventConfig.numberRewardPerDay)
    local color = UIUtils.green_normal
    if turnLeft == 0 then
        color = UIUtils.red_dark
    end

    self.layoutConfig.textLimitReward.text = string.format("%s\n%s",
            LanguageUtils.LocalizeCommon("claimable_reward_turn"),
            UIUtils.SetColorString(color, string.format("%s/%s",
                    turnLeft, self.eventConfig.numberRewardPerDay)))
end

function UIEventNewHeroBossChallengeLayout:GetChestIconByMilestone(milestone)
    return math.min(9, milestone + self.eventConfig.listBossDamageRewardConfig:Count() - 1)
end