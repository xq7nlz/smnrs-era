require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldFormation"
require "lua.client.scene.ui.home.uiFormation.UIFormationTeamData"
require "lua.client.core.network.playerData.defenseMode.SaveFormationDefenseOutBound"

--- @class UIFormationDefenseView : UIBaseView
UIFormationDefenseView = Class(UIFormationDefenseView, UIBaseView)

--- @return void
--- @param model UIFormationDefenseModel
function UIFormationDefenseView:Ctor(model)
    --- @type UIFormationDefenseConfig
    self.config = nil
    --- @type UISelect
    self.tab = nil
    ---@type HeroListView
    self.heroList = nil
    --- @type WorldFormation
    self.worldFormation = nil
    ---@type number
    self.powerAttacker = nil

    self.cacheResult = nil

    ---@type List
    self.listLinking1 = List()
    ---@type List
    self.listLinking2 = List()

    ---@type PlayerSummonerInBound
    self.summonerInbound = nil
    self.coroutine = nil
    --- @type boolean
    self.isShowing = false

    --- @type UISelect
    self.tabWave = nil

    self.cacheWorldFormation = false
    --- @type GameMode
    self.currentMode = nil
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIFormationDefenseModel
    self.model = model
end

--- @return void
function UIFormationDefenseView:OnReadyCreate()
    ---@type UIFormationDefenseConfig
    self.config = UIBaseConfig(self.uiTransform)

    --- @param obj TabFormationConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        if isSelect then
            UIUtils.SetInteractableButton(obj.button, false)
            obj.rectTranform.sizeDelta = U_Vector2(0, 46)
        else
            UIUtils.SetInteractableButton(obj.button, true)
            obj.rectTranform.sizeDelta = U_Vector2(0, 0)
        end
    end

    local onChangeSelectTeam = function(indexTab, lastTab)
        self.config.teamLayout.enabled = false
        self.config.teamLayout.enabled = true
    end
    local onClickSelectTeam = function(indexTab, lastTab)
        self:ChangeTeam()
    end
    local conditionSelect = function(indexTab)
        return ResourceMgr.GetFormationLockConfig().dict:IsContainKey(indexTab) == false or
                ResourceMgr.GetFormationLockConfig().dict:Get(indexTab) <= zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
    end
    local onSelectFailed = function(indexTab)
        local level = ResourceMgr.GetFormationLockConfig().dict:Get(indexTab)
        SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("require_level_x"), level))
    end
    self.tab = UISelect(self.config.team, UIBaseConfig, onSelect, onChangeSelectTeam, onClickSelectTeam, conditionSelect, onSelectFailed)

    --- @param obj ItemWaveDefenseConfig
    --- @param isSelect boolean
    local onSelectWave = function(obj, isSelect, indexTab)
        if isSelect then
            obj.textWave.text = string.format("%s %d", LanguageUtils.LocalizeCommon("wave"), indexTab)
            obj.iconWaveCurrent:SetActive(true)
        else
            obj.textWaveValue.text = tostring(indexTab)
            obj.iconWaveCurrent:SetActive(false)
        end
    end

    local onChangeSelectWave = function(indexTab, lastTab)
        self:SetDefenseWave(indexTab)
        self.config.buttonArrowL.gameObject:SetActive(indexTab > 1)
        self.config.buttonArrowR.gameObject:SetActive(indexTab < self.maxWave)
    end
    self.tabWave = UISelect(self.config.layoutWave, UIBaseConfig, onSelectWave, onChangeSelectWave, nil, nil, nil)

    --HERO LIST
    self.heroList = HeroListView(self.config.heroList)

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    self.onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
        if self.model.teamFormation:IsContainHeroInventoryId(heroResource.inventoryId) then
            buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
            buttonHero:EnableButton(true)
        else
            buttonHero:ActiveMaskSelect(false)
            buttonHero:EnableButton(true)
        end
    end

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    self.buttonListener = function(heroIndex, buttonHero, heroResource)
        if self.model.teamFormation:IsContainHeroInventoryId(heroResource.inventoryId) then
            self:RemoveHeroFromTeam(heroResource.inventoryId)
            buttonHero:ActiveMaskSelect(false)
            buttonHero:EnableButton(true)
            self:UpdateTeamFormation()
        else
            if self.model.teamFormation:IsFull() == false then
                --local tower = self.landCollectionData:CheckHeroInOtherFormation(heroResource.inventoryId, self.tower, self.land, self.stage)
                --if tower == nil then        ---- check hero other formation
                if self:AddHeroToTeam(heroResource) == true then
                    buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
                    buttonHero:EnableButton(true)
                    self:UpdateTeamFormation()
                end
                --else
                --	SmartPoolUtils.ShowShortNotification("Hero in formation " .. tower)
                --end
            else
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("noti_full_hero"))
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            end
        end
    end

    --- @param heroIndex number
    --- @param heroResource HeroResource
    local filterConditionAnd = function(heroIndex, heroResource)
        if self.landUnlock.restrictType < 7 then
            return ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId) == self.landUnlock.restrictType
        else
            return true
        end
    end

    self.heroList:Init(self.buttonListener, nil, filterConditionAnd, nil, nil, self.onUpdateIconHero, self.onUpdateIconHero)
    self.heroList.factionSort.conditionClick = function(index)
        if self.landUnlock.restrictType < 7 and index > 1 and index - 1 ~= self.landUnlock.restrictType then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeLandRule(self.landUnlock.restrictType))
            return false
        else
            return true
        end
    end
    self:InitButtonListener()
    self:InitToggle()
