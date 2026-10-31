require "lua.client.battleShow.Others.BattleRewardChest"
require "lua.client.scene.ui.battle.uiBattleMain.XmasDamageView"
--- @class KazetsuBossDamageView : XmasDamageView
KazetsuBossDamageView = Class(KazetsuBossDamageView,XmasDamageView)

function KazetsuBossDamageView:GetChestIdByIndex(index)
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
    return 10
end
