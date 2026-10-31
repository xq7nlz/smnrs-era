--- @class UIGuildFoundationView : UIBaseView
UIGuildFoundationView = Class(UIGuildFoundationView, UIBaseView)

--- @return void
--- @param model UIGuildFoundationModel
function UIGuildFoundationView:Ctor(model, ctrl)
    --- @type UIGuildFoundationConfig
    self.config = nil
    --- @type GuildBasicInfoInBound
    self.guildBasicInfoInBound = nil
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIGuildFoundationModel
    self.model = model
end

function UIGuildFoundationView:OnReadyCreate()
    ---@type UIGuildFoundationConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitFoundButton()
    self:_InitButtonListener()
end

--- @return void
function UIGuildFoundationView:InitLocalization()
    self.config.textTittle.text = LanguageUtils.LocalizeCommon("guild_foundation")
    self.config.localizeEnterGuildName.text = LanguageUtils.LocalizeCommon("enter_guild_name")
    self.config.localizeEnterGuildInfo.text = LanguageUtils.LocalizeCommon("enter_guild_info")
    self.config.localizeFound.text = LanguageUtils.LocalizeCommon("found")
    self.config.localizeUpdate.text = LanguageUtils.LocalizeCommon("update")
    self.config.localizeCancel.text = LanguageUtils.LocalizeCommon("cancel")
    self.config.localizeChange.text = LanguageUtils.LocalizeCommon("change")
    self.config.localizeChangeLeader.text = LanguageUtils.LocalizeCommon("change_leader")
    self.config.localizeExitGuild.text = LanguageUtils.LocalizeCommon("exit_guild")
end

function UIGuildFoundationView:_InitFoundButton()
    local iconPrice = ResourceLoadUtils.LoadMoneyIcon(self.model.foundMoneyType)
    local foundPrice = ResourceMgr.GetGuildDataConfig().guildConfig.guildCreateGemPrice
    self.config.iconCurrency.sprite = iconPrice
    self.config.textPrice.text = tostring(foundPrice)
end

function UIGuildFoundationView:_InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonFound.onClick:AddListener(function()
        local guildName = self.config.inputName.text
        if guildName == "" then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("please_enter_guild_name"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            return
        end

        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        local yesCallback = function()
            self:OnClickFound()
        end
        local noCallback = function()

        end
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("create_guild"), noCallback, yesCallback)
    end)
    self.config.buttonChangeAvatar.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangeGuildAvatar()
    end)
    self.config.cancelButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnReadyHide()
    end)
    self.config.buttonUpdate.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickUpdateGuildInfo()
    end)
    self.config.buttonChangeLeader.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangeLeader()
    end)
    self.config.buttonExitGuild.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickExitGuild()
    end)
end

--- @param data {isSetting, avatar}
function UIGuildFoundationView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    self:ShowButtonByType(data.isSetting)
    self.model.avatarId = data.avatar
    self.config.iconGuild.sprite = ResourceLoadUtils.LoadGuildIcon(data.avatar)
    self.config.iconGuild:SetNativeSize()
end

--- @param isSetting boolean
function UIGuildFoundationView:ShowButtonByType(isSetting)
    self.config.cancelButton.gameObject:SetActive(not isSetting)
    self.config.buttonFound.gameObject:SetActive(not isSetting)
    self.config.buttonUpdate.gameObject:SetActive(false)
    self.config.buttonChangeLeader.gameObject:SetActive(false)
    self.config.buttonExitGuild.gameObject:SetActive(isSetting)

    if isSetting == true then
        local selfRole = self.guildBasicInfoInBound.guildInfo.selfRole
        self.config.rectInputName.sizeDelta = U_Vector2(407.5, 77)
        self.config.rectInputName.anchoredPosition3D = U_Vector3(-203.75, 4.2)

        self.config.textTittle.text = LanguageUtils.LocalizeCommon("update")
        self.config.inputName.text = self.guildBasicInfoInBound.guildInfo.guildName
        self.config.inputInfo.text = self.guildBasicInfoInBound.guildInfo.guildDescription
        self.config.buttonUpdate.gameObject:SetActive(selfRole == GuildRole.LEADER)
        self.config.buttonChangeLeader.gameObject:SetActive(selfRole == GuildRole.LEADER)
        self.config.buttonChangeAvatar.gameObject:SetActive(selfRole == GuildRole.LEADER)
    else
        self.config.rectInputName.sizeDelta = U_Vector2(729.1036, 77)
        self.config.rectInputName.anchoredPosition3D = U_Vector3(-42.9, 4.2)

        self.config.textTittle.text = LanguageUtils.LocalizeCommon("guild_foundation")
    end
end

