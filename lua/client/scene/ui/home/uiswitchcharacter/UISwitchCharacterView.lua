require "lua.client.scene.ui.home.uiSwitchCharacter.WorldPreviewSwitchSummoner"
require "lua.client.scene.ui.home.uiSwitchCharacter.UISummonerInfo"
require "lua.client.scene.ui.home.uiSwitchCharacter.UISummonerEvolve"

--- @class UISwitchCharacterView : UIBaseView
UISwitchCharacterView = Class(UISwitchCharacterView, UIBaseView)

--- @return void
--- @param model UISwitchCharacterModel
function UISwitchCharacterView:Ctor(model)
    ---@type UISwitchCharacterConfig
    self.config = nil
    --- @type function
    self.callbackSwitch = nil
    --- @type UISelect
    self.selectClass = nil
    --- @type WorldPreviewSwitchSummoner
    self.worldPreviewSwitchSummoner = nil
    ---@type List
    self.listSkill = List()
    ---@type List  --<UISelectSummonerConfig>
    self.listTab = List()
    ---@type number
    self.summonerId = nil
    ---@type PlayerSummonerInBound
    self.summonerInbound = nil
    --- @type UISelect
    self.tab = nil
    ---@type UISummonerInfo
    self.summonerInfo = nil
    ---@type UISummonerEvolve
    self.summonerEvolve = nil

    --- @type table
    self.funSelectTab = { self.ShowInfo, self.ShowEvolve }
    self.funHideTab = { self.HideInfo, self.HideEvolve }

    UIBaseView.Ctor(self, model)
    --- @type UISwitchCharacterModel
    self.model = model
end

