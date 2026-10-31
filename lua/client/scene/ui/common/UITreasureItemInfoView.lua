
--- @class UITreasureItemInfoView : MotionIconView
UITreasureItemInfoView = Class(UITreasureItemInfoView, MotionIconView)

--- @return void
function UITreasureItemInfoView:Ctor()
    MotionIconView.Ctor(self)
end

--- @return void
function UITreasureItemInfoView:SetPrefabName()
    self.prefabName = 'treasure_item_info'
    self.uiPoolType = UIPoolType.UITreasureItemInfoView
end

--- @return void
--- @param transform UnityEngine_Transform
function UITreasureItemInfoView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UITreasureItemInfoConfig
    self.config = UIBaseConfig(transform)

end

--- @return void
function UITreasureItemInfoView:SetData(index, listReward, isClaim)
    self.config.textItemExchange.text = string.format(LanguageUtils.LocalizeCommon("complete_journey_x"), index)
    self.listItem = List()
    ---@param v RewardInBound
    for i, v in ipairs(listReward:GetItems()) do
        ---@type RootIconView
        local itemOwn = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
        itemOwn:SetIconData(v:GetIconData())
        itemOwn:RegisterShowInfo()
        if isClaim then
            itemOwn:ActiveMaskSelect(true)
        end
        self.listItem:Add(itemOwn)
    end
end

--- @return void
--- @param transform UnityEngine_Transform
function UITreasureItemInfoView:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.listItem ~= nil then
        ---@param v IconView
        for i, v in ipairs(self.listItem:GetItems()) do
            v:ReturnPool()
        end
        self.listItem = nil
    end
end

return UITreasureItemInfoView