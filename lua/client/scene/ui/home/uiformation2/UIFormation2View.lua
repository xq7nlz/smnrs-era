require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldFormation"
require "lua.client.scene.ui.home.uiFormation.UIFormationTeamData"
require "lua.client.core.network.formation.SetFormationOutBound"

--- @class UIFormation2View : UIBaseView
UIFormation2View = Class(UIFormation2View, UIBaseView)

--- @return void
--- @param model UIFormation2Model
--- @param ctrl UIFormation2Ctrl
function UIFormation2View:Ctor(model, ctrl)
    --- @type UIFormation2Config
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
    self.listHeroIgnor = nil

    ---@type List
    self.listLinking1 = List()
    ---@type List
    self.listLinking2 = List()

    ---@type PlayerSummonerInBound
    self.summonerInbound = nil
    self.coroutine = nil
    --- @type boolean
    self.isShowing = false

    self.cacheWorldFormation = false
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIFormation2Model
    self.model = model
    --- @type UIFormation2Ctrl
    self.ctrl = ctrl
end

--- @return void
function UIFormation2View:OnReadyCreate()
    ---@type UIFormation2Config
    self.config = UIBaseConfig(self.uiTransform)

    local onChangeSelectTeam = function(indexTab, lastTab)
        if lastTab ~= nil then
            ---@type UnityEngine_UI_Button
            local button = self.config.team:GetChild(lastTab - 1):GetComponent(ComponentName.UnityEngine_UI_Button)
            UIUtils.SetInteractableButton(button, true)
        end
        if indexTab ~= nil then
            --self.config.teamUpChosen.gameObject:SetActive(false)
        --    XDebug.Error(string.format("Index tab is nil"))
        --else
            --self.config.teamUpChosen.gameObject:SetActive(true)
            ---@type UnityEngine_Transform
            local child = self.config.team:GetChild(indexTab - 1)
            --self.config.teamUpChosen.transform:SetParent(child)
            --self.config.teamUpChosen.transform.localPosition = U_Vector3.zero
            ---@type UnityEngine_UI_Button
            local button = child:GetComponent(ComponentName.UnityEngine_UI_Button)
            UIUtils.SetInteractableButton(button, false)
        end
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
    self.tab = UISelect(self.config.team, nil, nil, onChangeSelectTeam, onClickSelectTeam, conditionSelect, onSelectFailed)

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
                self:AddHeroToTeam(heroResource)
                buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
                buttonHero:EnableButton(true)
                self:UpdateTeamFormation()
            else
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("noti_full_hero"))
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            end
        end
    end

    --- @return void
    --- @param heroIndex number
    --- @param heroResource HeroResource
    local filterAnd = function(heroIndex, heroResource)
        if self.listHeroIgnor ~= nil then
            return not self.listHeroIgnor:IsContainValue(heroResource.inventoryId)
        end
        return true
    end

    self.heroList:Init(self.buttonListener, nil, filterAnd, nil, nil, self.onUpdateIconHero, self.onUpdateIconHero)

    self:InitButtonListener()
end

--- @return void
function UIFormation2View:InitButtonListener()
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
        self:OnClickBattle()
    end)
    self.config.battleButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattle()
    end)
    self.config.battleButton2.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
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
    self.config.buttonArrow.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        local isEnable = self.config.defenderInfo.activeInHierarchy
        self:EnableDefenderTeam(not isEnable)
        self:ShowListHero(isEnable)
    end)

    for i = 1, self.config.linkingAttacker.childCount do
        local index = i
        ---@type UnityEngine_UI_Button
        local button = self.config.linkingAttacker:GetChild(index - 1):GetComponent(ComponentName.UnityEngine_UI_Button)
        button.onClick:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            self:OnClickLinkingAttacker(index)
        end)
    end
    for i = 1, self.config.linkingDefender.childCount do
        local index = i
        ---@type UnityEngine_UI_Button
        local button = self.config.linkingDefender:GetChild(index - 1):GetComponent(ComponentName.UnityEngine_UI_Button)
        button.onClick:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            self:OnClickLinkingDefender(index)
        end)
    end
