---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiGuildMain.UIGuildMemberSlotItemConfig"

--- @class UIGuildMemberSlotItemView : MotionIconView
UIGuildMemberSlotItemView = Class(UIGuildMemberSlotItemView, MotionIconView)

function UIGuildMemberSlotItemView:Ctor()
    MotionIconView.Ctor(self)
    ---@type VipIconView
    self.iconVip = nil
    --- @type boolean
    self.isSetLocalize = false
    --- @type UIPopupName
    self.popupName = nil
end

--- @return void
function UIGuildMemberSlotItemView:SetPrefabName()
    self.prefabName = 'guild_member_slot_item'
    self.uiPoolType = UIPoolType.MemberSlotItemView
end

function UIGuildMemberSlotItemView:SetLocalization()
    if self.isSetLocalize == false and self.popupName == UIPopupName.UIChangeGuildLeader then
        self.config.localizeSetLeader.text = LanguageUtils.LocalizeCommon("set_as_leader")
        self.isSetLocalize = true
    end
end

--- @param transform UnityEngine_Transform
function UIGuildMemberSlotItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type UIGuildMemberSlotItemConfig
    ---@type UIGuildMemberSlotItemConfig
    self.config = UIBaseConfig(transform)
end

--- @param memberInfo GuildMemberInBound
--- @param memberRole GuildRole
--- @param serverTime number
function UIGuildMemberSlotItemView:SetData(memberInfo, memberRole, serverTime, onSelect, onSetLeader)
    self.config.textMemberName.text = memberInfo.playerName
    self.config.textMemberRole.text = GuildRole.RoleName(memberRole)

    if serverTime ~= nil then
        local deltaTimeLogin = math.max(1, serverTime - memberInfo.lastLoginTimeInSec)
        self.config.textLastTimeActive.text = TimeUtils.GetDeltaTimeAgo(deltaTimeLogin)
        local secFromStartDay = TimeUtils.GetTimeStartDayFromSec(serverTime)
        self.config.checked.gameObject:SetActive(memberInfo.lastCheckInTimeInSec >= secFromStartDay)
    else
        self.config.checked.gameObject:SetActive(false)
        self.config.textLastTimeActive.text = ""
    end

    self:AddButtonListener(self.config.buttonSetLeader, onSetLeader)

    self.config.buttonSetLeader.gameObject:SetActive(onSetLeader ~= nil)

    self:ShowAvatar(memberInfo.avatarData:GetOtherPlayerAvatar(), memberInfo.playerLevel, onSelect)

    self.config.iconLeader:SetActive(memberRole == GuildRole.LEADER)
    self.config.iconSubLeader:SetActive(memberRole == GuildRole.SUB_LEADER)
end

--- @param button UnityEngine_UI_Button
--- @param listener function
function UIGuildMemberSlotItemView:AddButtonListener(button, listener)
    button.onClick:RemoveAllListeners()
    button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if listener then
            listener()
        end
    end)
end

--- @param func function
function UIGuildMemberSlotItemView:AddApplyListener(func)
    self.config.buttonApply.onClick:RemoveAllListeners()
    self.config.buttonApply.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func ~= nil then
            func()
        end
    end)
end

function UIGuildMemberSlotItemView:ShowAvatar(avatarId, level, onSelect)
    if self.iconVip == nil then
        self.iconVip = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.avatar)
    end
    self.iconVip:SetData2(avatarId, level)
    self.iconVip:AddListener(onSelect)
end

function UIGuildMemberSlotItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.iconVip ~= nil then
        self.iconVip:ReturnPool()
        self.iconVip = nil
    end
end

return UIGuildMemberSlotItemView