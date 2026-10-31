--- @class UIChangeAvatarView : UIBaseView
UIChangeAvatarView = Class(UIChangeAvatarView, UIBaseView)

--- @return void
--- @param model UIChangeAvatarModel
function UIChangeAvatarView:Ctor(model)
    ---@return UIChangeAvatarConfig
    self.config = nil

    ---@type number
    self.avatarCurIndex = 0
    self.borderCurIndex = 0
    ---@type number
    self.avatarExpiredTime = nil
    self.borderExpiredTime = nil
    ---@type VipIconView
    self.iconVip = nil
    ---@type UISelect
    self.tab = nil
    --- @type table
    self.funSelectTab = { self.ShowAvatar, self.ShowBorder }

    ---@type number
    self.curTabIndex = 1

    ---@type UILoopScroll
    self.uiScrollAvatar = nil
    ---@type UILoopScroll
    self.uiScrollBorder = nil
    ---@type List
    self.listAvatar = List()
    ---@type List
    self.listBorder = nil
    ---@type BasicInfoInBound
    self.basicInfoInBound = nil

    ---@type number
    self.currentAvatarId = nil
    ---@type number
    self.currentBorderId = nil

    UIBaseView.Ctor(self, model)
    --- @type UIChangeAvatarModel
    self.model = model
end

--- @return void
function UIChangeAvatarView:OnReadyCreate()
    ---@type UIChangeAvatarConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.backGround.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.saveButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSave()
    end)

    -- Tab
    --- @param obj UIHeroCollectionTabConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        if obj ~= nil then
            obj.button.interactable = not isSelect
            obj.bgOn.gameObject:SetActive(isSelect)
        end
    end

    local onChangeSelect = function(indexTab)
        if indexTab ~= nil then
            self.funSelectTab[indexTab](self)
            self.curTabIndex = indexTab
        end
        self:OnChangeTab()
    end
    self.tab = UISelect(self.config.tab, UIBaseConfig, onSelect, onChangeSelect)
    -- ClientConfigUtils.GetDefaultAvatarExpiredTime()
end

function UIChangeAvatarView:OnChangeTab()
    self:SetDisplayTime()
end

--- @return void
function UIChangeAvatarView:InitLocalization()
    local avatar = LanguageUtils.LocalizeCommon("avatar")
    self.config.localizeAvatar.text = avatar
    self.config.localizeAvatarOff.text = avatar
    local border = LanguageUtils.LocalizeCommon("border")
    self.config.localizeBorder.text = border
    self.config.localizeBorderOff.text = border
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("avatar")
    self.config.textBorder.text = LanguageUtils.LocalizeCommon("border")
    self.config.localizeCurrentAvatar.text = LanguageUtils.LocalizeCommon("current_avatar")
end

--- @return void
function UIChangeAvatarView:SetExpiredTime()
    self.avatarExpiredTime = ClientConfigUtils.GetAvatarExpiredTime(self.currentAvatarId)

end
function UIChangeAvatarView:SetBorderExpiredTime()
    self.borderExpiredTime = ClientConfigUtils.GetFrameExpiredTime(self.currentBorderId)

end
--- @return void
function UIChangeAvatarView:OnReadyShow()
    ---@type ClientResourceAvatar
    local clientResourceAvatar = InventoryUtils.Get(ResourceType.Avatar)
    self.listAvatar:Clear()

    for id, expiredTime in pairs(clientResourceAvatar._avatarResourceDict:GetItems()) do
        if ClientConfigUtils.AvatarFrameIsExpired(expiredTime) == false then
            self.listAvatar:Add(id)
        end
    end

    self.listBorder = List()
    ---@type ClientResourceFrame
    local clientResourceFrame = InventoryUtils.Get(ResourceType.AvatarFrame)
    for id, expiredTime in pairs(clientResourceFrame._avatarResourceDict:GetItems()) do
        if ClientConfigUtils.AvatarFrameIsExpired(expiredTime) == false then
            self.listBorder:Add(id)
        end
    end

    ---@type BasicInfoInBound
    self.basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    self.currentAvatarId = self.basicInfoInBound.avatarData:GetAvatar()
    self:OnUpdateAvatar()

    self.currentBorderId = self.basicInfoInBound.avatarData:GetFrame()
    self:OnUpdateBorder()
    self:ShowIcon()
    self.tab:Select(1)

    if self.tapToClose == nil then
        ---@type UITapToCloseView
        self.tapToClose = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UITapToCloseView, self.config.textTapToClose)
    end
