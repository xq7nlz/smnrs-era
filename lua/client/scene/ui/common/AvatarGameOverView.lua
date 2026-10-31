---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.AvatarGameOverConfig"

--- @class AvatarGameOverView : IconView
AvatarGameOverView = Class(AvatarGameOverView, IconView)

--- @return void
function AvatarGameOverView:Ctor()
    ---@type ArenaOpponentInfo
    IconView.Ctor(self)
    ---@type VipIconView
    self.avatarIconView = nil
end

--- @return void
function AvatarGameOverView:SetPrefabName()
    self.prefabName = 'avatar_pvp_game_over'
    self.uiPoolType = UIPoolType.AvatarGameOverView
end

--- @return void
--- @param transform UnityEngine_Transform
function AvatarGameOverView:SetConfig(transform)
    assert(transform)
    ---@type AvatarGameOverConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
---@param avatar number
---@param level number
---@param name string
---@param score number
---@param scoreChange number
function AvatarGameOverView:SetData(avatar, level, name, score, scoreChange)
    if self.avatarIconView == nil then
        self.avatarIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.icon)
    end
    self.avatarIconView:SetData2(avatar, level)
    self.config.name.text = name
    local color
    if scoreChange ~= nil then
        if scoreChange > 0 then
            color = UIUtils.green_light
        else
            color = UIUtils.color7
        end
    end
    if score ~= nil and scoreChange ~= nil then
        if scoreChange > 0 then
            self.config.score.text = string.format("%s<color=#%s>(+%s)</color>", score, color, scoreChange)
        else
            self.config.score.text = string.format("%s<color=#%s>(%s)</color>", score, color, scoreChange)
        end
    elseif score == nil and scoreChange ~= nil then
        if scoreChange > 0 then
            self.config.score.text = string.format("<color=#%s>(+%s)</color>", color, scoreChange)
        else
            self.config.score.text = string.format("<color=#%s>(%s)</color>", color, scoreChange)
        end
    elseif score ~= nil and scoreChange == nil then
        self.config.score.text = tostring(score)
    else
        self.config.score.text = ""
    end
end

--- @return void
function AvatarGameOverView:ReturnPool()
    IconView.ReturnPool(self)
    if self.avatarIconView ~= nil then
        self.avatarIconView:ReturnPool()
        self.avatarIconView = nil
    end
end

--- @param avatarGameOverView {avatar, level, name, score, scoreChange}
--- @param avatar number
--- @param level number
--- @param name string
--- @param score number
--- @param scoreChange number
function AvatarGameOverView.SetAvatarGameOverView(avatarGameOverView, avatar, level, name, score, scoreChange)
    avatarGameOverView:SetData(avatar, level, name, score, scoreChange)
end

return AvatarGameOverView