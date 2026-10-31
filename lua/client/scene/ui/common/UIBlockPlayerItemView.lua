---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.UIBlockPlayerItemConfig"
require "lua.client.core.network.otherPlayer.OtherPlayerInfoInBound"

--- @class UIBlockPlayerItemView : IconView
UIBlockPlayerItemView = Class(UIBlockPlayerItemView, IconView)

--- @return void
function UIBlockPlayerItemView:Ctor()
    self:Init()
    ---@type VipIconView
    self.avatarView = nil
    IconView.Ctor(self)
end

--- @return void
function UIBlockPlayerItemView:Init()
    ---@type OtherPlayerInfoInBound
    self.data = nil
    self.callbackUnblock = nil
end

--- @return void
function UIBlockPlayerItemView:SetPrefabName()
    self.prefabName = 'block_player_item_view'
    self.uiPoolType = UIPoolType.UIBlockPlayerItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIBlockPlayerItemView:SetConfig(transform)
    assert(transform)
    --- @type UIBlockPlayerItemConfig
    ---@type UIBlockPlayerItemConfig
    self.config = UIBaseConfig(transform)

    self.config.buttonUnblock.onClick:AddListener(function ()
        self:OnClickUnBlock()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
function UIBlockPlayerItemView:SetData(data, callbackUnblock)
    self.data = data
    self.callbackUnblock = callbackUnblock
    self:UpdateUI()
end

--- @return void
function UIBlockPlayerItemView:UpdateUI()
    self.config.textUserName.text = self.data.playerName
    self.config.textEventTimeJoin.text = tostring(self.data.playerId)
    if self.avatarView == nil then
        self.avatarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.iconHero)
    end
    self.avatarView:SetData2(self.data.playerAvatar, self.data.playerLevel)
    self.avatarView:RemoveAllListeners()
end

--- @return void
function UIBlockPlayerItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:Init()
    if self.avatarView ~= nil then
        self.avatarView:ReturnPool()
        self.avatarView = nil
    end
end

--- @return void
function UIBlockPlayerItemView:OnClickUnBlock()
    local yesCallback = function()
        if self.callbackUnblock ~= nil then
            self.callbackUnblock(self.data)
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
    end
    local noCallback = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    end
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_unblock"), noCallback, yesCallback)
end

return UIBlockPlayerItemView