end

--- @return void
function UIFormationDefenseView:InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAuraSkill.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCompanion1()
    end)
    self.config.buttonAuraSkill2.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCompanion2()
    end)
    self.config.battleButtonNotSkip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        --self:OnClickSave()
        self:OnClickBattle()
    end)
    self.config.battleButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        --self:OnClickSave()
        self:OnClickBattle()
    end)
    self.config.skipButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSkip()
    end)
    self.config.buttonRemoveAll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRemoveAll()
    end)
    self.config.buttonArrowL.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackWave()
    end)
    self.config.buttonArrowR.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickNextWave()
    end)
    self.config.buttonAttackerInfor.gameObject:SetActive(true)
    self.config.buttonAttackerInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickShowAttackerInfor()
    end)

    for index = 1, self.config.linkingAttacker.childCount do
        ---@type UnityEngine_UI_Button
        local button = self.config.linkingAttacker:GetChild(index - 1):GetComponent(ComponentName.UnityEngine_UI_Button)
        button.onClick:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            self:OnClickLinkingAttacker(index)
        end)
    end
    for index = 1, self.config.linkingDefender.childCount do
        ---@type UnityEngine_UI_Button
        local button = self.config.linkingDefender:GetChild(index - 1):GetComponent(ComponentName.UnityEngine_UI_Button)
        button.onClick:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            self:OnClickLinkingDefender(index)
        end)
    end
end

function UIFormationDefenseView:OnClickBackOrClose()
    UIBaseView.OnClickBackOrClose(self)
end

function UIFormationDefenseView:OnClickBackWave()
    self.tabWave:Select(self.tabWave.indexTab - 1)
end

function UIFormationDefenseView:OnClickNextWave()
    self.tabWave:Select(self.tabWave.indexTab + 1)
end

--- @return void
function UIFormationDefenseView:InitLocalization()
    self.config.localizeVs.text = LanguageUtils.LocalizeCommon("vs")
    self.config.localizeSkip.text = LanguageUtils.LocalizeCommon("skip")
    local localizeBattle = LanguageUtils.LocalizeCommon("battle")
    self.config.localizeBattle.text = localizeBattle
    self.config.localizeBattle2.text = localizeBattle
    self.config.localizeRemoveAll.text = LanguageUtils.LocalizeCommon("remove_all")
    self.config.localizeFormation1.text = LanguageUtils.LocalizeCommon("formation")
    self.config.localizeFormation2.text = LanguageUtils.LocalizeCommon("formation")
    self.config.localizeFormation3.text = LanguageUtils.LocalizeCommon("formation")
    self.config.localizeFormation4.text = LanguageUtils.LocalizeCommon("formation")
end

--- @param result {gameMode:GameMode, stage, callbackPlayBattle:function, land, callbackClose}
function UIFormationDefenseView:OnReadyShow(result)
    self.data = result
    self.currentMode = result.gameMode
    if self.currentMode == GameMode.DEFENSE_MODE then
        ---@type DefenseModeInbound
        self.defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
    end
    self.config.textDamage.transform.parent.gameObject:SetActive(false)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    if self.isShowing then
        self:OnClickSkip()
        return
    end
    self.isShowing = true

    self.canPlayMotion = true
    self.summonerInbound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    self.cacheResult = result
    self:_Init(result)
    self:InitWorldFormation()
    if result.worldFormation == nil then
        self.worldFormation:OnShow()
        self:OnShowWorldFormation()
    end
    self.worldFormation:EnableModification(true)
    self:ShowBgAnchor(result.bgParams)
    self.tabWave:Select(1)
    self:CheckEnableAutoNext()
end

--- @return void
function UIFormationDefenseView:CheckEnableAutoNext()
    local isEnable = self.currentMode == GameMode.DEFENSE_MODE
    if self.toggleView then
        self.config.toggleAutoBattle:SetActive(isEnable)
        self.toggleView:OnShow(PlayerSettingData.isAutoNextBattle)
    end
end

function UIFormationDefenseView:InitToggle()
    if self.config.toggle then
        self.toggleView = ToggleView(self.config.toggle, function()
            self:OnClickToggleAutoBattle()
        end, function()
            return LanguageUtils.LocalizeCommon("auto_battle")
        end)
    end
