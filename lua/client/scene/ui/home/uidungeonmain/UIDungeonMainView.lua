require "lua.client.scene.ui.home.uiDungeonMain.DungeonConstant"
require "lua.client.scene.ui.home.uiDungeonMain.uiPreviewHeroDungeon.UIPreviewHeroDungeon"
require "lua.client.scene.ui.common.DungeonHeroIconView"
require "lua.client.core.network.dungeon.DungeonRequest"

--- @class UIDungeonMainView : UIBaseView
UIDungeonMainView = Class(UIDungeonMainView, UIBaseView)

--- @return void
--- @param model UIDungeonMainModel
function UIDungeonMainView:Ctor(model, ctrl)
    --- @type DungeonInBound
    self.server = nil
    --- @type EventTimeData
    self.eventTime = nil
    --- @type DungeonDataService
    self.csv = nil
    --- @type number
    self.timeRefresh = nil
    --- @type function
    self.updateTime = nil
    --- @type UIDungeonMainConfig
    self.config = nil
    --- @type UIPreviewHeroDungeon
    self.uiPreviewHeroDungeon = nil
    --- @type List
    self.heroTransformList = nil
    --- @type List
    self.heroIconList = nil
    --- @type DungeonConfig
    self.dungeonConfig = nil

    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIDungeonMainModel
    self.model = model
end

--- @return void
function UIDungeonMainView:OnReadyCreate()
    ---@type UIDungeonMainConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:InitUpdateTime()
    self:InitPreviewDungeon()
    self:InitButtonListener()
    self:InitHeroTransformList()
end

--- @return void
function UIDungeonMainView:OnReadyShow()
    self:InitServer()
    self:SetButtonQuick()
    self:SetShowMerchant()
    self:SetHeroData()
    self:StartRefreshTime()
    self:CheckNotificationShop()
    self.uiPreviewHeroDungeon:OnShow()
    -- ui can be update after round
    self:SetTextWave()
    self:SetTextBattle()
    self:SetSavePoint()
    -- show attacker + defender
    self:ShowAttacker()
    self:ShowDefender()

    if PopupUtils.IsPopupShowing(UIPopupName.UILoading) then
        self:InitListener()
    else
        self:CheckReward()
    end

    self.onPickCardView = RxMgr.pickDungeonBuff:Subscribe(RxMgr.CreateFunction(self, self.OnPickedCardView))
end
------------------------------- Init when the first time create --------------------------------------

function UIDungeonMainView:InitHeroTransformList()
    self.heroTransformList = List()
    for i = 1, self.config.heroList.childCount do
        local transform = self.config.heroList:GetChild(self.config.heroList.childCount - i)
        self.heroTransformList:Add(transform)
    end
end

--- @return void
function UIDungeonMainView:InitLocalization()
    self.config.textQuick.text = LanguageUtils.LocalizeCommon("quick")
    self.config.textMerchant.text = LanguageUtils.LocalizeCommon("merchant")
    self.config.textCollectionBag.text = LanguageUtils.LocalizeCommon("collection_bag")
    self.config.textPotion.text = LanguageUtils.LocalizeCommon("potion")
end

function UIDungeonMainView:InitServer()
    self.server = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
    self.eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.DUNGEON):GetTime()
    self.csv = ResourceMgr.GetServiceConfig():GetDungeon()
    if self.server == nil or self.eventTime == nil or self.config == nil then
        XDebug.Error(string.format("dungeon data can't be nil: %s, %s, %s", tostring(self.server), tostring(self.eventTime), tostring(self.csv)))
        return
    end
    self.dungeonConfig = ResourceMgr.GetDungeonConfig()
end

function UIDungeonMainView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.config.textTimeEnd.text = string.format("%s %s",
                UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("will_end_in")),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.timeRefresh))
        )
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.server:HasShop() == false then
                self:ShowTimeOut()
            end
        end
    end
end

--- @return void load and show background of dungeon
function UIDungeonMainView:InitPreviewDungeon()
    local transform = SmartPool.Instance:SpawnTransform(AssetType.UI, "preview_hero_dungeon")
    transform.position = U_Vector3(-1000, 0, 0)
    transform:SetParent(zgUnity.transform)
    self.uiPreviewHeroDungeon = UIPreviewHeroDungeon(transform, self.model, self)
end

