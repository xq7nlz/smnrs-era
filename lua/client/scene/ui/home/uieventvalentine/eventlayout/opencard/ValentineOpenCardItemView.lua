--- @class ValentineOpenCardItemView : MotionIconView
ValentineOpenCardItemView = Class(ValentineOpenCardItemView, MotionIconView)

--- @return void
function ValentineOpenCardItemView:Ctor()
    MotionIconView.Ctor(self)
    ---@type RootIconView
    self.itemView = nil
end
--- @return void
function ValentineOpenCardItemView:SetPrefabName()
    self.prefabName = 'valentine_open_card_item_view'
    self.uiPoolType = UIPoolType.ValentineOpenCardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function ValentineOpenCardItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type ValentineOpenCardItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData ItemIconData
function ValentineOpenCardItemView:SetIconData(iconData)
    if self.itemView == nil then
        self.itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
    end
    self.itemView:SetIconData(iconData)
    self.config.card.gameObject:SetActive(false)
end

--- @return void
function ValentineOpenCardItemView:HideItem()
    if self.itemView ~= nil then
        self.itemView:ReturnPool()
        self.itemView = nil
    end
    self.config.card.gameObject:SetActive(true)
end

--- @return void
---@param func function
function ValentineOpenCardItemView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function ValentineOpenCardItemView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
function ValentineOpenCardItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
end


return ValentineOpenCardItemView


