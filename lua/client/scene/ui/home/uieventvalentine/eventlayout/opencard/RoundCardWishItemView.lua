--- @class RoundCardWishItemView : MotionIconView
RoundCardWishItemView = Class(RoundCardWishItemView, MotionIconView)

--- @return void
function RoundCardWishItemView:Ctor()
    MotionIconView.Ctor(self)
end
--- @return void
function RoundCardWishItemView:SetPrefabName()
    self.prefabName = 'round_card_wish'
    self.uiPoolType = UIPoolType.RoundCardWishItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function RoundCardWishItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type RoundCardWishItemConfig
    self.config = UIBaseConfig(transform)
end

return RoundCardWishItemView