--- @return void
function UIDungeonMainView:InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonTutorial.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
    self.config.buttonMerchant.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickShop()
    end)

    self.config.buttonCollectionBag.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIDungeonCollectionBag)
    end)

    self.config.buttonPotion.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIDungeonPotionBag)
    end)

    self.config.buttonLeaderBoard.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupUtils.ShowLeaderBoard(LeaderBoardType.DUNGEON)
    end)

    self.config.buttonTick.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PlayerSettingData.isDungeonQuick = not PlayerSettingData.isDungeonQuick
        PlayerSetting.SaveData()
        self:SetButtonQuick()
    end)

    self.config.buttonEnemyInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.server:HasShop() == false then
            PopupMgr.ShowPopup(UIPopupName.UIDungeonMonsterReview, self.server:GetDefenderTeamInfo(true))
        else
            self:ShowCurrentShop()
        end
    end)

    self.config.buttonBattle.onClick:AddListener(function()
        self:OnClickButtonBattle()
    end)
end

------------------------------- Init update buff and potion when change -------------------------------

--- @return void
function UIDungeonMainView:InitListener()
    self.listenerHideLoading = RxMgr.hideLoading:Subscribe(RxMgr.CreateFunction(self, self.CheckReward))
end

--- @return void
function UIDungeonMainView:RemoveListener()
    if self.listenerChangeResource then
        self.listenerChangeResource:Unsubscribe()
    end
    if self.listenerHideLoading then
        self.listenerHideLoading:Unsubscribe()
    end
end

--- @return void
function UIDungeonMainView:CheckReward()
    if self.server:HasReward() then
        self:ShowRewardChallenge()
        self.server:ClearRewardChallenge()
    elseif self.server:HasShop() then
        self:ShowCurrentShop()
    end
end

-------------------------------------------- UPDATE UI ---------------------------------------------
function UIDungeonMainView:OnClickButtonBattle()
    if self.server:HasShop() then
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ShowCurrentShop()
    elseif self.server:HasBuffSelectionStage() then
        self:CheckBuffSelectionStage()
    else
        self:RunBattle()
    end
end

function UIDungeonMainView:RunBattle()
    if self.server.currentStage < self.dungeonConfig.maxStage then
        if self.server:CanBattle() then
            self.server:ClearRewardChallenge()
            if PlayerSettingData.isDungeonQuick then
                self:RequestChallenge(function()
                    self:RunQuickDungeon()
                end)
            else
                self:ShowBattle()
            end
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("all_hero_died"))
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeLogicCode(LogicCode.DUNGEON_STAGE_LIMIT_REACHED))
    end
end

function UIDungeonMainView:RequestChallenge(callback)
    local onFailed = function(logicCode)
        if logicCode == LogicCode.DUNGEON_STAGE_INVALID then
            PlayerDataRequest.Request(PlayerDataMethod.DUNGEON, function()
                self:OnReadyShow()
            end)
        end
    end
    DungeonRequest.Challenge(self.server.selectedHero - 1, self.server.currentStage + 1, function()
        zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
        if self.server.isWin == true then
            TrackingUtils.SetStage(AFInAppEvents.DUNGEON, self.server.currentStage)
        end
        if callback ~= nil then
            callback(self.server.battleLog)
        end
    end, onFailed)
end

function UIDungeonMainView:RunQuickDungeon()
    local heroData = self.server:GetAttacker()
    self.server:UpdateSelectedHeroStatus(heroData.hp, heroData.power)
    -- ui can be update after round
    self:SetTextWave()
    self:SetTextBattle()
    self:SetSavePoint()
    self:CheckReward()

    self:GetSelectedHeroIcon():UpdateView()
    -- show attacker + defender
    self:ShowAttacker()
    self:ShowDefender()
end

