--- @class ChestKazetsuItemView : ChestIgnatiusItemView
ChestKazetsuItemView = Class(ChestKazetsuItemView, ChestIgnatiusItemView)

--- @return void
function ChestKazetsuItemView:Ctor()
    ---@type List
    self.listReward = List()
    ---@type List
    self.listIconData = List()
    MotionIconView.Ctor(self)
    self:InitButtons()
    self:InitLocalization()
end

--- @return void
function ChestKazetsuItemView:SetPrefabName()
    self.prefabName = 'chest_kazetsu'
    self.uiPoolType = UIPoolType.ChestKazetsuItemView
end

function ChestKazetsuItemView:GetChestIdByIndex(index)
    if index == 1 then
        return 1
    elseif index == 2 then
        return 4
    elseif index == 3 then
        return 7
    elseif index == 4 then
        return 8
    elseif index == 5 then
        return 9
    elseif index == 6 then
        return 10
    end
    return 9
end


return ChestKazetsuItemView