end

function UIFormation2View:OnClickBackOrClose()
    self:SaveFormationServer()
    self.cacheWorld = self.cacheWorldFormation
    UIBaseView.OnClickBackOrClose(self)
end

--- @return void
function UIFormation2View:InitLocalization()
    self.config.textEnemy.text = LanguageUtils.LocalizeCommon("enemy")
    self.config.localizeVs.text = LanguageUtils.LocalizeCommon("vs")
    self.config.localizeSelectHero.text = LanguageUtils.LocalizeCommon("select_hero_battle")
    self.config.localizeSkip.text = LanguageUtils.LocalizeCommon("skip")

    local localizeBattle = LanguageUtils.LocalizeCommon("battle")
    self.config.localizeBattle.text = localizeBattle
    self.config.localizeBattle2.text = localizeBattle
    self.config.localizeBattle3.text = localizeBattle
    self.config.localizeRemoveAll.text = LanguageUtils.LocalizeCommon("remove_all")

    local localizeFormation = LanguageUtils.LocalizeCommon("formation")
    self.config.localizeFormation1.text = localizeFormation
    self.config.localizeFormation2.text = localizeFormation
    self.config.localizeFormation3.text = localizeFormation
    self.config.localizeFormation4.text = localizeFormation
end

--- @return void
function UIFormation2View:OnReadyShow(result)
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

    self.worldFormation:EnableModification(true)

    self:ShowListHero(true)
    self:ShowBgAnchor(result.bgParams)
end

--- @return void
function UIFormation2View:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @start world
function UIFormation2View:CheckCanSkip(canSkip)
    local enableSkip = false
    if self.model.currentMode == GameMode.RAID
            and ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.RAID, false) == true then
        enableSkip = true
    else
        ---@type {level, stage}
        local require = ResourceMgr.GetMinorFeatureLock().dict:Get(MinorFeatureType.BATTLE_SKIP)
        local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
        local playerLevel = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
        enableSkip = (vip.battleUnlockSkip == true or (require.level <= playerLevel and require.stage < zg.playerData:GetCampaignData().stageNext)) and canSkip == true
    end
    self.config.canSkip:SetActive(enableSkip)
    self.config.battleButtonNotSkip.gameObject:SetActive(not enableSkip)
end

--- @start world
function UIFormation2View:InitWorldFormation()
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

function UIFormation2View:OnShowWorldFormation()
    self.worldFormation:SetAttackerFormation(self.model.teamFormation.formationId)
    self.worldFormation:SetDefenderPredefineTeamData(self.model.defenderTeamInfo)
    self.coroutine = Coroutine.start(function()
        coroutine.waitforseconds(0.15)
        ---@type DetailTeamFormation
        local detailTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(self.model.teamFormation)
        self.worldFormation:ShowAttackerPredefineTeam(detailTeamFormation)
        self.worldFormation:ShowAttackerSummoner(self.model.teamFormation.summonerId, self.summonerInbound.star)
    end)
end

--- @param isEnable boolean
function UIFormation2View:EnableDefenderTeam(isEnable)
    self.worldFormation:EnableDefenderTeamView(isEnable)
end
--- @end world

--- @param isEnable boolean
function UIFormation2View:ShowListHero(isEnable)
    if isEnable == true then
        self.config.buttonArrow.transform.localScale = U_Vector3(math.abs(self.config.buttonArrow.transform.localScale.x), self.config.buttonArrow.transform.localScale.y, 1)
        self.config.groupSelectHero:SetActive(true)
        self.config.battleButton2.gameObject:SetActive(false)
        --self.heroList.uiScroll:RefreshCells()
        self.config.defenderInfo:SetActive(false)
    else
        self.config.buttonArrow.transform.localScale = U_Vector3(-math.abs(self.config.buttonArrow.transform.localScale.x), self.config.buttonArrow.transform.localScale.y, 1)
        self.config.groupSelectHero:SetActive(false)
        self.config.battleButton2.gameObject:SetActive(true)
        self.config.defenderInfo:SetActive(true)
        local companionBuff = ClientConfigUtils.GetCompanionIdByBattleTeamInfo(self.model.defenderTeamInfo)
        self.config.companion2.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(companionBuff)
    end
