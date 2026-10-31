
--- @class UIGuildMembersItemView : UIBaseView
UIGuildMembersItemView = Class(UIGuildMembersItemView, IconView)
--hoangpl guild change leader
--- @return void
function UIGuildMembersItemView:Ctor()
	--- @type DomainCrewInBound
	self.domainCrewInBound = nil

	---@type  DomainsCrewMember
	self.domainCrewMember = nil

	---@type VipIconView
	self.avatarView = nil
	--self.config = nil
	IconView.Ctor(self)
end

--- @return void
--- @param transform UnityEngine_Transform
function UIGuildMembersItemView:SetConfig(transform)
	assert(transform)
	---@type UIGuildMembersItemConfig
	self.config = UIBaseConfig(transform)
	self.config.buttonSend.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickChangeLeader()
	end)
end

function UIGuildMembersItemView:SetData(data)

	---@type CrewMemberSearchInfo
	self.domainCrewMember = data.domainsCrewMember
	self.data = data
	self:UpdateUI()
end

--- @return void
function UIGuildMembersItemView:UpdateUI()

	self.config.textUserName.text = self.domainCrewMember.playerName
	--self.config.textEventTimeJoin.text = UIUtils.SetColorString(UIUtils.color2, TimeUtils.GetDeltaTimeAgo(zg.timeMgr:GetServerTime() - self.data.lastOnlineTime))
	if self.avatarView == nil then
		self.avatarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.iconHero)
	end
	self.avatarView:SetData2(self.domainCrewMember.avatarData:GetOtherPlayerAvatar(), self.domainCrewMember.playerLevel)
	--self.config.textEventTimeJoin.text = UIUtils.SetColorString(UIUtils.color2, TimeUtils.GetDeltaTimeAgo(zg.timeMgr:GetServerTime() - self.data.lastOnlineTime))
	self.avatarView:RemoveAllListeners()
	self.config.textEventTimeJoin.text = TimeUtils.GetDeltaTimeAgo(zg.timeMgr:GetServerTime() - self.domainCrewMember.lastOnlineTime)
end
function UIGuildMembersItemView:ReturnPool()
	IconView.ReturnPool(self)
	if self.avatarView ~= nil then
		self.avatarView:ReturnPool()
		self.avatarView = nil
	end
end
function UIGuildMembersItemView:SetPrefabName()
	self.prefabName = 'guild_members_item'
	self.uiPoolType = UIPoolType.UIMembersItemView
end

function UIGuildMembersItemView:OnClickChangeLeader()
		PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_change_leader"), nil, function()
			--- @param buffer UnifiedNetwork_ByteBuf
			local onBufferReading = function(buffer)

			end
			local callbackSuccess = function()
				local domainInBound = zg.playerData:GetDomainInBound()
				self.domainCrewInBound = domainInBound.domainCrewInBound
				self.domainCrewInBound:ChangeLeader(self.domainCrewMember.playerId)
				-- update gui here
				self.data.callbackCloseThis()
				--SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("domain_leader_updated"))
			end
			local callbackFailed = function(logicCode)
				SmartPoolUtils.LogicCodeNotification(logicCode)
			end
			NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_LEADER_CHANGE, UnknownOutBound.CreateInstance(PutMethod.Long, self.domainCrewMember.playerId), callbackSuccess, callbackFailed, onBufferReading)
		end)
end


function UIGuildMembersItemView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtons()
end

function UIGuildMembersItemView:InitButtons()

end

function UIGuildMembersItemView:InitLocalization()
	self.config.textSend.text = LanguageUtils.LocalizeCommon("crew_promote")

end

--[[--- @param data {callbackClose : function}
function UIGuildMembersItemView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
end]]
return UIGuildMembersItemView