function UIDungeonMainView:ShowBattle()
    local getDefaultSummoner = function(teamId)
        local defaultSummoner = SummonerBattleInfo()
        defaultSummoner:SetInfo(teamId, 0, 3, 1)
        defaultSummoner:SetSkills(3, 3, 3, 3)
        defaultSummoner.isDummy = true
        return defaultSummoner
    end

    local getAttackerTeamInfo = function(heroData)
        local attackerData = ResourceMgr.GetServiceConfig():GetDungeon().attackerConfig
        local team = BattleTeamInfo()
        team:SetFormationId(attackerData.formationId)
        local heroInfo = HeroBattleInfo()
        --- @type HeroResource
        local heroResource = heroData.heroResource
        heroInfo:SetInfo(1, heroResource.heroId, heroResource.heroStar, heroResource.heroLevel)
        heroInfo:SetItemsDict(heroResource.heroItem, heroResource.isHideSkin)
        heroInfo:SetPosition(attackerData.isFront, attackerData.position)
        heroInfo:SetState(heroData.hpPercent, heroData.power)
        team:AddHero(heroInfo)

        for key, data in pairs(self.server.masteryLevel:GetItems()) do
            team:AddMasteriesClass(key, data:Get(1), data:Get(2), data:Get(3), data:Get(4), data:Get(5), data:Get(6))
        end

        --- @param v RewardInBound
        for _, v in pairs(self.server.passiveBuff:GetItems()) do
            team:AddDungeonBuff(v.id, v.number)
        end
        for i, v in pairs(self.server.activeLinking:GetItems()) do
            team:AddLinkingGroup(i, v)
        end

        return team
    end

    local attackerTeam = getAttackerTeamInfo(self.server:GetSelectedHero())
    attackerTeam:SetSummonerBattleInfo(getDefaultSummoner(1))
    local defenderTeam = self.server:GetDefenderTeamInfo()
    defenderTeam:SetSummonerBattleInfo(getDefaultSummoner(2))

    self:RequestChallenge(function(battleLog)
        self.server.seedInBound:Initialize()
        zg.playerData.rewardList = List()
        zg.battleMgr:RunCalculatedBattleScene(attackerTeam, defenderTeam, GameMode.DUNGEON, nil, nil, battleLog)

        local heroData = self.server:GetAttacker()
        self.server:UpdateSelectedHeroStatus(heroData.hp, heroData.power)
    end)
end

--- @return void
function UIDungeonMainView:SetTextBattle()
    local text
    if self.server:HasShop() then
        text = LanguageUtils.LocalizeCommon("shop")
    elseif self.server:HasBuffSelectionStage() then
        text = LanguageUtils.LocalizeCommon("select_buff")
    elseif self.server:HasBoss() then
        text = LanguageUtils.LocalizeCommon("boss")
    else
        text = LanguageUtils.LocalizeCommon("battle")
    end
    self.config.textBattle.text = text
end

--- @return void
function UIDungeonMainView:SetTextWave()
    self.config.textWave.text = string.format("%s %d", LanguageUtils.LocalizeCommon("wave"), self.server.currentStage + 1)
end

function UIDungeonMainView:SetTimeRefresh()
    self.timeRefresh = self.eventTime.endTime - zg.timeMgr:GetServerTime()
end

--- @return void
function UIDungeonMainView:StartRefreshTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
    UIUtils.AlignText(self.config.textTimeEnd)
end

function UIDungeonMainView:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function UIDungeonMainView:ShowTimeOut()
    PopupUtils.ShowTimeOut(function()
        PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("dungeon_time_up"), function()
            self.server.bindingHeroList:Clear()
            PopupUtils.BackToMainArea()
        end)
    end)
end

function UIDungeonMainView:SetShowMerchant()
    self.config.buttonMerchant.gameObject:SetActive(self.server:CanShowMerchant())
end

function UIDungeonMainView:SetSavePoint()
    local currentStage = self.server.currentStage + 1
    local textFormat = function(stage)
        if stage == 1 then
            return string.format("%s %d\n", LanguageUtils.LocalizeCommon("wave"), 1)
        else
            return string.format("%s %d\n<color=#907B63> <size=11>%s</size></color>",
                    LanguageUtils.LocalizeCommon("wave"),
                    stage,
                    LanguageUtils.LocalizeCommon("save_point"))
        end
    end
    local stageFirst, stageSecond, stageThird = self.csv:GetSavePoint(currentStage)
    self.config.textWave1.text = textFormat(stageFirst)
    if stageThird ~= nil then
        self.config.textWave2.transform.parent.gameObject:SetActive(true)
        self.config.textWave2.text = textFormat(stageSecond)
    else
        self.config.textWave2.transform.parent.gameObject:SetActive(false)
        stageThird = stageSecond
    end
    self.config.textWave3.text = textFormat(stageThird)

    local delta = (currentStage - stageFirst) / (stageThird - stageFirst)
    local pos = 580 * delta
    self.config.dot.localPosition = U_Vector3(pos - 290, self.config.dot.localPosition.y, self.config.dot.localPosition.z)
    self.config.bgDungeonTimelineBar:SetSizeWithCurrentAnchors(U_Rect_Axis.Horizontal, pos + 45)
end