end

--- @return void
--- @param result {gameMode:GameMode, formationTeamData:UIFormationTeamData, rewardList:List<ItemIconData>, tittle}
function UIFormation2View:_Init(result)
    self.cacheWorld = nil
    self.cacheWorldFormation = false
    if result ~= nil then
        if result.cache == nil then
            self.model.currentMode = result.gameMode
            if self.model.currentMode ~= nil then
                self.model.teamFormation = TeamFormationInBound.Clone(zg.playerData:GetFormationInBound().teamDict:Get(self.model.currentMode))
            elseif result.teamFormation ~= nil then
                self.model.teamFormation = TeamFormationInBound.Clone(result.teamFormation)
            end
            self.model.defenderTeamInfo = result.battleTeamInfo
            self.callbackPlayBattle = result.callbackPlayBattle
            self.listHeroIgnor = result.listHeroIgnor
        end
        --XDebug.Log(LogUtils.ToDetail(result.worldFormation))
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

        if self.model.defenderTeamInfo == nil then
            self.config.buttonArrow.gameObject:SetActive(false)
            self.config.powerDefender:SetActive(false)
            self.config.enemyFormation:SetActive(false)
        else
            self.config.buttonArrow.gameObject:SetActive(true)
            self.config.powerDefender:SetActive(true)
            self.config.enemyFormation:SetActive(true)
            if result.cache == nil then
                self.powerDefenderTeam = result.powerDefenderTeam
            end
            if self.powerDefenderTeam == nil then
                self.powerDefenderTeam = ClientConfigUtils.GetPowerByBattleTeamInfo(self.model.defenderTeamInfo)
            end
            self.config.textPowerDefender.text = tostring(math.floor(self.powerDefenderTeam))
            self:UpdateLinkingDefenderTeam()
        end
        self.heroList:SetData(InventoryUtils.Get(ResourceType.Hero), self.canPlayMotion)
        if self.canPlayMotion == true then
            self.canPlayMotion = false
        end
        self.tab:Select(self.model.teamFormation.formationId)
    end
end

function UIFormation2View:Hide()
    ClientConfigUtils.KillCoroutine(self.coroutine)
    self:HideWorldFormation()
    self.heroList:ReturnPool()
    self:RemoveListenerTutorial()
    self.cacheResult = nil
    self.isShowing = false
    UIBaseView.Hide(self)
    self.tab:Select(nil)
end

function UIFormation2View:HideWorldFormation()
    if self.worldFormation ~= nil and self.cacheWorld ~= true then
        self.worldFormation:OnHide()
        self.worldFormation = nil
    end
end

--- @return void
function UIFormation2View:UpdatePowerAttacker()
    ---@type BattleTeamInfo
    local battleTeamInfo = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByTeamFormationInBound(self.model.teamFormation)
    self.powerAttacker = math.floor(ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo))
    self.config.textPowerAttacker.text = tostring(self.powerAttacker)
end

--- @return void
function UIFormation2View:ChangeTeam()
    self.model.teamFormation:ChangeFormationId(self.tab.indexTab)
    self.worldFormation:SetAttackerFormation(self.model.teamFormation.formationId)
    ---@type DetailTeamFormation
    local detailTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(self.model.teamFormation)
    self.worldFormation:ShowAttackerPredefineTeam(detailTeamFormation)
end

