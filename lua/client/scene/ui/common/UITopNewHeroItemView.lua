
--- @class UITopNewHeroItemView : MotionIconView
UITopNewHeroItemView = Class(UITopNewHeroItemView, MotionIconView)

--- @return void
function UITopNewHeroItemView:Ctor()
    MotionIconView.Ctor(self)
end

--- @return void
function UITopNewHeroItemView:SetPrefabName()
    self.prefabName = 'top_new_hero_item'
    self.uiPoolType = UIPoolType.UITopNewHeroItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UITopNewHeroItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UILeaderBoardNewHeroConfig
    self.config = UIBaseConfig(transform)

end

--- @return void
function UITopNewHeroItemView:SetData(top, name, summoner)
    self.config.textTop.text = tostring(top)
    self.config.textName.text = name
    self.config.image.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconBannerSummoner2, string.format("top_summoner_%d_1", summoner))
end

return UITopNewHeroItemView