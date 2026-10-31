--- @class UIDomainInvitationItemView : IconView
UIDomainInvitationItemView = Class(UIDomainInvitationItemView, IconView)

--- @return void
function UIDomainInvitationItemView:Ctor()
    ---@type List
    self.listAvatar = List()
    IconView.Ctor(self)
end

--- @return void
function UIDomainInvitationItemView:SetPrefabName()
    self.prefabName = 'domain_invitation_item'
    self.uiPoolType = UIPoolType.UIDomainInvitationItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIDomainInvitationItemView:SetConfig(transform)
    ---@type UIDomainInvitationItemConfig
    self.config = UIBaseConfig(transform)

    self.config.buttonApply.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickApply()
    end)

    self.config.buttonAccept.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickAccept()
    end)
end

--- @return void
function UIDomainInvitationItemView:SetData(data, callbackAccept, callbackApply, callbackFailed, index)
    ---@type CrewInvitation
    self.data = data
    self.callbackAccept = callbackAccept
    self.callbackApply = callbackApply
    self.callbackFailed = callbackFailed
    self.index = index
    self:UpdateUI()
end

--- @return void
function UIDomainInvitationItemView:UpdateUI()
    self.config.textTeamSlot.text = tostring(self.index)
    self.config.textName.text = self.data.crewName
    self.config.textId.text = tostring(self.data.crewId)
    self.config.buttonAccept.gameObject:SetActive(self.callbackAccept ~= nil)
    self.config.buttonApply.gameObject:SetActive(self.callbackApply ~= nil)

    self:ReturnPoolListAvatar()
    ---@param v CrewMemberBasicInfo
    for _, v in ipairs(self.data.listMember:GetItems()) do
        --- @type VipIconView
        local avatarIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.demoHero)
        avatarIconView:SetData2(v.avatar, v.level)
        avatarIconView:SetSize(165, 0)
        avatarIconView:AddListener(function()
            self:OnClickInfo(v)
        end)
        self.listAvatar:Add(avatarIconView)
    end
end

--- @param crewMemberBasicInfo CrewMemberBasicInfo
function UIDomainInvitationItemView:OnClickInfo(crewMemberBasicInfo)
    local callbackRequest = function(result)
        local data = {}
        data.userName = crewMemberBasicInfo.name
        data.avatar = crewMemberBasicInfo.avatar
        data.level = crewMemberBasicInfo.level
        data.playerId = crewMemberBasicInfo.playerId

        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            data.guildId = buffer:GetInt()
            data.guildName = buffer:GetString()
            data.listHero = NetworkUtils.GetListDataInBound(buffer, HeroResource.CreateInstanceByBuffer)
        end
        local onSuccess = function()
            PopupMgr.ShowPopup(UIPopupName.UIPreviewFriend, data)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.CREW_MEMBER_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Int, self.data.crewId, PutMethod.Long, crewMemberBasicInfo.playerId), callbackRequest)
end

--- @return void
function UIDomainInvitationItemView:ReturnPoolListAvatar()
    --- @param v VipIconView
    for _, v in ipairs(self.listAvatar:GetItems()) do
        v:ReturnPool()
    end
    self.listAvatar:Clear()
end

--- @return void
function UIDomainInvitationItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolListAvatar()
end

--- @return void
function UIDomainInvitationItemView:OnClickApply()
    local onSuccess = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("send_success"))
        if self.callbackAccept ~= nil then
            self.callbackAccept(self.data.crewId)
        end
    end
    --- @param logicCode LogicCode
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        if self.callbackFailed then
            self.callbackFailed()
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_APPLICATION_SEND,
            UnknownOutBound.CreateInstance(PutMethod.Int, self.data.crewId),
            onSuccess, onFailed)
end

--- @return void
function UIDomainInvitationItemView:OnClickAccept()
    local onSuccess = function()
        if self.callbackAccept ~= nil then
            self.callbackAccept(self.data.crewId)
        end
    end
    --- @param logicCode LogicCode
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        if self.callbackFailed then
            self.callbackFailed()
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_MEMBER_INVITATION_MANAGE,
            UnknownOutBound.CreateInstance(PutMethod.Int, self.data.crewId, PutMethod.Bool, true),
            onSuccess, onFailed)
end

return UIDomainInvitationItemView