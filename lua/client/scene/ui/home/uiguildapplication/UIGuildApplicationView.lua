---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiGuildApplication.UIGuildApplicationConfig"

--- @class UIGuildApplicationView : UIBaseView
UIGuildApplicationView = Class(UIGuildApplicationView, UIBaseView)

--- @return void
--- @param model UIGuildApplicationModel
function UIGuildApplicationView:Ctor(model)
    --- @type UIGuildApplicationConfig
    self.config = nil
    --- @type UnityEngine_UI_LoopVerticalScrollRect
    self.scrollRequest = nil
    ---@type string
    self.localizeRequestX = ""
    --- @type boolean
    self.needUpdateGuildMain = false
    --- @type GuildApplicationInBound
    self.guildApplicationInBound = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildApplicationModel
    self.model = model
end

--- @return void
function UIGuildApplicationView:OnReadyCreate()
    ---@type UIGuildApplicationConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()
    self:_InitScroll()
end

--- @return void
function UIGuildApplicationView:InitLocalization()
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("guild_application")
    self.localizeRequestX = LanguageUtils.LocalizeCommon("request_x")
end

function UIGuildApplicationView:_InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIGuildApplicationView:_InitScroll()
    --- @param obj UIGuildApplicationItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GuildApplicationItemInBound
        local itemInBound = self.guildApplicationInBound:GetApplicationItemByIndex(dataIndex)
        if itemInBound ~= nil then
            obj:SetData(itemInBound)
            obj:AddAcceptListener(function()
                self:OnCallbackApplication(true, itemInBound)
            end)
            obj:AddDeclineListener(function()
                self:OnCallbackApplication(false, itemInBound)
            end)
        end
    end
    self.scrollRequest = UILoopScroll(self.config.requestScroll, UIPoolType.GuildApplicationItem, onCreateItem)
end

function UIGuildApplicationView:OnReadyShow()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.needUpdateGuildMain = false
    self.guildApplicationInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_APPLICATION)
    if self.guildApplicationInBound == nil or self.guildApplicationInBound:IsAvailableToRequest() == true then
        self:OnRefreshApplicationList()
    else
        self:RefreshScroll()
    end
end

function UIGuildApplicationView:OnRefreshApplicationList()
    local onSuccess = function()
        self.guildApplicationInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_APPLICATION)
        self:RefreshScroll()
    end
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        self.scrollRequest:Hide()
    end
    PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_APPLICATION }, onSuccess, onFailed)
end

--- @param isAccept boolean
--- @param itemInBound GuildApplicationItemInBound
function UIGuildApplicationView:OnCallbackApplication(isAccept, itemInBound)
    local removeItemAndRefresh = function()
        self.guildApplicationInBound:RemoveItemInBound(itemInBound)
        self:RefreshScroll()
    end

    local onReceive = function(result)
        local onSuccess = function()
            removeItemAndRefresh()
            if isAccept == true then
                self.needUpdateGuildMain = true
            end
        end
        --- @param logicCode
        local onFailed = function(logicCode)
            if logicCode ~= LogicCode.GUILD_MEMBER_FULL then
                removeItemAndRefresh()
            end
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.GUILD_APPLICATION_MANAGE, UnknownOutBound.CreateInstance(PutMethod.Long, itemInBound.playerId, PutMethod.Bool, isAccept), onReceive)
end

function UIGuildApplicationView:RefreshScroll()
    self.config.textRequestCount.text = string.format(self.localizeRequestX, self.guildApplicationInBound.listApplicationItem:Count())
    self.scrollRequest:Resize(self.guildApplicationInBound.listApplicationItem:Count())
    if self.guildApplicationInBound.listApplicationItem:Count() > 0 then
        self.config.empty:SetActive(false)
    else
        self.config.empty:SetActive(true)
    end
end

function UIGuildApplicationView:Hide()
    UIBaseView.Hide(self)
    self.scrollRequest:Hide()
    if self.needUpdateGuildMain == true then
        RxMgr.updateGuildInfo:Next({ ['fixedActiveGuildLogNotify'] = true })
    end
end