--- @return void
--- @param heroResource HeroResource
function UIFormation2View:AddHeroToTeam(heroResource)
    local isFrontLine, position = self.model.teamFormation:AddHeroInventoryId(heroResource.inventoryId)
    self.worldFormation:SetHeroAtPosition(true, isFrontLine, position, heroResource)
    self.worldFormation:ResetButtonSlot()
end

--- @return void
--- @param inventoryId number
function UIFormation2View:RemoveHeroFromTeam(inventoryId)
    local isFrontLine, position = self.model.teamFormation:RemoveHeroInventoryId(inventoryId)
    self.worldFormation:RemoveHeroAtPosition(true, isFrontLine, position)
end

--- @return void
--- @param hero1 {isFrontLine, positionId}
--- @param hero2 {isFrontLine, positionId}
function UIFormation2View:CallbackSwapHero(hero1, hero2)
    self.model.teamFormation:SwapHero(hero1, hero2)
    self:UpdateTeamFormation()
end

--- @param hero {isFrontLine, positionId}
function UIFormation2View:CallbackRemove(hero)
    self.model.teamFormation:RemoveHeroPosition(hero)
    self.heroList.uiScroll:RefreshCells()
    self:UpdateTeamFormation()
end

function UIFormation2View:CallbackSelectSummoner()
    if self.summonerInbound.star > 3 then
        if self.model.teamFormation:IsContainHeroInFormation() then
            local dataFormation = self.cacheResult
            dataFormation.cache = true
            local data = {}
            data.summonerId = self.model.teamFormation.summonerId
            data.callbackSwitch = function(summonerId)
                dataFormation.worldFormation = nil
                self.model.teamFormation.summonerId = summonerId
                self.model.currentMode = dataFormation.gameMode
                if self.model.currentMode ~= nil
                        and self.model.currentMode ~= GameMode.ARENA
                        and self.model.currentMode ~= GameMode.GUILD_WAR then
                    self:SaveFormationServer(function()
                        PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, dataFormation, UIPopupName.UISwitchCharacter)
                    end)
                else
                    PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, dataFormation, UIPopupName.UISwitchCharacter)
                end
            end
            data.callbackClose = function()
                dataFormation.worldFormation = nil
                PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, dataFormation, UIPopupName.UISwitchCharacter)
            end
            self.cacheWorldFormation = false
            self.cacheWorld = self.cacheWorldFormation
            PopupMgr.ShowAndHidePopup(UIPopupName.UISwitchCharacter, data, UIPopupName.UIFormation2)
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("insert_least_one_hero"))
        end
    end
end

--- @return void
---@param listHero List
---@param rectTransform UnityEngine_RectTransform
---@param listLinkingReturn List
function UIFormation2View:SetListLinking(listHero, rectTransform, listLinkingReturn)
    listLinkingReturn:Clear()
    for i = 1, rectTransform.childCount do
        rectTransform:GetChild(i - 1).gameObject:SetActive(false)
    end
    --local index = 0
    -----@param v BaseLinking
    --for _, v in pairs(ResourceMgr.GetServiceConfig():GetHeroes().heroLinkingEntries:GetItems()) do
    --    local active = true
    --    for _, heroId in pairs(v.affectedHero:GetItems()) do
    --        if listHero:IsContainValue(heroId) == false then
    --            active = false
    --            break
    --        end
    --    end
    --    if active == true then
    --        listLinkingReturn:Add(v.id)
    --        ---@type UnityEngine_UI_Image
    --        local image = rectTransform:GetChild(index):GetComponent(ComponentName.UnityEngine_UI_Image)
    --        image.gameObject:SetActive(true)
    --        image.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLinking, v.id)
    --        index = index + 1
    --    end
    --end
end

--- @return void
function UIFormation2View:UpdateLinkingTeamFormation()
    -----@type List
    --local listHeroId = self.model.teamFormation:GetListHeroId()
    --self:SetListLinking(listHeroId, self.config.linkingAttacker, self.listLinking1)
end