--- @return void
function UISwitchCharacterView:OnReadyCreate()
    ---@type UISwitchCharacterConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.summonerInfo = UISummonerInfo(self.config.content:GetChild(0))
    self.summonerEvolve = UISummonerEvolve(self.config.content:GetChild(1))
    self.worldPreviewSwitchSummoner = WorldPreviewSwitchSummoner(self.config.previewSwitchSummoner)

    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    self.config.buttonSwitch.onClick:AddListener(function()
        self:OnClickSwitch()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonSwitchAll.onClick:AddListener(function()
        self:OnClickSwitchAll()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonTutorial.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    for i = 1, self.config.tab.childCount do
        self.listTab:Add(UIBaseConfig(self.config.tab:GetChild(i - 1)))
    end

    -- Select faction
    --- @param obj UISelectSummonerConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        if isSelect then
            UIUtils.SetInteractableButton(obj.button, false)
            obj.transform.localScale = U_Vector3.one * 0.9
            obj.select:SetActive(true)
        else
            obj.transform.localScale = U_Vector3.one * 0.8
            UIUtils.SetInteractableButton(obj.button, true)
            obj.select:SetActive(false)
        end
    end
    local onChangeSelect = function(indexTab, lastTab)
        if indexTab ~= nil then
            self:ShowSummoner(indexTab - 1)
        end
    end
    local onClickSelect = function(indexTab)
        self:OnClickItem(indexTab)
        --UIMainCharacterMenuView.PlaySummonerVoice(indexTab)
    end
    local conditionClick = function(indexTab)
        if indexTab ~= 1 and self.summonerInbound.star == 3 then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("summoner_lock"))
            return false
        else
            return true
        end
    end
    self.selectClass = UISelect(self.config.tab, UIBaseConfig, onSelect, onChangeSelect, onClickSelect, conditionClick)

    -- Tab
    --- @param obj UITabPopupConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        obj.button.interactable = not isSelect
        obj.imageOn.gameObject:SetActive(isSelect)
        self.config.content:GetChild(indexTab - 1).gameObject:SetActive(isSelect)
    end
    local onChangeSelect = function(indexTab, lastTab)
        if lastTab ~= nil then
            self.funHideTab[lastTab](self)
        end
        if indexTab ~= nil then
            self.funSelectTab[indexTab](self)
        end
    end
    local conditionClick = function(indexTab)
        if indexTab == 2 then
            if self.summonerInbound:IsCanEvolve() then
                return true
            else
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_max_star"))
                return false
            end
        else
            return true
        end
    end
    self.tab = UISelect(self.config.tabInfo, UIBaseConfig, onSelect, onChangeSelect, nil, conditionClick)
end

--- @return void
function UISwitchCharacterView:ShowInfo()
    self.summonerInfo:Show(self.selectClass.indexTab - 1, self.summonerInbound.star)
end

--- @return void
function UISwitchCharacterView:HideInfo()
    self.summonerInfo:Hide()
end

--- @return void
function UISwitchCharacterView:ShowEvolve()
    self.summonerEvolve:Show(self.selectClass.indexTab - 1, self.summonerInbound.star)
end

--- @return void
function UISwitchCharacterView:HideEvolve()
    self.summonerEvolve:Hide()
end

--- @return void
function UISwitchCharacterView:OnEvolve()
    self.summonerEvolve:Hide()
end

--- @return void
function UISwitchCharacterView:InitLocalization()
    self.config.localizeInfo.text = LanguageUtils.LocalizeCommon("hero_info")
    self.config.localizeEvolve.text = LanguageUtils.LocalizeCommon("evolve")
    self.config.localizeSwitchCharacter.text = LanguageUtils.LocalizeCommon("switch_character")
    self.config.localizeSelected.text = LanguageUtils.LocalizeCommon("selected")
    self.config.localizeBack.text = LanguageUtils.LocalizeCommon("back")
    self.config.localizeSwitchAll.text = LanguageUtils.LocalizeCommon("switch_all")
    self.summonerEvolve:InitLocalization()
end

--- @return void
function UISwitchCharacterView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("summoner_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
function UISwitchCharacterView:Init(data)
    self.summonerInbound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    self.callbackSwitch = data.callbackSwitch
    self.summonerId = data.summonerId
    local tier = ClientConfigUtils.GetTierByStar(self.summonerInbound.star)
    ---@param v UISelectSummonerConfig
    for i, v in ipairs(self.listTab:GetItems()) do
        v.image.sprite = ResourceLoadUtils.LoadBannerSummonerIcon(i - 1, tier)
    end

    local id = self.summonerInbound.summonerId
    if self.summonerId ~= nil then
        id = self.summonerId
    end
    self.selectClass:Select(math.max(id + 1, 1))

    self.tab:Select(1)

    self:UpdateUIBySummonerStar()
end

--- @return number
function UISwitchCharacterView:GetIdByIndex(index)
    local id = index % 5
    if id == 0 then
        id = 5
    end
    return id
end

--- @return void
function UISwitchCharacterView:UpdateButtonSwitch()
    if self.summonerInbound.star == 3 then
        self.config.buttonSwitchAll.gameObject:SetActive(false)
        self.config.buttonSwitch.gameObject:SetActive(false)
        self.config.selected:SetActive(false)
    else
        if self.summonerId ~= nil then
            self.config.buttonSwitchAll.gameObject:SetActive(false)
            if self.summonerId == self.selectClass.indexTab - 1 then
                self.config.buttonSwitch.gameObject:SetActive(false)
                self.config.selected:SetActive(true)
            else
                self.config.buttonSwitch.gameObject:SetActive(true)
                self.config.selected:SetActive(false)
            end
        else
            self.config.buttonSwitchAll.gameObject:SetActive(true)
            self.config.buttonSwitch.gameObject:SetActive(false)
            self.config.selected:SetActive(false)
        end
    end
end

--- @return void
function UISwitchCharacterView:UpdateUIBySummonerStar()
    if not self.summonerInbound:IsCanEvolve() and self.tab.indexTab ~= 1 then
        -- Auto change tab info when can not evolve
        self.tab:Select(1)
    end
    if self.summonerInbound.star == 3 then
        self.config.tab:GetChild(0).gameObject:SetActive(true)
        for i = 1, self.config.tab.childCount - 1 do
            UIUtils.SetActiveColor(self.config.tab:GetChild(i).gameObject, false)
        end
    else
        self.config.tab:GetChild(0).gameObject:SetActive(false)
        for i = 1, self.config.tab.childCount - 1 do
            UIUtils.SetActiveColor(self.config.tab:GetChild(i).gameObject, true)
        end
    end
    self:UpdateButtonSwitch()
    self:CheckNotiEvolve()
end

--- @return void
function UISwitchCharacterView:OnReadyShow(result)
    self.worldPreviewSwitchSummoner:OnShow()
    self:Init(result)
    self.subscriptionEvolve = RxMgr.summonerStar:Subscribe(function()
        self:UpdateUIBySummonerStar()
        self.selectClass:Select(self.summonerInbound.summonerId + 1)
    end)
end

--- @return void
function UISwitchCharacterView:CheckNotiEvolve()
    if self.summonerInbound ~= nil then
        self.config.notiEvolve:SetActive(self.summonerInbound:IsNotiEvolve())
    end
end

--- @return void
function UISwitchCharacterView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return void
function UISwitchCharacterView:Hide()
    UIBaseView.Hide(self)
    ClientConfigUtils.KillCoroutine(self.coroutine)
    self.worldPreviewSwitchSummoner:OnHide()
    PopupUtils.CheckAndHideSkillPreview()
    self:RemoveListenerTutorial()
    if self.subscriptionEvolve ~= nil then
        self.subscriptionEvolve:Unsubscribe()
    end
    self.selectClass:Select(nil)
    ResourceLoadUtils.UnloadFolderAtlas()
end

function UISwitchCharacterView:OnClickBackOrClose()
    self:OnReadyHide()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

--- @return void
--- @param index number
function UISwitchCharacterView:OnClickItem(index)

end

--- @return void
--- @param index number
function UISwitchCharacterView:ShowSummoner(index)
    if index ~= nil then
        if self.summonerInfo.config.gameObject.activeInHierarchy then
            self.summonerInfo:Show(self.selectClass.indexTab - 1, self.summonerInbound.star)
        elseif self.summonerEvolve.config.gameObject.activeInHierarchy then
            self.summonerEvolve:Show(self.selectClass.indexTab - 1, self.summonerInbound.star)
        end
        local star = self.summonerInbound.star
        self.worldPreviewSwitchSummoner:ShowHero(index, self.summonerInbound.star)
        local starNumber = star % 6
        if starNumber == 0 then
            starNumber = 6
        end
        self.config.star.sprite = ResourceLoadUtils.LoadStarHeroInfo(star)
        UIUtils.SlideImageHorizontal(self.config.star, starNumber)
        self.config.textNameCharacter.text = LanguageUtils.LocalizeSummonerName(self.selectClass.indexTab - 1)

        self:UpdateButtonSwitch()
    end
end

--- @return void
function UISwitchCharacterView:OnClickSwitch()
    if self.callbackSwitch ~= nil then
        self.callbackSwitch(self.selectClass.indexTab - 1)
    end
end

--- @return void
function UISwitchCharacterView:OnClickSwitchAll()
    local switchAll = function()
        local summonerId = self.selectClass.indexTab - 1
        local onReceived = function(result)
            local onSuccess = function()
                self.summonerInbound.summonerId = summonerId
                ---@param gameMode GameMode
                ---@param teamFormation TeamFormationInBound
                for gameMode, teamFormation in pairs(zg.playerData:GetFormationInBound().teamDict:GetItems()) do
                    teamFormation.summonerId = summonerId
                end
                if zg.playerData:GetFormationInBound().arenaTeamDict ~= nil then
                    ---@param teamFormation TeamFormationInBound
                    for gameMode, teamFormation in pairs(zg.playerData:GetFormationInBound().arenaTeamDict:GetItems()) do
                        teamFormation.summonerId = summonerId
                    end
                end

                ---@type DefenseModeInbound
                local defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
                if defenseModeInbound ~= nil then
                    ---@param land LandCollectionData
                    for _, land in pairs(defenseModeInbound.landCollectionDataMap:GetItems()) do
                        if land.teamFormation then
                            land.teamFormation.summonerId = summonerId
                        end
                    end
                end
                if self.callbackSwitch ~= nil then
                    self.callbackSwitch(summonerId)
                end
                RxMgr.switchMainCharacter:Next({ ["id"] = summonerId })
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("change_success"))
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
        end
        NetworkUtils.Request(OpCode.SUMMONER_CLASS_SELECT, UnknownOutBound.CreateInstance(PutMethod.Byte, summonerId), onReceived)
    end
    --local callbackClose = function()
    --	PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
    --end
    --PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("notice_switch_all_summoner"),
    --		switchAll, callbackClose, true, callbackClose)


    local data = {}
    data.notification = LanguageUtils.LocalizeCommon("notice_switch_all_summoner")
    data.alignment = U_TextAnchor.MiddleCenter
    data.canCloseByBackButton = true
    local buttonNo = {}
    buttonNo.text = LanguageUtils.LocalizeCommon("cancel")
    buttonNo.callback = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
    end
    data.button1 = buttonNo

    local buttonYes = {}
    buttonYes.text = LanguageUtils.LocalizeCommon("confirm")
    buttonYes.callback = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
        switchAll()
    end
    data.button2 = buttonYes
    data.clickBgCallback = buttonNo.callback
    PopupMgr.ShowPopup(UIPopupName.UIPopupNotification, data)
