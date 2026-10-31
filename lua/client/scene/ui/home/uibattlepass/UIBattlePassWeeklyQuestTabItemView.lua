
--- @class UIBattlePassWeeklyQuestTabItemView : IconView
UIBattlePassWeeklyQuestTabItemView = Class(UIEventPackageTabItem, IconView)

function UIBattlePassWeeklyQuestTabItemView:Ctor()
    IconView.Ctor(self)
end

function UIBattlePassWeeklyQuestTabItemView:SetPrefabName()
    self.prefabName = 'tab_battle_pass'
    self.uiPoolType = UIPoolType.BattlePassTabItem
end

--- @param transform UnityEngine_Transform
function UIBattlePassWeeklyQuestTabItemView:SetConfig(transform)
    ---@type UIBattlePassWeeklyQuestTabItemConfig
    self.config = UIBaseConfig(transform)

    --self:InitUpdateTime()
end

function UIBattlePassWeeklyQuestTabItemView:InitLocalization()

end

function UIBattlePassWeeklyQuestTabItemView:ReturnPool()
    IconView.ReturnPool(self)
end

--[[function IBattlePassWeeklyQuestTabItem:AddOnSelectListener(listener)
    self.config.buttonSelect.onClick:RemoveAllListeners()
    self.config.buttonSelect.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener()
    end)
end]]


return UIBattlePassWeeklyQuestTabItemView