--- @return void
function UIFormation2View:UpdateLinkingDefenderTeam()
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
function UIFormation2View:UpdateTeamFormation()
    self:UpdateLinkingTeamFormation()
    self:UpdatePowerAttacker()
    self:UpdateCompanionBuff()
end

--- @return void
function UIFormation2View:UpdateCompanionBuff()
    local companionBuff = ClientConfigUtils.GetCompanionIdBuyTeamFormation(self.model.teamFormation)
    self.config.companion1.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(companionBuff)
end

function UIFormation2View:OnClickLinkingAttacker(index)
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
    --    if v.id == linkingId then
    --        self.worldFormation:EnableLinking(BattleConstants.ATTACKER_TEAM_ID, true, v.affectedHero)
    --        break
    --    end
    --end
end

function UIFormation2View:OnClickLinkingDefender(index)
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
    --    if v.id == linkingId then
    --        self.worldFormation:EnableLinking(BattleConstants.DEFENDER_TEAM_ID, true, v.affectedHero)
    --        break
    --    end
    --end
end

function UIFormation2View:OnClickCompanion1()
    local data = {}
    data.companionId = ClientConfigUtils.GetCompanionIdBuyTeamFormation(self.model.teamFormation)
    data.summonerId = self.summonerInbound.summonerId
    data.summonerStar = self.summonerInbound.star
    PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

function UIFormation2View:OnClickCompanion2()
    local data = {}
    data.companionId = ClientConfigUtils.GetCompanionIdByBattleTeamInfo(self.model.defenderTeamInfo)
    data.summonerId = self.model.defenderTeamInfo.summonerBattleInfo.summonerId
    data.summonerStar = self.model.defenderTeamInfo.summonerBattleInfo.star
    PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

function UIFormation2View:OnClickSkip()
    self:OnClickBattle(true)
end

---@return void
function UIFormation2View:SaveFormationLocal()
    if self.model.currentMode ~= nil then
        zg.playerData:GetFormationInBound().teamDict:Add(self.model.currentMode, TeamFormationInBound.Clone(self.model.teamFormation))
    end
end

--- @param onSuccess function
function UIFormation2View:SaveFormationServer(onSuccess, showWaiting)
    if self.model.currentMode ~= nil
            and self.model.currentMode ~= GameMode.ARENA
            and self.model.currentMode ~= GameMode.GUILD_WAR then
        if self.model.teamFormation:Equal(zg.playerData:GetFormationInBound().teamDict:Get(self.model.currentMode)) == false then
            local battleFormationOutBound = BattleFormationOutBound(UIFormationTeamData.CreateByTeamFormationInBound(self.model.teamFormation))
            NetworkUtils.RequestAndCallback(OpCode.FORMATION_SET, SetFormationOutBound(battleFormationOutBound, self.model.currentMode), function()
                self:SaveFormationLocal()
                if onSuccess ~= nil then
                    onSuccess()
                end
            end, nil, nil, showWaiting)
        end
    elseif self.model.teamFormation:Equal(zg.playerData:GetFormationInBound().teamDict:Get(self.model.currentMode)) == false then
        self.cacheWorldFormation = false
        if self.cacheResult ~= nil then
            self.cacheResult.returnWorldFormation = function() return nil end
        end
    end
end