--- @return void
function UIDungeonMainView:SetButtonQuick()
    self.config.iconTick.enabled = PlayerSettingData.isDungeonQuick
end

-------------------------------------------- END UPDATE UI ---------------------------------------------

--- @return boolean -- show success or failed
function UIDungeonMainView:ShowRewardChallenge()
    if self.server.rewardChallengeList:Count() > 0 then
        PopupUtils.ShowRewardList(RewardInBound.GetItemIconDataList(self.server.rewardChallengeList), function()
            if self.timeRefresh > 0 and PopupUtils.IsPopupShowing(UIPopupName.UIDungeonMain) then
                self:CheckBuffSelectionStage()
            end
        end)
    elseif self.server.buffRewardList:Count() > 0 then
        self:ShowDungeonBuff(self.server.currentStage, self.server.buffRewardList, false)
        self.server.buffRewardList:Clear()
    else
        self:CheckBuffSelectionStage()
    end
end

--- @return boolean show success or failed
function UIDungeonMainView:ShowCurrentShop()
    local skipCallback = function()
        self.server.currentShop = nil
        self:SetTextBattle()
        if self.timeRefresh > 0 then
            self.uiPreviewHeroDungeon:HideSeller()
            self:ShowDefender()
        else
            self:ShowTimeOut()
        end
    end
    self:ShowPreviewShop()
    PopupMgr.ShowPopup(UIPopupName.UIDungeonShop, { ['marketItem'] = self.server.currentShop, ['skipCallback'] = skipCallback })
end

--- @return void
function UIDungeonMainView:ShowPreviewShop()
    self.uiPreviewHeroDungeon:PreviewSeller(self.server.currentShopType)
end

--- @return void
function UIDungeonMainView:SetHeroData()
    local heroList = self.server.bindingHeroList

    self.heroIconList = List()
    for i, transform in ipairs(self.heroTransformList:GetItems()) do
        if i <= heroList:Count() then
            --- @type DungeonHeroIconView
            local heroIcon = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.DungeonHeroIconView, transform)
            --- @type DungeonBindingHeroInBound
            local data = heroList:Get(i)

            heroIcon:SetIconData(data)
            heroIcon:AddListener(function()
                self:UnSelectHero(self.server.selectedHero)
                self:SelectHero(data.index)
            end)
            self.heroIconList:Add(heroIcon)
            self:UnSelectHero(i)
        end
    end
end

--- @return void
function UIDungeonMainView:ShowAttacker()
    self.server:SelectAttacker()
    if self.server:GetSelectedHero():IsAlive() then
        self:SelectHero(self.server.selectedHero)
        self:ShowPreviewAttacker()
    else
        self:HidePreviewAttacker()
    end
end

--- @return void
--- @param index number
function UIDungeonMainView:SelectHero(index)
    self.server.selectedHero = index
    local heroIcon = self:GetHeroIcon(index)
    heroIcon:SetSelected(true)
    heroIcon:SetAsLastSibling()
    self:SetArrow(heroIcon:GetYPos())
    self:ShowPreviewAttacker()
end

function UIDungeonMainView:UnSelectHero(index)
    local heroIcon = self:GetHeroIcon(index)
    heroIcon:SetSelected(false)
    heroIcon:SetSibling()
end

---@return void
function UIDungeonMainView:SetArrow(posY)
    local persistPos = self.config.arrow.localPosition
    self.config.arrow.localPosition = U_Vector3(persistPos.x, posY)
end

--- @return DungeonHeroIconView
function UIDungeonMainView:GetHeroIcon(index)
    local heroIcon = self.heroIconList:Get(index)
    if heroIcon == nil then
        XDebug.Log(string.format("hero_icon is invalid: %s", tostring(index)))
    end
    return heroIcon
end

--- @return DungeonHeroIconView
function UIDungeonMainView:GetSelectedHeroIcon()
    return self:GetHeroIcon(self.server.selectedHero)
end

--- @return void
function UIDungeonMainView:ShowPreviewAttacker()
    local hero = self.server:GetSelectedHero()
    if hero:IsAlive() then
        self.uiPreviewHeroDungeon:PreviewAttacker(hero)
    else
        self:HidePreviewAttacker()
    end
end

