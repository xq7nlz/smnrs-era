---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiGuildApplication.UIGuildApplicationItemConfig"

--- @class UIGuildApplicationItem : IconView
UIGuildApplicationItem = Class(UIGuildApplicationItem, IconView)

--- @param transform UnityEngine_Transform
function UIGuildApplicationItem:Ctor(transform)
    IconView.Ctor(self)
    --- @type VipIconView
    self.vipIconView = nil
end

--- @return void
function UIGuildApplicationItem:SetPrefabName()
    self.prefabName = 'guild_application_item'
    self.uiPoolType = UIPoolType.GuildApplicationItem
end

--- @return void
function UIGuildApplicationItem:InitLocalization()
    self.config.localizeAccept.text = LanguageUtils.LocalizeCommon("accept")
    self.config.localizeDecline.text = LanguageUtils.LocalizeCommon("decline")
end

--- @param transform UnityEngine_Transform
function UIGuildApplicationItem:SetConfig(transform)
    --- @type UIGuildApplicationItemConfig
    ---@type UIGuildApplicationItemConfig
    self.config = UIBaseConfig(transform)
end

--- @param guildApplicationItemInBound GuildApplicationItemInBound
function UIGuildApplicationItem:SetData(guildApplicationItemInBound)
    if self.vipIconView == nil then
        self.vipIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.avatarAnchor)
    end
    self.vipIconView:SetData2(guildApplicationItemInBound.playerAvatar, guildApplicationItemInBound.playerLevel)

    self.config.textPlayerName.text = guildApplicationItemInBound.playerName
    self.config.textPlayerLevel.text = LanguageUtils.LocalizeCommon("level") .. " " .. guildApplicationItemInBound.playerLevel
end

--- @param func function
function UIGuildApplicationItem:AddAcceptListener(func)
    self.config.buttonAccept.onClick:RemoveAllListeners()
    self.config.buttonAccept.onClick:AddListener(function ()
        if func ~= nil then
            func()
        end
    end)
end

--- @param func function
function UIGuildApplicationItem:AddDeclineListener(func)
    self.config.buttonDecline.onClick:RemoveAllListeners()
    self.config.buttonDecline.onClick:AddListener(function ()
        if func ~= nil then
            func()
        end
    end)
end

function UIGuildApplicationItem:ReturnPool()
    IconView.ReturnPool(self)
    if self.vipIconView ~= nil then
        self.vipIconView:ReturnPool()
        self.vipIconView = nil
    end
end

return UIGuildApplicationItem