function UIGuildFoundationView:OnClickFound()
    local guildName = self.config.inputName.text
    local guildInfo = self.config.inputInfo.text
    if guildName == "" then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("please_enter_guild_name"))
        return
    end

    local foundPrice = ResourceMgr.GetGuildDataConfig().guildConfig.guildCreateGemPrice
    local priceInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, foundPrice)
    if InventoryUtils.IsEnoughSingleResourceRequirement(priceInBound) == false then
        return
    end

    local onReceived = function(result)
        local onSuccess = function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("create_guild_success"))
            InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM,
                    ResourceMgr.GetGuildDataConfig().guildConfig.guildCreateGemPrice)
            self:OnSuccessCreateGuild()
        end

        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            if logicCode == LogicCode.GUILD_PLAYER_IN_BLOCK_DURATION then
                local guildConfig = ResourceMgr.GetGuildDataConfig().guildConfig
                local message = LanguageUtils.LocalizeLogicCode(logicCode)
                --- @type GuildBasicInfoInBound
                local guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
                local timeInSec = (guildBasicInfoInBound.lastLeaveGuildInSec + guildConfig.leaveGuildBlockDuration) - zg.timeMgr:GetServerTime()
                local timeInMin = math.floor(timeInSec / TimeUtils.SecondAMin)
                SmartPoolUtils.ShowShortNotification(string.format(message, timeInMin))
            else
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.GUILD_CREATE,
            UnknownOutBound.CreateInstance(PutMethod.String, guildName, PutMethod.Int, self.model.avatarId, PutMethod.String, guildInfo), onReceived)
end

function UIGuildFoundationView:OnClickChangeGuildAvatar()
    --- @type {defaultGuildLogo : number, onSelectGuildLogo}
    local data = {}
    data.defaultGuildLogo = self.model.avatarId
    if self.guildBasicInfoInBound.isHaveGuild == true then
        data.defaultGuildLogo = self.guildBasicInfoInBound.guildInfo.guildAvatar
    end
    --- @param logoId number
    data.onSelectGuildLogo = function(logoId)
        if logoId ~= self.model.avatarId then
            self.model.avatarId = logoId
            self.config.iconGuild.sprite = ResourceLoadUtils.LoadGuildIcon(self.model.avatarId)
            self.config.iconGuild:SetNativeSize()
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UISelectGuildLogo, data)
end

function UIGuildFoundationView:OnSuccessCreateGuild()
    local onSuccessLoadBasicInfo = function()
        if self.guildBasicInfoInBound.isHaveGuild == false then
            PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildMain, nil, UIPopupName.UIMainArea)
        else
            PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildMain, nil, UIPopupName.UIGuildFoundation)
            PopupMgr.HidePopup(UIPopupName.UIGuildApply)
        end
    end

    local onFailedLoadBasicInfo = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildMain, nil, UIPopupName.UIMainArea)
    end
    PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_BASIC_INFO }, onSuccessLoadBasicInfo, onFailedLoadBasicInfo)
end

function UIGuildFoundationView:OnClickUpdateGuildInfo()
    local newGuildName = self.config.inputName.text
    local newGuildDesc = self.config.inputInfo.text
    local newGuildAvatar = self.model.avatarId

    if newGuildName == self.guildBasicInfoInBound.guildInfo.guildName
            and newGuildDesc == self.guildBasicInfoInBound.guildInfo.guildDescription
            and newGuildAvatar == self.guildBasicInfoInBound.guildInfo.guildAvatar then
        self:OnReadyHide()
        return
    end

    local onReceived = function(result)
        local onSuccess = function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("upgrade_guild_success"))
            self:OnReadyHide()
            self.guildBasicInfoInBound.guildInfo.guildName = newGuildName
            self.guildBasicInfoInBound.guildInfo.guildDescription = newGuildDesc
            self.guildBasicInfoInBound.guildInfo.guildAvatar = newGuildAvatar
            --- @type GuildWarInBound
            local guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)
            if guildWarInBound ~= nil then
                guildWarInBound.guildName = newGuildName
                guildWarInBound.guildAvatar = newGuildAvatar
            end
            RxMgr.updateGuildInfo:Next()
        end

        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            self:OnReadyHide()
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.GUILD_INFO_CHANGE, UnknownOutBound.CreateInstance(PutMethod.String, newGuildName,
            PutMethod.Int, newGuildAvatar,
            PutMethod.String, newGuildDesc), onReceived)
end

function UIGuildFoundationView:Hide()
    UIBaseView.Hide(self)
    self.config.inputName.text = ""
    self.config.inputInfo.text = ""
end

function UIGuildFoundationView:OnClickChangeLeader()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIChangeGuildLeader, nil, self.model.uiName)
end

function UIGuildFoundationView:OnClickExitGuild()
    --- @type GuildBasicInfoInBound
    local guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    --- @type GuildInfoInBound
    local guildInfoInBound = guildBasicInfoInBound.guildInfo
    if guildInfoInBound.selfRole == GuildRole.LEADER and guildInfoInBound.listGuildMember:Count() > 1 then
        PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("master_can_not_quit_guild"))
        return
    end
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("sure_leave_guild"), nil, function()
        local onReceived = function(result)
            local onSuccess = function()
                self:OnLeftGuild()
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("have_left_guild"))
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
        end
        NetworkUtils.Request(OpCode.GUILD_LEAVE, nil, onReceived)
    end)
end

function UIGuildFoundationView:OnLeftGuild()
    --- @type GuildWarInBound
    local guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)
    if guildWarInBound ~= nil then
        guildWarInBound:OnLeftGuild()
    end
    GuildBasicInfoInBound.Validate(nil, true)
    PopupUtils.BackToMainArea()
end