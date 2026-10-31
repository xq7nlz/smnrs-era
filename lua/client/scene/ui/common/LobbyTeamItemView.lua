--- @class LobbyTeamItemView : IconView
LobbyTeamItemView = Class(LobbyTeamItemView, IconView)

--- @return void
function LobbyTeamItemView:Ctor()

    IconView.Ctor(self)
end

--- @return void
function LobbyTeamItemView:SetPrefabName()
    self.prefabName = 'lobby_team'
    self.uiPoolType = UIPoolType.LobbyTeamItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function LobbyTeamItemView:SetConfig(transform)
    assert(transform)
    ---@type UILobbyItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
function LobbyTeamItemView:SetData()

end

--- @return void
function LobbyTeamItemView:ReturnPool()

    IconView.ReturnPool(self)
end

return LobbyTeamItemView