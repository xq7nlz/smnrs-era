--- @class ListHeroRecommendItemView : UIEventQuestItem
ListHeroRecommendItemView = Class(ListHeroRecommendItemView, UIPrefabView)

function ListHeroRecommendItemView:Ctor()
    UIPrefabView.Ctor(self)
    self.index = 0
end

function ListHeroRecommendItemView:SetPrefabName()
    self.prefabName = 'hero_recommend_group_item'
    self.uiPoolType = UIPoolType.ListHeroRecommendItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function ListHeroRecommendItemView:SetConfig(transform)
    --- @type ListHeroRecommendItemConfig
    self.config = UIBaseConfig(transform)
    self:InitScroll()
end
--- @param heroList Dictionary
function ListHeroRecommendItemView:InitScroll()
    ----- @param obj HeroCardItemView
    ----- @param index number
    --local onCreateItemHeroCard = function(obj, index)
    --    obj:EnableButton(true)
    --    ---@type HeroResource
    --    local heroData = HeroResource()
    --    heroData:SetData(-1, self.heroList:Get(index + 1).heroId, 1, 1)
    --    ---@type HeroIconData
    --    local heroIconData = HeroIconData.CreateByHeroResource(heroData)
    --    if heroIconData then
    --        obj:SetIconData(heroIconData)
    --    end
    --end
    --self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.HeroCardItemView, onCreateItemHeroCard)


end

--- @return void
--- @param heroList List
function ListHeroRecommendItemView:SetData(heroList, gameMode)
    --- @type List
    self.heroList = heroList
    --- @type List
    self.listItem = List()
    self.config.decs.text = LanguageUtils.LocalizeCommon("hero_recommend_game_mode_" .. gameMode)
    for i = 1, self.heroList:Count() do
        if i > 5 then
            break
        end
        local heroData = HeroResource()
        heroData:SetData(-1, self.heroList:Get(i).heroId, 1, 1)
        local heroIconData = HeroIconData.CreateByHeroResource(heroData)
        ---@type HeroCardItemView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroCardItemView, self.config.anchor)
        item:SetSize()
        item:SetIconData(heroIconData)
        item.config.starImage.gameObject:SetActive(false)
        local percent = tostring(self.heroList:Get(i).usedPercent) .. "%"
        item.config.txtLv.text = UIUtils.SetColorString(UIUtils.green_light, percent)
        item.config.textName.transform.localPosition = U_Vector3(0, -95, 0)
        self.listItem:Add(item)
    end
end

--- @return void
function ListHeroRecommendItemView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    for i = 1, self.listItem:Count() do
        local item = self.listItem:Get(i)
        item.config.textName.transform.localPosition = U_Vector3(0, -65, 0)
        item:ReturnPool()
    end
    self.listItem:Clear()
end

return ListHeroRecommendItemView