end

function UIFormationDefenseView:OnClickToggleAutoBattle()
    if PlayerSettingData.isAutoNextBattle then
        self:SwitchAutoNextBattleMode()
        return
    end

    local canAutoBattle = ClientConfigUtils.CheckAutoNextBattleAndNotification()
    if (canAutoBattle) then
        if PlayerSettingData.isAutoNextBattle == false then
            --local text_noti = LanguageUtils.LocalizeCommon("popup_confirm_auto_next_battle")
            --local callbackYes = function()
            --    self:SwitchAutoNextBattleMode()
            --end
            --PopupUtils.ShowPopupNotificationTwoButtons(text_noti, nil, callbackYes, nil, "no", "confirm", true)
            self:SwitchAutoNextBattleMode()
        end
    end
end

function UIFormationDefenseView:SwitchAutoNextBattleMode()
    PlayerSetting.SetToggleAutoNextBattle()
    self.toggleView:SetState(PlayerSettingData.isAutoNextBattle)
end

--- @start world
function UIFormationDefenseView:CheckCanSkip(canSkip)
    local enableSkip = ClientConfigUtils.CheckCanSkip(self.currentMode) or canSkip
    self.config.canSkip:SetActive(enableSkip)
    self.config.battleButtonNotSkip.gameObject:SetActive(not enableSkip)
end

--- @start world
function UIFormationDefenseView:InitWorldFormation()
    if self.worldFormation == nil then
        local transform = SmartPool.Instance:SpawnTransform(AssetType.UI, "world_formation")
        self.worldFormation = WorldFormation(transform)
    end
    self.worldFormation.swapCallback = function(hero1, hero2)
        self:CallbackSwapHero(hero1, hero2)
    end
    self.worldFormation.removeCallback = function(hero)
        self:CallbackRemove(hero)
    end
    self.worldFormation.selectSummonerCallback = function()
        self:CallbackSelectSummoner()
    end
end

function UIFormationDefenseView:OnShowWorldFormation()
    self.worldFormation:SetAttackerFormation(self.model.teamFormation.formationId)
    self.worldFormation:SetDefenderPredefineTeamData(self.model.defenderTeamInfo)
    self.coroutine = Coroutine.start(function()
        coroutine.waitforseconds(0.15)
        ---@type DetailTeamFormation
        local detailTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(self.model.teamFormation)
        self.worldFormation:ShowAttackerPredefineTeam(detailTeamFormation)
        if self.landUnlock.restrictType == DefenseRestrictType.DREAM then
            self.worldFormation.attackerWorldFormation:EnableSummonerSlot(false)
        else
            self.worldFormation.attackerWorldFormation:EnableSummonerSlot(true)
            self.worldFormation:ShowAttackerSummoner(self.model.teamFormation.summonerId, self.summonerInbound.star)
        end
    end)
end

--- @param isEnable boolean
function UIFormationDefenseView:EnableDefenderTeam(isEnable)
    self.worldFormation:EnableDefenderTeamView(isEnable)
end
--- @end world

--- @param isEnable boolean
function UIFormationDefenseView:ShowListHero(isEnable)
    --if isEnable == true then
    --	self.config.buttonArrow.transform.localScale = U_Vector3(math.abs(self.config.buttonArrow.transform.localScale.x), self.config.buttonArrow.transform.localScale.y, 1)
    --	self.config.groupSelectHero:SetActive(true)
    --	self.config.battleButton2.gameObject:SetActive(false)
    --	--self.heroList.uiScroll:RefreshCells()
    --	self.config.defenderInfo:SetActive(false)
    --else
    --	self.config.buttonArrow.transform.localScale = U_Vector3(-math.abs(self.config.buttonArrow.transform.localScale.x), self.config.buttonArrow.transform.localScale.y, 1)
    --	self.config.groupSelectHero:SetActive(false)
    --	self.config.battleButton2.gameObject:SetActive(true)
    --	self.config.defenderInfo:SetActive(true)
    --	local companionBuff = ClientConfigUtils.GetCompanionIdByBattleTeamInfo(self.model.defenderTeamInfo)
    --	self.config.companion2.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(companionBuff)
    --end
end