--- @return void
function UIDungeonMainView:PlayReviveAttacker()
    local hero = self.server:GetSelectedHero()
    self.uiPreviewHeroDungeon:PreviewAttacker(hero)
    --- @type ClientHero
    local clientHero = self.uiPreviewHeroDungeon.uiPreviewAttacker:GetClientHero()
    clientHero.animation:ClearTracks()
    clientHero.animation:PlayAnimationWithCallback(AnimationConstants.REBORN, function()
        self:ShowPreviewAttacker()
    end)
end

--- @return void
function UIDungeonMainView:HidePreviewAttacker()
    self.uiPreviewHeroDungeon:SetActiveStatusBar(false)
    self.uiPreviewHeroDungeon.uiPreviewAttacker:OnHide()
end

function UIDungeonMainView:ShowDefender()
    if self.server:HasShop() == false then
        self:ShowPreviewDefender()
    end
end

--- @return void
function UIDungeonMainView:ShowPreviewDefender()
    local hero = self.server:GetDefenderTeamInfo(true):GetListHero():Get(1)
    if hero ~= nil then
        self.uiPreviewHeroDungeon:PreviewDefender(HeroResource.CreateInstance(-1, hero.heroId, hero.star, hero.level))
    else
        self.uiPreviewHeroDungeon.uiPreviewDefender:OnHide()
    end

end

function UIDungeonMainView:OnClickBackOrClose()
    Coroutine.start(function()
        if PopupUtils.IsPopupShowing(UIPopupName.UIDungeonPotionBag) then
            --- @type TouchObject
            local touchObject = TouchUtils.Spawn("UIDungeonMainView:OnClickBackOrClose")
            PopupMgr.HidePopup(UIPopupName.UIDungeonPotionBag)
            coroutine.waitforseconds(0.3)
            touchObject:Enable()
        end
        PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    end)
end

function UIDungeonMainView:Hide()
    UIBaseView.Hide(self)
    self:RemoveUpdateTime()

    self:RemoveHeroIconView()

    self:RemoveListener()

    if self.uiPreviewHeroDungeon ~= nil then
        self.uiPreviewHeroDungeon:OnHide()
    end
    if self.onPickCardView then
        self.onPickCardView:Unsubscribe()
    end
    --- DON'T CLEAR, IT USED TO SHOW REWARD WHEN COMEBACK
    --self.server:ClearRewardChallenge()
end

function UIDungeonMainView:RemoveHeroIconView()
    --- @param heroIcon DungeonHeroIconView
    for _, heroIcon in ipairs(self.heroIconList:GetItems()) do
        heroIcon:ReturnPool()
    end
    self.heroIconList:Clear()
end

--- @return void
function UIDungeonMainView:OnClickHelpInfo()
    local info = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("dungeon_info"), 50, 50)
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

function UIDungeonMainView:OnClickShop()
    PopupMgr.ShowPopup(UIPopupName.UIDungeonSeller)
    ---@type EventTimeData
    local eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.DUNGEON):GetTime()

    if self.server.dungeonCheckInShop ~= eventTime.season then
        DungeonInBound.SetDungeonCheckInShop(eventTime.season, function()
            self.server.dungeonCheckInShop = eventTime.season
            self.config.notifyShop:SetActive(false)
        end)
    end
end

function UIDungeonMainView:CheckNotificationShop()
    self.config.notifyShop:SetActive(false)
    ---@type EventTimeData
    local eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.DUNGEON):GetTime()
    if (self.server.shopDict ~= nil and self.server.shopDict:Count() > 0) then
        if self.server.dungeonCheckInShop == nil then
            local onGetCheckInShop = function(value)
                self.server.dungeonCheckInShop = value
                self.config.notifyShop:SetActive(self.server.dungeonCheckInShop ~= eventTime.season)
            end
            DungeonInBound.GetDungeonCheckInShop(onGetCheckInShop)
        else
            self.config.notifyShop:SetActive(self.server.dungeonCheckInShop ~= eventTime.season)
        end
    end
end

