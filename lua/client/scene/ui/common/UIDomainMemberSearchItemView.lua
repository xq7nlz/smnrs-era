--- @class UIDomainMemberSearchItemView : IconView
UIDomainMemberSearchItemView = Class(UIDomainMemberSearchItemView, IconView)

--- @return void
function UIDomainMemberSearchItemView:Ctor()
    ---@type VipIconView
    self.avatarView = nil
    IconView.Ctor(self)
end

--- @return void
function UIDomainMemberSearchItemView:SetPrefabName()
    self.prefabName = 'domain_member_search_item'
    self.uiPoolType = UIPoolType.UIDomainMemberSearchItemView
end

function UIDomainMemberSearchItemView:InitLocalization()
    self.config.textSend.text = LanguageUtils.LocalizeCommon("send")
end

--- @return void
--- @param transform UnityEngine_Transform
function UIDomainMemberSearchItemView:SetConfig(transform)
    assert(transform)
    ---@type UIDomainMemberSearchItemConfig
    self.config = UIBaseConfig(transform)

    self.config.buttonSend.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickInvite()
    end)
end

--- @return void
function UIDomainMemberSearchItemView:SetData(data)
    ---@type CrewMemberSearchInfo
    self.data = data
    self:UpdateUI()
end

--- @return void
function UIDomainMemberSearchItemView:UpdateUI()
    self.config.textUserName.text = self.data.playerName
    self.config.textEventTimeJoin.text = UIUtils.SetColorString(UIUtils.color2, TimeUtils.GetDeltaTimeAgo(zg.timeMgr:GetServerTime() - self.data.lastOnlineTime))
    if self.avatarView == nil then
        self.avatarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.iconHero)
    end
    self.avatarView:SetData2(self.data.avatarData:GetOtherPlayerAvatar(), self.data.playerLevel)
    self.avatarView:RemoveAllListeners()

    if self.data.alreadyInvite == true then
        self.config.textSend.text = LanguageUtils.LocalizeCommon("invitation_sent")
        self.config.imageSent.color = U_Color(0.7, 0.7, 0.7, 1)
    else
        self.config.textSend.text = LanguageUtils.LocalizeCommon("send")
        self.config.imageSent.color = U_Color(1, 1, 1, 1)
    end
end

--- @return void
function UIDomainMemberSearchItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.avatarView ~= nil then
        self.avatarView:ReturnPool()
        self.avatarView = nil
    end
end

--- @return void
function UIDomainMemberSearchItemView:OnClickInvite()
    local onSuccess = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("send_success"))
        self.data.alreadyInvite = true
        self:UpdateUI()
    end
    --- @param logicCode LogicCode
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_MEMBER_INVITE,
            UnknownOutBound.CreateInstance(PutMethod.Long, self.data.playerId),
            onSuccess, onFailed)
end

return UIDomainMemberSearchItemView