--- @return void
--- @param result {gameMode:GameMode, formationTeamData:UIFormationTeamData, rewardList:List<ItemIconData>, tittle}
function UIFormationDefenseView:_Init(result)
    self.cacheWorldFormation = false
    if result ~= nil then
        if result.cache == nil then
            self.land = result.land
            --self.tower = result.tower
            self.stage = result.stage
            ---@type LandCollectionData
            self.landCollectionData = self.defenseModeInbound:GetLandCollectionData(self.land)
            ---@type LandConfig
            self.landConfig = ResourceMgr.GetDefenseModeConfig():GetLandConfig(self.land)
            ---@type LandUnlockConfig
            self.landUnlock = ResourceMgr.GetDefenseModeConfig():GetLandUnlockConfig(self.land)

            self.model.teamFormation = nil
            if self.landCollectionData ~= nil then
                if self.landCollectionData.teamFormation ~= nil
                        and self.landCollectionData.teamFormation:IsContainHeroInFormation() then
                    self.model.teamFormation = TeamFormationInBound.Clone(self.landCollectionData.teamFormation)
                end
            end
            self.maxWave = self.landConfig:GetMaxWaveStageConfig(self.stage)
            for i = 1, self.config.layoutWave.childCount do
                self.config.layoutWave:GetChild(i - 1).gameObject:SetActive(i <= self.maxWave)
            end
        end
        ---@type List
        self.listAttackerTeamStageConfig = self.landConfig:GetListAttackerTeamStageConfig(self.stage)

        self.model.defenderTeamInfo = result.battleTeamInfo
        self.callbackPlayBattle = result.callbackPlayBattle
    end
    self.worldFormation = result.worldFormation
    if result.returnWorldFormation ~= nil then
        self.cacheWorldFormation = true
        result.returnWorldFormation = function()
            return self.worldFormation
        end
    end

    if result.tittle ~= nil then
        self.config.localizeBattle.text = result.tittle
    else
        self.config.localizeBattle.text = LanguageUtils.LocalizeCommon("battle")
    end

    if self.model.teamFormation == nil then
        self.model.teamFormation = TeamFormationInBound()
        self.model.teamFormation:SetDefaultTeam()
    else
        self.model.teamFormation:CheckHeroId()
    end
    self:UpdateTeamFormation()
    self:CheckCanSkip(result.canSkip)
    if result.cache == nil then
        self.powerDefenderTeam = result.powerDefenderTeam
    end

    self.heroList:SetData(InventoryUtils.Get(ResourceType.Hero), self.canPlayMotion)
    if self.canPlayMotion == true then
        self.canPlayMotion = false
    end
    self.tab:Select(self.model.teamFormation.formationId)
end

function UIFormationDefenseView:SetDefenseWave(wave)
    self.model.defenderTeamInfo = nil
    if self.listAttackerTeamStageConfig ~= nil then
        ---@type AttackerTeamStageConfig
        local attackerTeamStageConfig = self.listAttackerTeamStageConfig:Get(wave)
        if attackerTeamStageConfig ~= nil then
            --self.config.textDamage.text = tostring(attackerTeamStageConfig.damage)
            self.model.defenderTeamInfo = attackerTeamStageConfig:GetBattleTeamInfo()
            self.worldFormation:SetDefenderPredefineTeamData(self.model.defenderTeamInfo)
            self.worldFormation:EnableDefenderTeamView(true)
            --self.config.textDamage.transform.parent.gameObject:SetActive(true)
            self.config.companion2.gameObject:SetActive(true)
            local companionBuff = ClientConfigUtils.GetCompanionIdByBattleTeamInfo(self.model.defenderTeamInfo)
            self.config.companion2.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(companionBuff)
            self.config.powerDefender:SetActive(true)
            self.powerDefenderTeam = ClientConfigUtils.GetPowerByBattleTeamInfo(self.model.defenderTeamInfo)
            self.config.textPowerDefender.text = tostring(math.floor(self.powerDefenderTeam))
            self:UpdateLinkingDefenderTeam()
        else
            --self.config.textDamage.transform.parent.gameObject:SetActive(true)
            self.config.companion2.gameObject:SetActive(false)
            self:EnableDefenderTeam(false)
            self.config.powerDefender:SetActive(false)
        end
    end
end

function UIFormationDefenseView:Hide()
    ClientConfigUtils.KillCoroutine(self.coroutine)
    self:HideWorldFormation()
    self.heroList:ReturnPool()
    self:RemoveListenerTutorial()
    self.cacheResult = nil
    self.isShowing = false
    UIBaseView.Hide(self)
    self.tab:Select(nil)
end

function UIFormationDefenseView:HideWorldFormation()
    if self.worldFormation ~= nil and self.cacheWorldFormation ~= true then
        self.worldFormation:OnHide()
        self.worldFormation = nil
    end
end

--- @return void
function UIFormationDefenseView:UpdatePowerAttacker()
    ---@type BattleTeamInfo
    local battleTeamInfo = ClientConfigUtils.GetBattleTeamInfoByTeamFormationInBoundDefenseMode(self.model.teamFormation, self.land)
    self.powerAttacker = math.floor(ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo))
    self.config.textPowerAttacker.text = tostring(self.powerAttacker)
end

--- @return void
function UIFormationDefenseView:ChangeTeam()
    self.model.teamFormation:ChangeFormationId(self.tab.indexTab)
    self.worldFormation:SetAttackerFormation(self.model.teamFormation.formationId)
    ---@type DetailTeamFormation
    local detailTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(self.model.teamFormation)
    self.worldFormation:ShowAttackerPredefineTeam(detailTeamFormation)