end

---@param tutorial UITutorialView
function UISwitchCharacterView:ShowTutorialSummonerClass(tutorial, class)
    if self.selectClass.indexTab ~= class + 1 then
        self.selectClass:Select(class + 1)
    end
    tutorial:ViewFocusCurrentTutorial(nil, U_Vector2(600, 300), self.selectClass.uiTransform:GetChild(class):GetChild(0).position)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UISwitchCharacterView:ShowTutorial(tutorial, step)
    --XDebug.Log(step)
    if step == TutorialStep.CLICK_TAB_EVOLVE then
        if self.tab.indexTab == 2 then
            self.tab:Select(1)
        end
        tutorial:ViewFocusCurrentTutorial(self.tab.uiTransform:GetChild(1):
        GetComponent(ComponentName.UnityEngine_UI_Button), U_Vector2(300, 200), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_EVOLVE then
        tutorial:ViewFocusCurrentTutorial(self.summonerEvolve.config.buttonEvolve, U_Vector2(400, 200), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_SWITCH_SUMMONER then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonSwitch, U_Vector2(400, 200), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.SUMMONER_CLASS_1 then
        self:ShowTutorialSummonerClass(tutorial, 1)
    elseif step == TutorialStep.SUMMONER_CLASS_2 then
        self:ShowTutorialSummonerClass(tutorial, 2)
    elseif step == TutorialStep.SUMMONER_CLASS_3 then
        self:ShowTutorialSummonerClass(tutorial, 3)
    elseif step == TutorialStep.SUMMONER_CLASS_4 then
        self:ShowTutorialSummonerClass(tutorial, 4)
    elseif step == TutorialStep.SUMMONER_CLASS_5 then
        self:ShowTutorialSummonerClass(tutorial, 5)
    elseif step == TutorialStep.ALL_SUMMONER then
        tutorial:ViewFocusCurrentTutorial(nil, U_Vector2(700, 1000), function()
            return self.config.tab.position + U_Vector3(-0.5, 0, 0)
        end)
    elseif step == TutorialStep.SWITCH_SUMMONER then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonSwitchAll, U_Vector2(400, 200), nil, nil, TutorialHandType.CLICK)
    end
end