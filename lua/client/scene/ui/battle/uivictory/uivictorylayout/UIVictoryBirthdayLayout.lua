require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryKazetsuLayout"
require "lua.client.scene.ui.battle.uiBattleMain.BirthdayBossDamageView"
--- @class UIVictoryBirthdayLayout : UIVictoryKazetsuLayout
UIVictoryBirthdayLayout = Class(UIVictoryBirthdayLayout, UIVictoryKazetsuLayout)


function UIVictoryBirthdayLayout:InitLayoutConfig()
    --- @type UIVictoryXmasLayoutConfig
    self.layoutConfig = UIBaseConfig(self.anchor)

    --- @type XmasDamageView
    self.xmasDamageView = BirthdayBossDamageView(self.layoutConfig.xmasDamageView)
    self:InitScroll()
end


function UIVictoryBirthdayLayout:GetData()
    --- @type EventBirthdayModel
    self.birthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    --- @type List -- BossChallengeRewardMilestoneData
    self.listBossDamageRewardConfig = self.birthdayModel:GetConfig().bossConfig.listBossDamageRewardConfig
end

function UIVictoryBirthdayLayout:ShowData()
    self.xmasDamageView:OnShow()
    self.xmasDamageView.totalDamageDeal = self.birthdayModel.eventBossChallengeInBound.battleDamage
    self.xmasDamageView.nextMilestone = 1

    for i = 1, self.listBossDamageRewardConfig:Count() do
        --- @type BossChallengeRewardMilestoneData
        local bossChallengeRewardMilestoneData = self.listBossDamageRewardConfig:Get(i)
        if bossChallengeRewardMilestoneData.damage >= self.xmasDamageView.totalDamageDeal
                or i == self.listBossDamageRewardConfig:Count() then
            self.xmasDamageView.nextMilestone = i
            self.xmasDamageView.milestoneDamage = bossChallengeRewardMilestoneData.damage
            break
        end
    end

    local totalChest = self.birthdayModel.eventBossChallengeInBound:GetTotalChest()
    self.layoutConfig.textChestCount.text = tostring(totalChest)

    self.xmasDamageView:UpdateUi()
    local dict = Dictionary()
    for i = 1, zg.playerData.rewardList:Count() do
        local reward = zg.playerData.rewardList:Get(i)
        if not dict:IsContainKey(reward.itemId) then
            dict:Add(reward.itemId,i)
        end
    end
    for i = zg.playerData.rewardList:Count(), 1,-1 do
        --- @type RewardInBound
        local reward = zg.playerData.rewardList:Get(i)
        if dict:IsContainKey(reward.itemId) and i ~= dict:Get(reward.itemId) then
            --- @type RewardInBound
            local reward1 = zg.playerData.rewardList:Get(dict:Get(reward.itemId))
            reward1.quantity  = reward1.quantity + reward.quantity
            zg.playerData.rewardList:RemoveByIndex(i)
        end
    end
    self.uiScroll:Resize(zg.playerData.rewardList:Count())
end