end

--- @return void
--- @param heroResource HeroResource
function UIFormationDefenseView:AddHeroToTeam(heroResource)
    local isFrontLine, position = self.model.teamFormation:AddHeroInventoryId(heroResource.inventoryId)
    if position ~= nil then
        self.worldFormation:SetHeroAtPosition(true, isFrontLine, position, heroResource)
        self.worldFormation:ResetButtonSlot()
        return true
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("noti_full_hero"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        return false
    end
end

--- @return void
--- @param inventoryId number
function UIFormationDefenseView:RemoveHeroFromTeam(inventoryId)
    local isFrontLine, position = self.model.teamFormation:RemoveHeroInventoryId(inventoryId)
    self.worldFormation:RemoveHeroAtPosition(true, isFrontLine, position)
end

--- @return void
--- @param hero1 {isFrontLine, positionId}
--- @param hero2 {isFrontLine, positionId}
function UIFormationDefenseView:CallbackSwapHero(hero1, hero2)
    self.model.teamFormation:SwapHero(hero1, hero2)
    self:UpdateTeamFormation()
end

--- @param hero {isFrontLine, positionId}
function UIFormationDefenseView:CallbackRemove(hero)
    self.model.teamFormation:RemoveHeroPosition(hero)
    self.heroList.uiScroll:RefreshCells()
    self:UpdateTeamFormation()
end

function UIFormationDefenseView:CallbackSelectSummoner()
    if self.summonerInbound.star > 3 then
        if self.model.teamFormation:IsContainHeroInFormation() then
            local dataFormation = self.cacheResult
            dataFormation.cache = true
            local data = {}
            data.summonerId = self.model.teamFormation.summonerId
            data.callbackSwitch = function(summonerId)
                dataFormation.worldFormation = nil
                self.model.teamFormation.summonerId = summonerId
                PopupMgr.ShowAndHidePopup(UIPopupName.UIFormationDefense, dataFormation, UIPopupName.UISwitchCharacter)
            end
            data.callbackClose = function()
                dataFormation.worldFormation = nil
                PopupMgr.ShowAndHidePopup(UIPopupName.UIFormationDefense, dataFormation, UIPopupName.UISwitchCharacter)
            end
            self.cacheWorldFormation = false
            PopupMgr.ShowAndHidePopup(UIPopupName.UISwitchCharacter, data, UIPopupName.UIFormationDefense)
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("insert_least_one_hero"))
        end
    end
end

--- @return void
---@param listHero List
---@param rectTransform UnityEngine_RectTransform
---@param listLinkingReturn List
function UIFormationDefenseView:SetListLinking(listHero, rectTransform, listLinkingReturn)
    listLinkingReturn:Clear()
    for i = 1, rectTransform.childCount do
        rectTransform:GetChild(i - 1).gameObject:SetActive(false)
    end
    --local index = 0
    -----@param v BaseLinking
    --for _, v in pairs(ResourceMgr.GetServiceConfig():GetHeroes().heroLinkingEntries:GetItems()) do
    --	local active = true
    --	for _, heroId in pairs(v.affectedHero:GetItems()) do
    --		if listHero:IsContainValue(heroId) == false then
    --			active = false
    --			break
    --		end
    --	end
    --	if active == true then
    --		listLinkingReturn:Add(v.id)
    --		---@type UnityEngine_UI_Image
    --		local image = rectTransform:GetChild(index):GetComponent(ComponentName.UnityEngine_UI_Image)
    --		image.gameObject:SetActive(true)
    --		image.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLinking, v.id)
    --		index = index + 1
    --	end
    --end
end

--- @return void
function UIFormationDefenseView:UpdateLinkingTeamFormation()
    -----@type List
    --local listHeroId = self.model.teamFormation:GetListHeroId()
    --self:SetListLinking(listHeroId, self.config.linkingAttacker, self.listLinking1)
end

--- @return void
function UIFormationDefenseView:UpdateLinkingDefenderTeam()
    -----@type List
    --local listHeroId = List()
    -----@param v HeroBattleInfo
    --for _, v in pairs(self.model.defenderTeamInfo.listHeroInfo:GetItems()) do
    --    if v.heroId > 0 and listHeroId:IsContainValue(v.heroId) == false then
    --        listHeroId:Add(v.heroId)
    --    end
    --end
    --self:SetListLinking(listHeroId, self.config.linkingDefender, self.listLinking2)
end

--- @return void
function UIFormationDefenseView:UpdateTeamFormation()
    self:UpdateLinkingTeamFormation()
    self:UpdatePowerAttacker()
    self:UpdateCompanionBuff()
end

--- @return void
function UIFormationDefenseView:UpdateCompanionBuff()
    local companionBuff = ClientConfigUtils.GetCompanionIdBuyTeamFormation(self.model.teamFormation)
    self.config.companion1.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(companionBuff)
end

