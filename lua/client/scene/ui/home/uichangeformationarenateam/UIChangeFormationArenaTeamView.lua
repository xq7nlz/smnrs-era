--- @class UIChangeFormationArenaTeamView : UIBaseView
UIChangeFormationArenaTeamView = Class(UIChangeFormationArenaTeamView, UIBaseView)

--- @return void
--- @param model UIChangeFormationArenaTeamModel
function UIChangeFormationArenaTeamView:Ctor(model)
    ---@type List TeamFormationInBound
    self.listFormation1 = List() --attack
    ---@type List
    self.listFormation2 = List() --def
    ---@type List -- UIArenaTeamFormationItemView
    self.listAttack = List()
    ---@type List
    self.listDefense = List()
    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UIChangeFormationArenaTeamModel
    self.model = model
end

--- @return void
function UIChangeFormationArenaTeamView:OnReadyCreate()
    ---@type UIChangeFormationArenaTeamConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()
end

function UIChangeFormationArenaTeamView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("arena_team_formation"))
end

function UIChangeFormationArenaTeamView:InitButtons()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
    self.config.buttonChange1.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangeTeamAttack()
    end)
    self.config.buttonChange2.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangeTeamDefense()
    end)
    self.config.buttonSave.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSaveTeam()
    end)
    self.config.buttonSyncAttacker.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:CopyFormation(1)
    end)
    self.config.buttonSyncDef.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:CopyFormation(2)
    end)
end

---@return Dictionary
function UIChangeFormationArenaTeamView:GetDictFormationChange()
    local dictFormation = Dictionary()
    ---@param v TeamFormationInBound
    for i, v in ipairs(self.listFormation1:GetItems()) do
        if v:Equal(zg.playerData:GetFormationInBound():GetArenaTeam(1, i)) == false then
            dictFormation:Add(1000 + i, v)
        end
    end
    ---@param v TeamFormationInBound
    for i, v in ipairs(self.listFormation2:GetItems()) do
        if v:Equal(zg.playerData:GetFormationInBound():GetArenaTeam(2, i)) == false then
            dictFormation:Add(2000 + i, v)
        end
    end
    return dictFormation
end

function UIChangeFormationArenaTeamView:OnClickBackOrClose()
    local close = function()
        UIBaseView.OnClickBackOrClose(self)
        self.callbackUpdateFormation = nil
    end
    if self:GetDictFormationChange():Count() > 0 then
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("do_you_want_save_formation"), close, function()
            self:OnClickSaveTeam()
        end)
    else
        close()
    end
end

function UIChangeFormationArenaTeamView:InitLocalization()
    self.config.textAttacker.text = LanguageUtils.LocalizeCommon("attacker")
    self.config.textDefender.text = LanguageUtils.LocalizeCommon("defender")

    self.config.textChangeAttacker.text = LanguageUtils.LocalizeCommon("change")
    self.config.textChangeDefender.text = LanguageUtils.LocalizeCommon("change")
    self.config.textSave.text = LanguageUtils.LocalizeCommon("save")

    self.config.textSyncAttacker.text = LanguageUtils.LocalizeCommon("synchronize")
    self.config.textSyncDefender.text = LanguageUtils.LocalizeCommon("synchronize")
end

function UIChangeFormationArenaTeamView:OnReadyShow(data)
    if data ~= nil then
        self.callbackUpdateFormation = data.callbackUpdateFormation
    end
    UIBaseView.OnReadyShow(self, data)
    self.listFormation1:Clear()

    self.listFormation2:Clear()
    for i = 1, 3 do
        self.listFormation1:Add(zg.playerData:GetFormationInBound():GetArenaTeam(1, i))
        self.listFormation2:Add(zg.playerData:GetFormationInBound():GetArenaTeam(2, i))
    end
    self:ReturnPoolBattle()
    for i = 1, 3 do
        ---@type UIArenaTeamFormationItemView
        local arenaTeamFormationItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIArenaTeamFormationItemView, self.config.elementL)
        arenaTeamFormationItemView:SetData(ClientConfigUtils.GetBattleTeamInfoArenaTeam(1, i), i)
        if i == 3 then
            arenaTeamFormationItemView.config.buttonChange.gameObject:SetActive(false)
        else
            arenaTeamFormationItemView.config.buttonChange.gameObject:SetActive(true)
            arenaTeamFormationItemView.callbackClickChange = function()
                self:SwapFormation(self.listFormation1, self.listAttack, i)
            end
        end
        self.listAttack:Add(arenaTeamFormationItemView)
    end
    for i = 1, 3 do
        ---@type UIArenaTeamFormationItemView
        local arenaTeamFormationItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIArenaTeamFormationItemView, self.config.elementR)
        arenaTeamFormationItemView:SetData(ClientConfigUtils.GetBattleTeamInfoArenaTeam(2, i), i)
        if i == 3 then
            arenaTeamFormationItemView.config.buttonChange.gameObject:SetActive(false)
        else
            arenaTeamFormationItemView.config.buttonChange.gameObject:SetActive(true)
            arenaTeamFormationItemView.callbackClickChange = function()
                self:SwapFormation(self.listFormation2, self.listDefense, i)
            end
        end
        self.listDefense:Add(arenaTeamFormationItemView)
    end
end

