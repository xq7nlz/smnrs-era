require "lua.client.scene.ui.common.heroList.HeroListView"

--- @class UIPrefabHeroList2View : UIPrefabView
UIPrefabHeroList2View = Class(UIPrefabHeroList2View, UIPrefabView)

--- @return void
function UIPrefabHeroList2View:Ctor()
    ---@type HeroListView
    self.heroList = nil

    UIPrefabView.Ctor(self)
end

--- @return void
function UIPrefabHeroList2View:SetPrefabName()
    self.prefabName = 'prefab_hero_list_2'
    self.uiPoolType = UIPoolType.UIPrefabHeroList2View
end

--- @return void
--- @param transform UnityEngine_Transform
function UIPrefabHeroList2View:SetConfig(transform)
    --- @type HeroList2Config
    self.config = UIBaseConfig(transform)
    self.heroList = HeroListView(self.config.heroList)
    self.config.textSelectHeroes.text = LanguageUtils.LocalizeCommon("select_hero")
end

--- @return void
function UIPrefabHeroList2View:Show()
    self.config.gameObject:SetActive(true)
end

--- @return void
function UIPrefabHeroList2View:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self.heroList:ReturnPool()
end

return UIPrefabHeroList2View