function UIFormationDefenseView:OnClickLinkingAttacker(index)
    local linkingId = self.listLinking1:Get(index)
    self.config.linkingSelected:SetParent(self.config.linkingAttacker:GetChild(index - 1))
    self.config.linkingSelected.localPosition = U_Vector3.zero
    self.config.linkingSelected.gameObject:SetActive(true)
    PopupMgr.ShowPopup(UIPopupName.UIPopupLinking, { ["id"] = linkingId, ["anchor"] = U_Vector2(0.5, 1),
                                                     ["position"] = self.config.linkingPos1.position, ["callbackClose"] = function()
            PopupMgr.HidePopup(UIPopupName.UIPopupLinking)
            self.config.linkingSelected.gameObject:SetActive(false)
            self.worldFormation:EnableLinking(BattleConstants.ATTACKER_TEAM_ID, false)
        end })
    -----@param v BaseLinking
    --for _, v in pairs(ResourceMgr.GetServiceConfig():GetHeroes().heroLinkingEntries:GetItems()) do
    --	if v.id == linkingId then
    --		self.worldFormation:EnableLinking(BattleConstants.ATTACKER_TEAM_ID, true, v.affectedHero)
    --		break
    --	end
    --end
end

function UIFormationDefenseView:OnClickLinkingDefender(index)
    local linkingId = self.listLinking2:Get(index)
    self.config.linkingSelected:SetParent(self.config.linkingDefender:GetChild(index - 1))
    self.config.linkingSelected.localPosition = U_Vector3.zero
    self.config.linkingSelected.gameObject:SetActive(true)
    PopupMgr.ShowPopup(UIPopupName.UIPopupLinking, { ["id"] = linkingId, ["anchor"] = U_Vector2(0.5, 1),
                                                     ["position"] = self.config.linkingPos2.position, ["callbackClose"] = function()
            PopupMgr.HidePopup(UIPopupName.UIPopupLinking)
            self.config.linkingSelected.gameObject:SetActive(false)
            self.worldFormation:EnableLinking(BattleConstants.DEFENDER_TEAM_ID, false)
        end })
    -----@param v BaseLinking
    --for _, v in pairs(ResourceMgr.GetServiceConfig():GetHeroes().heroLinkingEntries:GetItems()) do
    --	if v.id == linkingId then
    --		self.worldFormation:EnableLinking(BattleConstants.DEFENDER_TEAM_ID, true, v.affectedHero)
    --		break
    --	end
    --end
end

function UIFormationDefenseView:OnClickCompanion1()
    local data = {}
    data.companionId = ClientConfigUtils.GetCompanionIdBuyTeamFormation(self.model.teamFormation)
    data.summonerId = self.summonerInbound.summonerId
    data.summonerStar = self.summonerInbound.star
    PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

function UIFormationDefenseView:OnClickCompanion2()
    local data = {}
    data.companionId = ClientConfigUtils.GetCompanionIdByBattleTeamInfo(self.model.defenderTeamInfo)
    data.summonerId = self.model.defenderTeamInfo.summonerBattleInfo.summonerId
    data.summonerStar = self.model.defenderTeamInfo.summonerBattleInfo.star
    PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

function UIFormationDefenseView:OnClickSkip()
    self:OnClickBattle(true)
end

---@return void
function UIFormationDefenseView:SaveFormationLocal()
    if self.landCollectionData == nil then
        self.landCollectionData = LandCollectionData(self.land)
        self.defenseModeInbound.landCollectionDataMap:Add(self.land, self.landCollectionData)
    end
    self.landCollectionData.teamFormation = TeamFormationInBound.Clone(self.model.teamFormation)
end

--- @param onSuccess function
function UIFormationDefenseView:SaveFormationServer(onSuccess, showWaiting)
    if self.landCollectionData == nil or self.model.teamFormation:IsContainHeroInFormation() then
        local battleFormationOutBound = BattleFormationOutBound(UIFormationTeamData.CreateByTeamFormationInBound(self.model.teamFormation))
        NetworkUtils.RequestAndCallback(OpCode.DEFENSE_MODE_SAVE_TOWER_FORMATION, SaveFormationDefenseOutBound(battleFormationOutBound, self.land), function()
            self:SaveFormationLocal()
            if onSuccess ~= nil then
                onSuccess()
            end
        end, SmartPoolUtils.LogicCodeNotification, nil, showWaiting)
    end
end