end

--- @return void
function UIChangeAvatarView:ShowIcon()
    if self.iconVip == nil then
        self.iconVip = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.iconUser)
    end
    self.iconVip:SetData(self.currentAvatarId, self.basicInfoInBound.level, self.currentBorderId)

    if self.currentAvatarId ~= self.basicInfoInBound.avatarData:GetAvatar() or self.currentBorderId ~= self.basicInfoInBound.avatarData:GetFrame() then
        self.config.saveButton.gameObject:SetActive(true)
    else
        self.config.saveButton.gameObject:SetActive(false)
    end
end

--- @return void
function UIChangeAvatarView:OnClickSave()
    local onReceived = function(result)
        local onSuccess = function()
            -- self.basicInfoInBound.avatar = ClientConfigUtils.GetAvatar(self.currentAvatarId, self.currentBorderId)
            self.basicInfoInBound.avatarData:UpdateByAvatarAndBorderID(self.currentAvatarId, self.currentBorderId)

            -- self.basicInfoInBound.avatarId = self.currentAvatarId
            --self.basicInfoInBound.borderId = self.currentBorderId
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("change_success"))
            RxMgr.changeAvatar:Next()
            zg.playerData:UpdatePlayerInfoOnOthersUI("avatar", self.basicInfoInBound.avatarData.playerAvatar)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
        self:ShowIcon()
    end
    NetworkUtils.Request(OpCode.PLAYER_AVATAR_CHANGE,
            UnknownOutBound.CreateInstance(PutMethod.Int, ClientConfigUtils.GetAvatar(self.currentAvatarId, self.currentBorderId)), onReceived)
end

--- @return void
function UIChangeAvatarView:ShowAvatar()
    self.config.textTitle.gameObject:SetActive(true)
    self.config.textBorder.gameObject:SetActive(false)
    self.config.localizeSelectAvatar.text = LanguageUtils.LocalizeCommon("select_avatar")
    self.config.scroll.gameObject:SetActive(true)
    self.config.scroll2.gameObject:SetActive(false)
    if self.uiScrollAvatar == nil then
        --- @param obj AvatarIconView
        --- @param index number
        local onUpdateItem = function(obj, index)
            local id = self.listAvatar:Get(index + 1)
            obj:SetIconData(ItemIconData.CreateInstance(ResourceType.Avatar, id, 0), self.currentAvatarId == id)
        end
        --- @param obj AvatarIconView
        --- @param index number
        local onCreateItem = function(obj, index)
            onUpdateItem(obj, index)
            obj:AddListener(function()
                self:SelectAvatar(index + 1)
            end)
        end
        self.uiScrollAvatar = UILoopScroll(self.config.scroll, UIPoolType.AvatarIconView, onCreateItem, onUpdateItem)
    end
    self.uiScrollAvatar:Resize(self.listAvatar:Count())
end

--- @return void
function UIChangeAvatarView:ShowBorder()
    self.config.textTitle.gameObject:SetActive(false)
    self.config.textBorder.gameObject:SetActive(true)
    self.config.localizeSelectBorder.text = LanguageUtils.LocalizeCommon("select_border")
    self.config.scroll.gameObject:SetActive(false)
    self.config.scroll2.gameObject:SetActive(true)
    if self.uiScrollBorder == nil then
        --- @param obj BorderIconView
        --- @param index number
        local onUpdateItem = function(obj, index)
            obj:SetIconData(ItemIconData.CreateInstance(ResourceType.AvatarFrame, self.listBorder:Get(index + 1), 0))
        end
        --- @param obj BorderIconView
        --- @param index number
        local onCreateItem = function(obj, index)
            onUpdateItem(obj, index)
            obj:AddListener(function()
                self:SelectBorder(index + 1)
            end)
        end
        self.uiScrollBorder = UILoopScroll(self.config.scroll2, UIPoolType.BorderIconView, onCreateItem, onUpdateItem)
    end
    self.uiScrollBorder:Resize(self.listBorder:Count())
end

--- @return void
function UIChangeAvatarView:ChangeToDefaultBorder()
    self.currentAvatarId = ClientConfigUtils.GetDefaultFrame()
    self:OnUpdateBorder()
end
--- @return void
function UIChangeAvatarView:ChangeToDefaultAvatar()
    self.currentAvatarId = ClientConfigUtils.GetDefaultAvatar()
    self:OnUpdateAvatar()
end

--- @return void

