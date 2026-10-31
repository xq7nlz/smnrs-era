require "lua.client.battleShow.Others.BattleRewardChest"
require "lua.client.scene.ui.battle.uiBattleMain.XmasDamageView"
--- @class BirthdayBossDamageView : XmasDamageView
BirthdayBossDamageView = Class(BirthdayBossDamageView,XmasDamageView)

function BirthdayBossDamageView:GetChestIdByIndex(index,factionType)
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
        if factionType == HeroFactionType.LIGHT then
            return 13
        else
            return 12
        end
    end
    if factionType == HeroFactionType.LIGHT then
        return 13
    else
        return 12
    end
end

function BirthdayBossDamageView:ShowRewardBox()
    --- @type EventBirthdayModel
    local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    self.config.imgBox.sprite = ResourceLoadUtils.LoadChestIcon(self:GetChestIdByIndex(self.nextMilestone),eventBirthdayModel.selectSideId)
    self.config.imgBox:SetNativeSize()
end