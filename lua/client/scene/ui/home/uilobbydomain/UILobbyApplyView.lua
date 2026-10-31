require "lua.client.scene.ui.common.LobbyTeamItemView"

--- @class UILobbyApplyView
UILobbyApplyView = Class(UILobbyApplyView)

--- @param uiTranform UnityEngine_Transform
function UILobbyApplyView:Ctor(uiTransform)
    --- @type UILobbyApplyConfig
    self.config = UIBaseConfig(uiTransform)
    --- @type boolean
    self.isSearchByName = true
    --- @type GuildData
    self.guildData = nil

    self:_InitButtonListener()
    self:_InitScrollView()

    uiCanvas:SetBackgroundSize(self.config.bg)
end

--- @return void
function UILobbyApplyView:InitLocalization()
    self.config.localizeSearch.text = LanguageUtils.LocalizeCommon("search")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
    self.config.localizeEnterGuildName.text = LanguageUtils.LocalizeCommon("enter_guild_name_id")
    self.config.localizeName.text = LanguageUtils.LocalizeCommon("name")
    self.config.localizeId.text = LanguageUtils.LocalizeCommon("id")
end

function UILobbyApplyView:_InitButtonListener()
    self.config.buttonSearch.onClick:AddListener(function()
        self:OnApplySearch()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonFound.onClick:AddListener(function()
        self:OnClickFound()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonRefresh.onClick:AddListener(function()
        if self.model:IsAvailableTimeRequestRecommend() == true then
            self:OnRequestRecommendedGuild()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("try_again_few_seconds"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
    end)
    self.config.toggleSearch.onClick:AddListener(function()
        self.config.searchOption:SetActive(true)
    end)
    self.config.optName.onClick:AddListener(function()
        self:SetToggleState(true)
    end)
    self.config.optId.onClick:AddListener(function()
        self:SetToggleState(false)
    end)
end

function UILobbyApplyView:_InitScrollView()
    --- @param obj UIApplyGuildSlotItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GuildSearchInfo
        local guildSearchInfo = self.model:GetGuildInfoByIndex(dataIndex)
        if guildSearchInfo ~= nil then
            obj:SetData(guildSearchInfo)
            obj:AddApplyListener(function()
                self:OnRequestJoinGuild(guildSearchInfo.guildId)
            end)
        else
            XDebug.Log("WTF???")
        end
    end
    self.uiScroll = UILoopScroll(self.config.listGuildScroll, UIPoolType.LobbyTeamItemView, onCreateItem)
end

function UILobbyApplyView:OnReadyShow()
    self.guildData = zg.playerData:GetGuildData()
    self.serverNotificationListener = RxMgr.guildMemberAdded:Subscribe(RxMgr.CreateFunction(self, self.OnServerNotification))

    self:SetToggleState(true)
    self:CheckNotify()
    if self.guildData.listGuildRecommendedInfo == nil then
        self:OnRequestRecommendedGuild()
        return
    end
    self:ShowRecommendedGuildList()
end

function UILobbyApplyView:OnClickFound()
    PopupMgr.ShowPopup(UIPopupName.UIGuildFoundation, { ["isSetting"] = false, ["avatar"] = 1 })
end

function UILobbyApplyView:CheckNotify()
    local onSuccess = function()
        local notify = false
        notify =  NotificationCheckUtils.ShopCheckNotification(PlayerDataMethod.GUILD_MARKET)
        self.config.notifyGuildShop:SetActive(notify)
    end
    local modeShopDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_MARKET)
    if modeShopDataInBound == nil then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_MARKET }, onSuccess, SmartPoolUtils.LogicCodeNotification)
    else
        onSuccess()
    end
end

function UILobbyApplyView:OnApplySearch()
    self.config.searchOption:SetActive(false)
    local inputSearch = self.config.searchInput.text
    if inputSearch == "" then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        return
    end

    if self.isSearchByName == false then
        if MathUtils.IsNumber(tonumber(inputSearch)) == false then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("use_id_format"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            return
        end
    end

    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            self.guildData.listGuildSearchInfo = NetworkUtils.GetListDataInBound(buffer, GuildSearchInfo)
            if self.guildData.listGuildSearchInfo:Count() == 0 then
                SmartPoolUtils.LogicCodeNotification(LogicCode.GUILD_NOT_FOUND)
            end
        end
        local onSuccess = function()
            self:ShowSearchGuildList()
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.GUILD_SEARCH, UnknownOutBound.CreateInstance(PutMethod.String, inputSearch, PutMethod.Bool, self.isSearchByName), onReceived)
end

function UILobbyApplyView:OnRequestRecommendedGuild()
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            self.guildData.listGuildRecommendedInfo = NetworkUtils.GetListDataInBound(buffer, GuildSearchInfo)
            self.model.lastTimeRequestRecommendedGuild = zg.timeMgr:GetServerTime()
        end
        local onSuccess = function()
            self:ShowRecommendedGuildList()
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.GUILD_SEARCH_RECOMMENDATION, nil, onReceived)
end

function UILobbyApplyView:ShowRecommendedGuildList()
    self.model.currentListGuildInfo = self.guildData.listGuildRecommendedInfo
    self.uiScroll:Resize(self.model.currentListGuildInfo:Count())
    if self.model.currentListGuildInfo:Count() > 0 then
        self.config.empty:SetActive(false)
    else
        self.config.empty:SetActive(true)
    end
end

function UILobbyApplyView:ShowSearchGuildList()
    self.model.currentListGuildInfo = self.guildData.listGuildSearchInfo
    self.uiScroll:Resize(self.model.currentListGuildInfo:Count())
end

--- @param guildId number
function UILobbyApplyView:OnRequestJoinGuild(guildId)
    GuildRequest.RequestJoin(guildId)
end

function UILobbyApplyView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UILobbyApplyView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UILobbyApplyView:Hide()
    UIBaseView.Hide(self)
    self.config.searchInput.text = ""
    self.serverNotificationListener:Unsubscribe()
    self.uiScroll:Hide()
end

--- @param isSearchByName boolean
function UILobbyApplyView:SetToggleState(isSearchByName)
    self.isSearchByName = isSearchByName
    if isSearchByName == true then
        self.config.toggleLabel.text = LanguageUtils.LocalizeCommon("name")
    else
        self.config.toggleLabel.text = LanguageUtils.LocalizeCommon("id")
    end
    self.config.searchOption:SetActive(false)
end

function UILobbyApplyView:OnServerNotification()
    local guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    if guildBasicInfoInBound ~= nil then
        guildBasicInfoInBound.isHaveGuild = true
        guildBasicInfoInBound.lastTimeRequest = nil
    end
    PopupUtils.BackToMainArea()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("have_just_joined_guild"))
end

function UIGuildApplyView:OnApplySearch()
    self.config.searchOption:SetActive(false)
    local inputSearch = self.config.searchInput.text
    if inputSearch == "" then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        return
    end

    if self.isSearchByName == false then
        if MathUtils.IsNumber(tonumber(inputSearch)) == false then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("use_id_format"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            return
        end
    end

    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            self.guildData.listGuildSearchInfo = NetworkUtils.GetListDataInBound(buffer, GuildSearchInfo)
            if self.guildData.listGuildSearchInfo:Count() == 0 then
                SmartPoolUtils.LogicCodeNotification(LogicCode.GUILD_NOT_FOUND)
            end
        end
        local onSuccess = function()
            self:ShowSearchGuildList()
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.GUILD_SEARCH, UnknownOutBound.CreateInstance(PutMethod.String, inputSearch, PutMethod.Bool, self.isSearchByName), onReceived)
end