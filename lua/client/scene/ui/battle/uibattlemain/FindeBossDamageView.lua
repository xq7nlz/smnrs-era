require "lua.client.battleShow.Others.BattleRewardChest"
require "lua.client.scene.ui.battle.uiBattleMain.XmasDamageView"
--- @class FindeBossDamageView : XmasDamageView
FindeBossDamageView = Class(FindeBossDamageView,XmasDamageView)

function FindeBossDamageView:GetChestIdByIndex(index)
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
        return 11
    end
    return 11
end
