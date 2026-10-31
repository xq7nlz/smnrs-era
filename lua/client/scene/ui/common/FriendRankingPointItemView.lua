---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.FriendRankingPointItemConfig"

--- @class FriendRankingPointItemView : IconView
FriendRankingPointItemView = Class(FriendRankingPointItemView, IconView)

FriendRankingPointItemView.prefabName = 'friend_ranking_point_item_view'

--- @return void
function FriendRankingPointItemView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function FriendRankingPointItemView:SetPrefabName()
    self.prefabName = 'friend_ranking_point_item_view'
    self.uiPoolType = UIPoolType.FriendRankingPointItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function FriendRankingPointItemView:SetConfig(transform)
    assert(transform)
    --- @type FriendRankingPointItemConfig
    ---@type FriendRankingPointItemConfig
    self.config = UIBaseConfig(transform)

end

return FriendRankingPointItemView