require "lua.client.scene.ui.home.uiGuildApply.UIApplyGuildSlotItemView"

--- @class UIGuildApplyView : UIBaseView
UIGuildApplyView = Class(UIGuildApplyView, UIBaseView)

--- @param model UIGuildApplyModel
function UIGuildApplyView:Ctor(model)
    --- @type UIGuildApplyConfig
    self.config = nil
    --- @type boolean
    self.isSearchByName = true
    --- @type GuildData
    self.guildData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildApplyModel
    self.model = model
end

function UIGuildApplyView:OnReadyCreate()
    ---@type UIGuildApplyConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitIconGuild()
    self:_InitFoundButton()
    self:_InitButtonListener()
    self:_InitScrollView()

    uiCanvas:SetBackgroundSize(self.config.bg)
end

--- @return void
function UIGuildApplyView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeFeature(FeatureType.GUILD)
    self.config.localizeSearch.text = LanguageUtils.LocalizeCommon("search")
    self.config.localizeFound.text = LanguageUtils.LocalizeCommon("found")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
    self.config.localizeEnterGuildName.text = LanguageUtils.LocalizeCommon("enter_guild_name_id")
    self.config.localizeGuildContent.text = LanguageUtils.LocalizeCommon("guild_content")
    self.config.localizeName.text = LanguageUtils.LocalizeCommon("name")
    self.config.localizeId.text = LanguageUtils.LocalizeCommon("id")
end

function UIGuildApplyView:_InitIconGuild()
    self.config.iconGuild.sprite = ResourceLoadUtils.LoadGuildIcon("logo_non_guild")
end

function UIGuildApplyView:_InitFoundButton()
    local iconPrice = ResourceLoadUtils.LoadMoneyIcon(self.model.foundMoneyType)
    local foundPrice = ResourceMgr.GetGuildDataConfig().guildConfig.guildCreateGemPrice
    self.config.iconCurrency.sprite = iconPrice
    self.config.textPrice.text = tostring(foundPrice)
end

function UIGuildApplyView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonGuildShop.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickShop()
    end)
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

function UIGuildApplyView:_InitScrollView()
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
    self.uiScroll = UILoopScroll(self.config.listGuildScroll, UIPoolType.ApplyGuildSlotItemView, onCreateItem)
end

function UIGuildApplyView:OnReadyShow()
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

function UIGuildApplyView:OnClickFound()
    PopupMgr.ShowPopup(UIPopupName.UIGuildFoundation, { ["isSetting"] = false, ["avatar"] = 1 })
end

function UIGuildApplyView:CheckNotify()
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
--- @return void
function UIGuildApplyView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("guild_info"))
end

--- @return void
function UIGuildApplyView:OnClickShop()
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.BLACK_MARKET) then
        PopupMgr.ShowAndHidePopup(UIPopupName.UIMarket, {
            ["marketType"] = MarketType.GUILD_MARKET,
            ["callbackClose"] = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildApply, nil, UIPopupName.UIMarket)
        end },
                UIPopupName.UIGuildApply)
    end
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

function UIGuildApplyView:OnRequestRecommendedGuild()
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

function UIGuildApplyView:ShowRecommendedGuildList()
    self.model.currentListGuildInfo = self.guildData.listGuildRecommendedInfo
    self.uiScroll:Resize(self.model.currentListGuildInfo:Count())
    if self.model.currentListGuildInfo:Count() > 0 then
        self.config.empty:SetActive(false)
    else
        self.config.empty:SetActive(true)
    end
end

function UIGuildApplyView:ShowSearchGuildList()
    self.model.currentListGuildInfo = self.guildData.listGuildSearchInfo
    self.uiScroll:Resize(self.model.currentListGuildInfo:Count())
    self.config.empty:SetActive(self.model.currentListGuildInfo:Count() == 0)
end

--- @param guildId number
function UIGuildApplyView:OnRequestJoinGuild(guildId)
    GuildRequest.RequestJoin(guildId)
end

function UIGuildApplyView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIGuildApplyView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIGuildApplyView:Hide()
    UIBaseView.Hide(self)
    self.config.searchInput.text = ""
    self.serverNotificationListener:Unsubscribe()
    self.uiScroll:Hide()
end

--- @param isSearchByName boolean
function UIGuildApplyView:SetToggleState(isSearchByName)
    self.isSearchByName = isSearchByName
    if isSearchByName == true then
        self.config.toggleLabel.text = LanguageUtils.LocalizeCommon("name")
    else
        self.config.toggleLabel.text = LanguageUtils.LocalizeCommon("id")
    end
    self.config.searchOption:SetActive(false)
end

function UIGuildApplyView:OnServerNotification()
    local guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    if guildBasicInfoInBound ~= nil then
        guildBasicInfoInBound.isHaveGuild = true
        guildBasicInfoInBound.lastTimeRequest = nil
    end
    PopupUtils.BackToMainArea()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("have_just_joined_guild"))
end