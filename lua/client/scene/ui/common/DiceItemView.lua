--- @class DiceItemView : IconView
DiceItemView = Class(DiceItemView, IconView)

--- @return void
function DiceItemView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function DiceItemView:SetPrefabName()
    self.prefabName = 'dice_item'
    self.uiPoolType = UIPoolType.DiceItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function DiceItemView:SetConfig(transform)
    if transform == nil then
        XDebug.Error("DiceItemView => transform is nil")
    end
    ---@type DiceItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param moneyType MoneyType
function DiceItemView:SetIconData(index,callback)
    self.config.diceItemImage.sprite = ResourceLoadUtils.LoadEaterEggDice(index)
    self.config.button.onClick:AddListener(function()
        callback(index)
    end)
end


--- @return void
function DiceItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:_RemoveListener()
end


--- @return void
function DiceItemView:_RemoveListener()
    self.config.button.onClick:RemoveAllListeners()
end

return DiceItemView