---@return void
function UIFormation2View:OnClickBattle(isSkip)
    if self.model.teamFormation ~= nil and self.model.teamFormation:IsContainHeroInFormation() then
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        local callbackSuccess = function(defenderTeamInfoOverride, isSkipResult, isAttackerWinInServer, battleLog)
            zg.battleMgr.gameMode = self.model.currentMode
            self:SaveFormationLocal()
            if defenderTeamInfoOverride ~= nil then
                self.model.defenderTeamInfo = defenderTeamInfoOverride
            end

            if isSkipResult ~= true then

                local LogWrongBattle = function()
                    --if zg.battleMgr.gameMode == GameMode.TOWER then
                    --    XDebug.Log(string.format("IsAttackerWin: %s winnerTeam: %s", tostring(isAttackerWinInServer), tostring(ClientBattleData.battleResult.winnerTeam)))
                    --    if isAttackerWinInServer ~= (ClientBattleData.battleResult.winnerTeam == BattleConstants.ATTACKER_TEAM_ID) then
                    --        XDebug.Error(string.format("Invalid Tower: %s\n%s",
                    --                tostring(PlayerSettingData.playerId), ClientBattleData.battleResult:ToShortString(RunMode.NORMAL)))
                    --    end
                    --end
                end
                ---@type BattleTeamInfo
                local attackerTeam = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(self.model.currentMode)
                if isSkip == true then
                    zg.battleMgr:RunVirtualBattle(attackerTeam, self.model.defenderTeamInfo, self.model.currentMode, nil, RunMode.FASTEST, battleLog)
                    --nil, zg.battleMgr.gameMode == GameMode.TOWER and RunMode.NORMAL or RunMode.FASTEST)
                    local data = {}
                    data.gameMode = self.model.currentMode
                    data.result = ClientBattleData.battleResult
                    data.clientLogDetail = ClientBattleData.clientLogDetail
                    LogWrongBattle()

                    if ClientBattleData.battleResult.winnerTeam == BattleConstants.ATTACKER_TEAM_ID then
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
                            PopupMgr.HidePopup(UIPopupName.UIFormation2)
                            if popupName == UIPopupName.UIHeroCollection then
                                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                            end
                            PopupMgr.ShowPopup(popupName)
                        end
                        PopupMgr.ShowPopup(UIPopupName.UIDefeat, data)
                    end
                else
                    zg.battleMgr:RunCalculatedBattleScene(attackerTeam,
                            self.model.defenderTeamInfo,
                            self.model.currentMode,
                            nil,
                            LogWrongBattle, battleLog)
                end
            end
        end
        if self.callbackPlayBattle ~= nil then
            if self.model.currentMode == GameMode.FRIEND_BATTLE
                    or self.model.currentMode == GameMode.GUILD_DUNGEON
                    or self.model.currentMode == GameMode.GUILD_BOSS then
                self:SaveFormationServer(nil, false)
            end
            self.callbackPlayBattle(UIFormationTeamData.CreateByTeamFormationInBound(self.model.teamFormation),
                    callbackSuccess,
                    self.powerAttacker)
        end

        self.cacheWorld = self.cacheWorldFormation
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("insert_least_one_hero"))
    end
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIFormation2View:ShowTutorial(tutorial, step)
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
function UIFormation2View:ShowBgAnchor(bgParams)
    local bgAnchorTop, bgAnchorBot
    if self.model.currentMode == GameMode.CAMPAIGN then
        local nameBgAnchorTop, nameBgAnchorBot = BattleBackgroundUtils.GetBgPrefixByGameMode(self.model.currentMode)
        local selectBackgroundId = ResourceMgr.GetCampaignDataConfig():GetRandomBgByStage(bgParams, 1)
        bgAnchorTop = nameBgAnchorTop .. selectBackgroundId
        --bgAnchorBot = nameBgAnchorBot .. selectBackgroundId
    else
        bgAnchorTop, bgAnchorBot = BattleBackgroundUtils.GetBgAnchorNameByMode(self.model.currentMode, bgParams)
    end
    self.worldFormation:ShowBgAnchor(bgAnchorTop, bgAnchorBot)
end

function UIFormation2View:OnClickRemoveAll()
    ---@param v HeroFormationInBound
    for i, v in pairs(self.model.teamFormation.backLine:GetItems()) do
        self:RemoveHeroFromTeam(v.heroInventoryId)
    end
    ---@param v HeroFormationInBound
    for i, v in pairs(self.model.teamFormation.frontLine:GetItems()) do
        self:RemoveHeroFromTeam(v.heroInventoryId)
    end
    self.heroList.uiScroll:RefreshCells()
    self:UpdateTeamFormation()
end