--- @return void
--- @param battleTeamInfo BattleTeamInfo
function UIChangeFormationArenaTeamView:UpdateTeam(battleTeamView, battleTeamInfo)
    battleTeamView:Show()
    battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
    battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
    battleTeamView.uiTeamView:ActiveBuff(false)
    battleTeamView.uiTeamView:ActiveLinking(false)
end

function UIChangeFormationArenaTeamView:ReturnPoolBattle()
    if self.listAttack ~= nil then
        ---@param v UIArenaTeamFormationItemView
        for i, v in ipairs(self.listAttack:GetItems()) do
            v:ReturnPool()
        end
        self.listAttack:Clear()
    end
    if self.listDefense ~= nil then
        ---@param v UIArenaTeamFormationItemView
        for i, v in ipairs(self.listDefense:GetItems()) do
            v:ReturnPool()
        end
        self.listDefense:Clear()
    end
end

--- @return void
function UIChangeFormationArenaTeamView:Hide()
    UIBaseView.Hide(self)
    self:ReturnPoolBattle()
end

--- @return void
function UIChangeFormationArenaTeamView:ChangeTeam(team)
    local result = {}
    if team == 1 then
        result.listTeamFormation = self.listFormation1
    else
        result.listTeamFormation = self.listFormation2
    end
    result.callbackClose = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIArenaTeam, nil, UIPopupName.UIFormationArenaTeam)
        PopupMgr.ShowPopup(UIPopupName.UIChangeFormationArenaTeam)
    end
    ---@param listTeamFormation List
    result.callbackPlayBattle = function(listTeamFormation)
        local canSave = true
        ---@param v TeamFormationInBound
        for i, v in ipairs(listTeamFormation:GetItems()) do
            if v:IsContainHeroInFormation() == false then
                canSave = false
            end
        end
        if canSave == true then
            local dict = Dictionary()
            ---@param v TeamFormationInBound
            for i, v in ipairs(listTeamFormation:GetItems()) do
                if v:Equal(zg.playerData:GetFormationInBound():GetArenaTeam(team, i)) == false then
                    dict:Add(1000 * team + i, v)
                end
            end
            require("lua.client.core.network.arena.ArenaRequest")
            ArenaRequest.SetFormationArenaTeam(dict, function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIArenaTeam, nil, UIPopupName.UIFormationArenaTeam)
                PopupMgr.ShowPopup(UIPopupName.UIChangeFormationArenaTeam)
            end)
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("select_hero_all_formation"))
        end
    end
    PopupMgr.HidePopup(UIPopupName.UIChangeFormationArenaTeam)
    PopupMgr.HidePopup(UIPopupName.UIArenaTeamSearch)
    PopupMgr.ShowAndHidePopup(UIPopupName.UIFormationArenaTeam, result, UIPopupName.UIArenaTeam)
end

--- @return void
function UIChangeFormationArenaTeamView:OnClickChangeTeamAttack()
    self:ChangeTeam(1)
end

--- @return void
function UIChangeFormationArenaTeamView:OnClickChangeTeamDefense()
    self:ChangeTeam(2)
end

--- @return void
function UIChangeFormationArenaTeamView:OnClickSaveTeam()
    local dictFormation = self:GetDictFormationChange()
    if dictFormation:Count() > 0 then
        ArenaRequest.SetFormationArenaTeam(dictFormation, function()
            if self.callbackUpdateFormation ~= nil then
                self.callbackUpdateFormation()
            end
            self:OnReadyHide()
            self.callbackUpdateFormation = nil
        end)
    else
        self:OnReadyHide()
        self.callbackUpdateFormation = nil
    end
end

--- @return void
---@param list List
---@param listView List
function UIChangeFormationArenaTeamView:SwapFormation(list, listView, index) -- index thu tu , listview : list attack or def  ,list : list doi hinh con trong attack or def
    local formation = list:Get(index)
    list:SetItemAtIndex(list:Get(index + 1), index)
    list:SetItemAtIndex(formation, index + 1)

    ---@type UIArenaTeamFormationItemView
    local arenaTeamFormationItemView = listView:Get(index)
    arenaTeamFormationItemView:SetData(ClientConfigUtils.GetAttackCurrentBattleTeamInfoByTeamFormationInBound(list:Get(index)), index)
    ---@type UIArenaTeamFormationItemView
    local arenaTeamFormationItemView = listView:Get(index + 1)
    arenaTeamFormationItemView:SetData(ClientConfigUtils.GetAttackCurrentBattleTeamInfoByTeamFormationInBound(list:Get(index + 1)), index + 1)
end

function UIChangeFormationArenaTeamView:CopyFormation(index)
    local listSrc =  nil
    local listDes =  nil
    local listView = nil
    if (index == 1) then
        listSrc = self.listFormation1
        listDes = self.listFormation2
        listView = self.listDefense
    else
        listSrc = self.listFormation2
        listDes = self.listFormation1
        listView = self.listAttack
    end
    listDes:Clear()
    for i = 1, listSrc:Count() do
        ---@type TeamFormationInBound
        local teamFormationInBound = listSrc:Get(i)
        listDes:Add(teamFormationInBound:Clone())
        ---@type UIArenaTeamFormationItemView
        local arenaTeamFormationItemView = listView:Get(i)
        arenaTeamFormationItemView:SetData(ClientConfigUtils.GetAttackCurrentBattleTeamInfoByTeamFormationInBound(listDes:Get(i)), i)
    end
    --self:UpdateFormationView()
end