--- @return void
---@param index number
function UIChangeAvatarView:SelectAvatar(index)
    self.avatarCurIndex = index
    self.currentAvatarId = self.listAvatar:Get(index)
    local avatarExpired = ClientConfigUtils.AvatarIsExpired(self.currentAvatarId)
    if (avatarExpired) then
        self.listAvatar:RemoveByReference(self.currentAvatarId)
        self.uiScrollAvatar:Resize(self.listAvatar:Count())
        local defaultAvatarId = ClientConfigUtils.GetDefaultAvatar()
        for i = 1, self.listAvatar:Count() do
            if (self.listAvatar[i] == defaultAvatarId) then
                self:SelectAvatar(i)
                return
            end
        end
    end
    self:ShowIcon()
    self.uiScrollAvatar:RefreshCells()
    self:OnUpdateAvatar()
end

--- @return void
function UIChangeAvatarView:OnUpdateBorder()
    self:SetBorderExpiredTime()
    self:SetDisplayTime()
end

--- @return number
function UIChangeAvatarView:GetExpiredTime()

    if (self.curTabIndex == 2) then
        return self.borderExpiredTime
    end
    return self.avatarExpiredTime
end

--- @return void
function UIChangeAvatarView:SetDisplayTime()
    local expiredTime = self:GetExpiredTime()
    if (expiredTime > 0) then
        self:StopTime()
        self:InitUpdateTime()
        self:StartTime()
    else
        self:StopTime()
    end
end

function UIChangeAvatarView:OnUpdateAvatar()
    self:SetExpiredTime()
    self:SetDisplayTime()
end

--- @return void
function UIChangeAvatarView:StartTime()
    --hoangpl avatar limited time
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

--- @return void
function UIChangeAvatarView:StopTime()
    self.config.localizeAvatarLimitedTime.gameObject:SetActive(false)
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

--- @return void
function UIChangeAvatarView:InitUpdateTime()
    --hoangpl avatar limited time
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        self.config.localizeAvatarLimitedTime.gameObject:SetActive(true)
        local timeExpired = self.avatarExpiredTime
        if (self.curTabIndex == 2) then
            timeExpired = self.borderExpiredTime
        end
        if isSetTime == true then

            self.timeFinish = timeExpired - zg.timeMgr:GetServerTime()

        else
            self.timeFinish = self.timeFinish - 1

        end
        if self.timeFinish > 0 then
            self.config.localizeAvatarLimitedTime.text = string.format(LanguageUtils.LocalizeCommon("expire_in_s"),
                    UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeFinish, 4)))
        else
            if (self.timeFinish > -1000) then
                self.timeFinish = -1000
                self.config.localizeAvatarLimitedTime.text = ""
                self:StopTime()
                self:UpdateWhenAvatarOrFrameExpired()
            end
        end
    end
end

function UIChangeAvatarView:UpdateWhenAvatarOrFrameExpired()
    local id

    if (self.curTabIndex == 2) then
        id = self.currentBorderId
        for i = 1, self.listBorder:Count() do
            if (self.listBorder:Get(i) == id) then
                self:SelectBorder(i)
                return
            end
        end
        else
        id = self.currentAvatarId
        for i = 1, self.listAvatar:Count() do
            if (self.listAvatar:Get(i) == id) then
                self:SelectAvatar(i)
                return
            end
        end
    end
end

--- @return void
---@param index number
function UIChangeAvatarView:SelectBorder(index)
    self.borderCurIndex = index
    self.currentBorderId = self.listBorder:Get(index)
    --- @type boolean
    local borderExpired = ClientConfigUtils.FrameIsExpired(self.currentBorderId)
    if (borderExpired) then
        self.listBorder:RemoveByIndex(index)
        self.uiScrollBorder:Resize(self.listBorder:Count())
        local defaultBorderId = ClientConfigUtils.GetDefaultFrame()
        for i = 1, self.listBorder:Count() do
            if (self.listBorder[i] == defaultBorderId) then
                self:SelectBorder(i)
                return
            end
        end
    end
    self:ShowIcon()
    self.uiScrollBorder:RefreshCells()
    self:OnUpdateBorder()
end

--- @return void
function UIChangeAvatarView:Hide()
    self:StopTime()
    UIBaseView.Hide(self)
    if self.uiScrollAvatar ~= nil then
        self.uiScrollAvatar:Hide()
    end
    if self.uiScrollBorder ~= nil then
        self.uiScrollBorder:Hide()
    end
    if self.tapToClose ~= nil then
        self.tapToClose:ReturnPool()
        self.tapToClose = nil
    end
end