---@return void
function UIFormationDefenseView:OnClickBattle(isSkip)
    if self.model.teamFormation ~= nil and self.model.teamFormation:IsContainHeroInFormation() then
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        local callbackSuccess = function(defenderTeamInfoOverride, isSkipResult, isAttackerWinInServer)
            zg.battleMgr.gameMode = self.currentMode
            self:SaveFormationLocal()
            if defenderTeamInfoOverride ~= nil then
                self.model.defenderTeamInfo = defenderTeamInfoOverride
            end
            --- @type DefenseModeInbound
            self.defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
            ---@type{land, teamFormationInBound, listAttackerTeamStageConfig}
            local data = {}
            data.land = self.land
            data.teamFormationInBound = self.model.teamFormation
            data.listAttackerTeamStageConfig = self.listAttackerTeamStageConfig
            self.defenseModeInbound:SaveCurrentBattleData(data)

            if isSkipResult ~= true then
                if isSkip == true then
                    ----nil, zg.battleMgr.gameMode == GameMode.TOWER and RunMode.NORMAL or RunMode.FASTEST)
                    local data = {}
                    data.gameMode = self.currentMode
                    data.rewardList = zg.playerData.rewardList
                    data.teamFormation = self.model.teamFormation
                    data.isSkip = isSkip

                    if self.defenseModeInbound.defenseChallengeResultInBound.isWin == true then
                        data.callbackClose = function()
                            PopupMgr.HidePopup(UIPopupName.UIVictory)
                            self:OnReadyHide()
                        end
                        PopupMgr.ShowPopup(UIPopupName.UIVictory, data)
                    else
                        data.callbackClose = function()
                            PopupMgr.HidePopup(UIPopupName.UIDefeat)
                            self:OnReadyHide()
                        end
                        data.callbackUpgrade = function(popupName)
                            PopupMgr.HidePopup(UIPopupName.UIDefeat)
                            PopupMgr.HidePopup(UIPopupName.UIFormationDefense)
                            if popupName == UIPopupName.UIHeroCollection then
                                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                            end
                            PopupMgr.ShowPopup(popupName)
                        end
                        PopupMgr.ShowPopup(UIPopupName.UIDefeat, data)
                    end
                else
                    self.defenseModeInbound.defenseChallengeResultInBound:RunTheFirstBattle(self.model.teamFormation,
                            self.listAttackerTeamStageConfig,
                            self.land)
                end
            end
        end
        if self.callbackPlayBattle ~= nil then
            self.callbackPlayBattle(UIFormationTeamData.CreateByTeamFormationInBound(self.model.teamFormation),
                    callbackSuccess,
                    self.powerAttacker)
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("insert_least_one_hero"))
    end
end

