--- @class UIPointSummonNewHeroItemView : MotionIconView
UIPointSummonNewHeroItemView = Class(UIPointSummonNewHeroItemView, MotionIconView)

--- @return void
function UIPointSummonNewHeroItemView:Ctor()
    ---@type number
    self.point = nil
    ---@type List
    self.listReward = nil
    ---@type List
    self.listItem = nil
    MotionIconView.Ctor(self)
end

--- @return void
function UIPointSummonNewHeroItemView:SetPrefabName()
    self.prefabName = 'point_summon_hero'
    self.uiPoolType = UIPoolType.UIPointSummonNewHeroItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIPointSummonNewHeroItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIPointSummonNewHeroItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
function UIPointSummonNewHeroItemView:SetData(point, listReward)
    self.point = point
    self.listReward = listReward
    self:ReturnPoolListItem()
    self.listItem = List()
    ---@param v RewardInBound
    for i, v in ipairs(listReward:GetItems()) do
        ---@type RootIconView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
        item:SetIconData(v:GetIconData())
        item:RegisterShowInfo()
        self.listItem:Add(item)
    end
    self.config.textProgressBarValue.text = tostring(point)
end

--- @return void
function UIPointSummonNewHeroItemView:SetClaimReward(isClaim)
    if self.listItem ~= nil then
        ---@param v ItemIconView
        for i, v in ipairs(self.listItem:GetItems()) do
            v:ActiveMaskSelect(isClaim)
        end
    end
end

--- @return void
function UIPointSummonNewHeroItemView:ReturnPoolListItem()
    if self.listItem ~= nil then
        ---@param v ItemIconView
        for i, v in ipairs(self.listItem:GetItems()) do
            v:ReturnPool()
        end
        self.listItem:Clear()
        self.listItem = nil
    end
end

--- @return void
function UIPointSummonNewHeroItemView:ReturnPool()
    self:ReturnPoolListItem()
    MotionIconView.ReturnPool(self)
end

return UIPointSummonNewHeroItemView