require "lua.client.scene.ui.battle.uiBattleMain.XmasDamageView"

--- @class UIVictoryValentineLayout : UIVictoryLayout
UIVictoryValentineLayout = Class(UIVictoryValentineLayout, UIVictoryLayout)

function UIVictoryValentineLayout:Ctor(view, anchor)
    --- @type UILoopScroll
    self.uiScroll = nil
    UIVictoryLayout.Ctor(self, view, anchor)
end

function UIVictoryValentineLayout:InitLayoutConfig()
    --- @type UIVictoryXmasLayoutConfig
    self.layoutConfig = UIBaseConfig(self.anchor)
    --- @type XmasDamageView
    self.xmasDamageView = XmasDamageView(self.layoutConfig.xmasDamageView)
    self:InitScroll()
end

function UIVictoryValentineLayout:InitScroll()
    --- @param obj RootIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local itemIconData = zg.playerData.rewardList:Get(dataIndex)
        obj:SetIconData(itemIconData)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollView, UIPoolType.RootIconView, onCreateItem)
end

function UIVictoryValentineLayout:InitLocalization()
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("reward")
    self.layoutConfig.textRecord.text = LanguageUtils.LocalizeCommon("record")
end

function UIVictoryValentineLayout:OnShow()
    self:GetData()
    UIVictoryLayout.OnShow(self)
end

function UIVictoryValentineLayout:GetData()
    --- @type EventValentineModel
    self.valentineModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE)
    --- @type List -- BossChallengeRewardMilestoneData
    self.listBossDamageRewardConfig = self.valentineModel:GetConfig():GetBossChallengeConfig().listBossDamageRewardConfig
end

function UIVictoryValentineLayout:ShowData()
    self.xmasDamageView:OnShow()
    self.xmasDamageView.totalDamageDeal = self.valentineModel.eventBossChallengeInBound.battleDamage
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

    local totalChest = self.valentineModel.eventBossChallengeInBound:GetTotalChest()
    self.layoutConfig.textChestCount.text = tostring(totalChest)

    self.xmasDamageView:UpdateUi()
    local dict = Dictionary()
    for i = 1, zg.playerData.rewardList:Count() do
        local reward = zg.playerData.rewardList:Get(i)
        print("reward :" .. LogUtils.ToDetail(reward))
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

function UIVictoryValentineLayout:OnHide()
    UIVictoryLayout.OnHide()
    self.uiScroll:Hide()
end