---@return void
function UIFormationDefenseView:OnClickSave()
    if self.model.teamFormation ~= nil and self.model.teamFormation:IsContainHeroInFormation() then
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:SaveFormationServer(function()
            self:OnClickBackOrClose()
        end, true)
        local callbackSuccess = function(defenderTeamInfoOverride, isSkipResult, isAttackerWinInServer)

        end
        if self.callbackPlayBattle ~= nil then
            self.callbackPlayBattle(UIFormationTeamData.CreateByTeamFormationInBound(self.model.teamFormation), callbackSuccess, self.powerAttacker)
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("insert_least_one_hero"))
    end
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIFormationDefenseView:ShowTutorial(tutorial, step)
    --XDebug.Log(step)
    if step == TutorialStep.FORMATION_SELECT_HERO_1 then
        tutorial:ViewFocusCurrentTutorial(self.heroList.uiScroll.scroll.content:GetChild(0):
        GetComponent(ComponentName.UnityEngine_UI_Button), 0.5, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.FORMATION_SELECT_HERO_2 then
        tutorial:ViewFocusCurrentTutorial(self.heroList.uiScroll.scroll.content:GetChild(1):
        GetComponent(ComponentName.UnityEngine_UI_Button), 0.5, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.FORMATION_BUFF then
        tutorial:ViewFocusCurrentTutorial(nil, 2, function()
            return self.config.transform.position + U_Vector3(-4, -0.5, 0)
        end)
    elseif step == TutorialStep.FORMATION_BATTLE_CLICK then
        ---@type UnityEngine_UI_Button
        local buttonBattle = self.config.battleButtonNotSkip
        if buttonBattle.gameObject.activeInHierarchy == false then
            buttonBattle = self.config.battleButton
        end
        tutorial:ViewFocusCurrentTutorial(buttonBattle, U_Vector2(500, 150), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.POSITION_2 then
        ---@type UnityEngine_UI_Button
        local button = self.worldFormation.attackerWorldFormation.worldFormation:GetAttackerButtonSlotByPosition(true, 2)
        tutorial:ViewFocusCurrentTutorial(button, 0.5, function()
            return self.worldFormation:GetPositionUI(button.transform)
        end, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.POSITION_3 then
        ---@type UnityEngine_UI_Button
        local button = self.worldFormation.attackerWorldFormation.worldFormation:GetAttackerButtonSlotByPosition(false, 1)
        tutorial:ViewFocusCurrentTutorial(button, 0.5, function()
            return self.worldFormation:GetPositionUI(button.transform)
        end, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.FORMATION_DRAG_HERO then
        ---@type UnityEngine_UI_Button
        local button1 = self.worldFormation.attackerWorldFormation.worldFormation:GetAttackerButtonSlotByPosition(true, 2)
        ---@type UnityEngine_Vector3
        local position1 = self.worldFormation:WorldToScreen(button1.transform.position + U_Vector3.down)
        ---@type UnityEngine_UI_Button
        local button2 = self.worldFormation.attackerWorldFormation.worldFormation:GetAttackerButtonSlotByPosition(false, 2)
        ---@type UnityEngine_Vector3
        local position2 = self.worldFormation:WorldToScreen(button2.transform.position + U_Vector3.down)
        local down = function()
            --XDebug.Log("DRAG DOWN")
            self.worldFormation:SlotTriggerPointerDown(true, { ["isFrontLine"] = true, ["positionId"] = 2 })
        end
        local drag = function(p)
            self.worldFormation:SlotTriggerPointerDrag(true, p)
        end
        local upSuccess = function(p)
            --XDebug.Log("DRAG SUCCESS")
            self.worldFormation:SlotTriggerPointerUp(true, p)
            ---@param v HeroFormationInBound
            for i, v in pairs(self.model.teamFormation.backLine:GetItems()) do
                if v.positionId == 2 and v.heroInventoryId ~= nil and v.heroInventoryId > 0 then
                    --XDebug.Log("DRAG HERO SUCCESS")
                    return true
                end
            end
            return false
        end
        local upFail = function()
            --XDebug.Log("DRAG FAIL => RevertTempSwitch")
            self.worldFormation:RevertTempSwitch()
            --XDebug.Log("after RevertTempSwitch")
        end
        local checkDown = function(p, isFrontLine, positionId)
            return self.worldFormation:CheckOverlapSlot(p, isFrontLine, positionId)
        end
        local checkUp = function(p, isFrontLine, positionId)
            --- @type {isFrontLine, positionId}
            local pos = self.worldFormation:GetNearestSlotFromPos(p)
            if pos ~= nil and pos.positionId == positionId and pos.isFrontLine == isFrontLine then
                return true
            else
                return false
            end
        end
        local callbackFailedDrag = function(isFrontLineFrom, positionIdFrom, isFrontLineTo, positionIdTo)
            ---@type HeroResource
            local hero = self.worldFormation.model.attackerTeamFormation:GetHeroResourceByPosition(isFrontLineFrom, positionIdFrom)
            self.worldFormation:RemoveHeroAtPosition(true, isFrontLineFrom, positionIdFrom)
            self.worldFormation:SetHeroAtPosition(true, isFrontLineTo, positionIdTo, hero)
        end
        tutorial:ViewDragCurrentTutorial(position1, position2, down, drag, upSuccess, upFail, checkDown, checkUp, callbackFailedDrag)
    end
end

--- @param bgParams {}
function UIFormationDefenseView:ShowBgAnchor(bgParams)
    local bgAnchorTop, bgAnchorBot
    if self.currentMode == GameMode.CAMPAIGN then
        local nameBgAnchorTop, nameBgAnchorBot = BattleBackgroundUtils.GetBgPrefixByGameMode(self.currentMode)
        local selectBackgroundId = ResourceMgr.GetCampaignDataConfig():GetRandomBgByStage(bgParams, 1)
        bgAnchorTop = nameBgAnchorTop .. selectBackgroundId
        --bgAnchorBot = nameBgAnchorBot .. selectBackgroundId
    else
        bgAnchorTop, bgAnchorBot = BattleBackgroundUtils.GetBgAnchorNameByMode(self.currentMode, bgParams)
    end
    self.worldFormation:ShowBgAnchor(bgAnchorTop, bgAnchorBot)
end

function UIFormationDefenseView:OnClickRemoveAll()
    ---@param v HeroFormationInBound
    for _, v in pairs(self.model.teamFormation.backLine:GetItems()) do
        self:RemoveHeroFromTeam(v.heroInventoryId)
    end
    ---@param v HeroFormationInBound
    for _, v in pairs(self.model.teamFormation.frontLine:GetItems()) do
        self:RemoveHeroFromTeam(v.heroInventoryId)
    end
    self.heroList.uiScroll:RefreshCells()
    self:UpdateTeamFormation()
end

function UIFormationDefenseView:OnClickShowAttackerInfor()
    self:SaveFormationLocal()
    local listHero = self.model.teamFormation:GetListHero()
    if listHero:Count() > 0 then
        --- @type {gameMode:GameMode, stage, callbackPlayBattle:function, land, callbackClose}
        local formationData = self.data
        formationData.teamFormation = self.landCollectionData.teamFormation
        local heroMenuData = {}
        heroMenuData.heroSort = listHero
        heroMenuData.callbackClose = function()
            PopupMgr.ShowAndHidePopup(self.model.uiName, formationData, UIPopupName.UIHeroMenu2)
        end
        PopupMgr.ShowAndHidePopup(UIPopupName.UIHeroMenu2, heroMenuData, self.model.uiName)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("insert_least_one_hero"))
    end
end