--- @param data {buffData, sourceRect : UnityEngine_RectTransform, useOnHero : boolean, isActiveBuff : boolean, onComplete}
function UIDungeonMainView:OnPickedCardView(data)

    --- @type ActiveBuffDataEntry | PassiveBuffDataEntry
    local buffData = data.buffData
    local sourceRect = data.sourceRect
    local useOnHero = data.useOnHero
    local onComplete = data.onComplete
    local sourcePos = self.uiPreviewHeroDungeon:ScreenToWorldPoint(sourceRect.transform.position)
    local destPos

    if useOnHero then
        destPos = self.uiPreviewHeroDungeon:GetAttackerPosition()
        if data.isActiveBuff == true then
            self.server:UseActiveBuff(buffData.id)
        end
    else
        if data.isActiveBuff == true then
            destPos = self.uiPreviewHeroDungeon:ScreenToWorldPoint(self.config.buttonPotion.transform.position)
        else
            destPos = self.uiPreviewHeroDungeon:ScreenToWorldPoint(self.config.buttonCollectionBag.transform.position)
        end
    end

    self:CheckBuffSelectionStage()
    self.uiPreviewHeroDungeon:PlayFlyingPotionEffect(buffData, sourcePos, destPos, useOnHero, function()
        if onComplete then
            onComplete()
        end
        if useOnHero then
            local impactPos = self.uiPreviewHeroDungeon:GetAttackerAnchor().position
            --- @type DungeonBuffType
            local buffType = buffData.type
            if buffType == DungeonBuffType.ACTIVE_BUFF_NORMAL then
                self:PlayImpactPotionEffect(buffData, useOnHero, impactPos)
                self:ShowPreviewAttacker()
            elseif buffType == DungeonBuffType.ACTIVE_BUFF_REVIVE then
                local hero = self.server:GetSelectedHero()
                local heroId = hero.heroResource.heroId
                local faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
                local effectName = "reborn_or_revive_" .. faction
                local reviveEffect = self:GetClientEffect(AssetType.GeneralBattleEffect, effectName)
                if reviveEffect ~= nil then
                    reviveEffect:SetPosition(impactPos)
                end
                self:PlayReviveAttacker()
            end
        else
            self:PlayImpactPotionEffect(buffData, useOnHero, destPos)
        end
        self:SetTextBattle()
        local iconView = self:GetSelectedHeroIcon()
        if iconView then
            iconView:UpdateView()
        end
    end)
end

--- @return void
function UIDungeonMainView:CheckBuffSelectionStage()
    if self.server:HasBuffSelectionStage() then
        local stage = self.server:GetFirstBuffSelectionStage()
        DungeonRequest.GenerateBuff(stage, function(buffList)
            if buffList:Count() > 0 then
                self:ShowDungeonBuff(stage, buffList, true)
            else
                XDebug.Error("NIL BUFF in stage " .. stage)
            end
        end)
    end
end

--- @param stage number
--- @param buffList List
--- @param isSmash boolean
function UIDungeonMainView:ShowDungeonBuff(stage, buffList, isSmash)
    local data = {}
    data.stage = stage
    data.buffList = buffList
    data.isSmash = isSmash
    data.callbackClose = function()
        self:SetTextBattle()
        PopupMgr.HidePopup(UIPopupName.UIDungeonBuff)
    end
    PopupMgr.ShowPopup(UIPopupName.UIDungeonBuff, data)
end

--- @param buffData ActiveBuffDataEntry | PassiveBuffDataEntry
function UIDungeonMainView:PlayImpactPotionEffect(buffData, useOnHero, desPosition)
    local impactEffect = self:GetImpactPotionEffect(buffData, useOnHero)
    if impactEffect ~= nil then
        impactEffect:SetPosition(desPosition)
        return impactEffect
    end
end

--- @return ClientEffect
--- @param buffData ActiveBuffDataEntry
function UIDungeonMainView:GetImpactPotionEffect(buffData, useOnHero)
    local effectName
    if useOnHero then
        --- @type DungeonBuffType
        local type = buffData.type
        if type == DungeonBuffType.ACTIVE_BUFF_NORMAL then
            effectName = string.format("fx_dungeon_impact_%d", type)
            if buffData.hpPercent > 0 then
                effectName = string.format("%s_heal", effectName)
            else
                effectName = string.format("%s_power", effectName)
            end
        end
    else
        local rarity = buffData.rarity
        effectName = string.format("fx_ui_dungeon_item_%d", rarity)
    end
    return self:GetClientEffect(AssetType.UIEffect, effectName)
end

--- @param assetType AssetType
function UIDungeonMainView:GetClientEffect(assetType, effectName)
    local clientEffect = SmartPool.Instance:SpawnClientEffectByPoolType(assetType, GeneralEffectPoolType.ClientEffect, effectName)
    if clientEffect ~= nil then
        if clientEffect.isInited == false then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            clientEffect:InitRef(assetType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            clientEffect.isInited = true
        end
        clientEffect:Play()
    end
    clientEffect:SetParent(self.uiPreviewHeroDungeon.config.worldCanvas)
    return clientEffect
end