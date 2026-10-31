require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryKazetsuLayout"
require "lua.client.scene.ui.battle.uiBattleMain.FindeBossDamageView"
--- @class UIVictoryFindeLayout : UIVictoryKazetsuLayout
UIVictoryFindeLayout = Class(UIVictoryFindeLayout, UIVictoryKazetsuLayout)


function UIVictoryFindeLayout:InitLayoutConfig()
    --- @type UIVictoryXmasLayoutConfig
    self.layoutConfig = UIBaseConfig(self.anchor)

    --- @type XmasDamageView
    self.xmasDamageView = FindeBossDamageView(self.layoutConfig.xmasDamageView)
    self:InitScroll()
end


function UIVictoryFindeLayout:GetData()
    --- @type EventFindeBossModel
    self.findeBossModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_FINDE_BOSS)
    --- @type List -- BossChallengeRewardMilestoneData
    self.listBossDamageRewardConfig = self.findeBossModel:GetConfig().listBossDamageRewardConfig
end

function UIVictoryFindeLayout:ShowData()
    self.xmasDamageView:OnShow()
    self.xmasDamageView.totalDamageDeal = self.findeBossModel.eventBossChallengeInBound.battleDamage
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

    local totalChest = self.findeBossModel.eventBossChallengeInBound:GetTotalChest()
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

function UIVictoryFindeLayout:OnHide()
    UIVictoryLayout.OnHide()
    self.uiScroll:Hide()
end