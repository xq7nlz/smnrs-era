require "lua.client.scene.ui.battle.uiBattleMain.XmasDamageView"

--- @class UIVictoryXmasLayout : UIVictoryLayout
UIVictoryXmasLayout = Class(UIVictoryXmasLayout, UIVictoryLayout)

function UIVictoryXmasLayout:Ctor(view, anchor)
    --- @type UILoopScroll
    self.uiScroll = nil
    UIVictoryLayout.Ctor(self, view, anchor)
end

function UIVictoryXmasLayout:InitLayoutConfig()
    --- @type UIVictoryXmasLayoutConfig
    self.layoutConfig = UIBaseConfig(self.anchor)
    --- @type XmasDamageView
    self.xmasDamageView = XmasDamageView(self.layoutConfig.xmasDamageView)
    self:InitScroll()
end

function UIVictoryXmasLayout:InitScroll()
    --- @param obj RootIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local itemIconData = zg.playerData.rewardList:Get(dataIndex)
        obj:SetIconData(itemIconData)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollView, UIPoolType.RootIconView, onCreateItem)
end

function UIVictoryXmasLayout:InitLocalization()
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("reward")
    self.layoutConfig.textRecord.text = LanguageUtils.LocalizeCommon("record")
end

function UIVictoryXmasLayout:OnShow()
    self:GetData()
    UIVictoryLayout.OnShow(self)
    self.xmasDamageView:OnShow()
end

function UIVictoryXmasLayout:GetData()
    --- @type EventXmasModel
    self.eventXmasModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    --- @type EventXmasConfig
    self.eventXmasConfig = self.eventXmasModel:GetConfig()
    --- @type List -- BossChallengeRewardMilestoneData
    self.listIgnatiusConfig = self.eventXmasConfig:GetListIgnatiusConfig()
end

function UIVictoryXmasLayout:ShowData()
    self.xmasDamageView.totalDamageDeal = self.eventXmasModel.christmasChallengeBossInBound.battleDamage
    self.xmasDamageView.nextMilestone = 1
    --print ("total ignatus hoangpl " , self.listIgnatiusConfig:Count())

    local reachMax = true
    for i = 1, self.listIgnatiusConfig:Count() do
        --- @type BossChallengeRewardMilestoneData
        local bossChallengeRewardMilestoneData = self.listIgnatiusConfig:Get(i)
        if bossChallengeRewardMilestoneData.damage >= self.xmasDamageView.totalDamageDeal then
            --print("challenges dmg hoangpl " ,bossChallengeRewardMilestoneData.damage, "Total damage " , self.xmasDamageView.totalDamageDeal , "nextMilestone " , i)
            self.xmasDamageView.nextMilestone = i
            self.xmasDamageView.milestoneDamage = bossChallengeRewardMilestoneData.damage
            reachMax = false
            break
        end
    end
    if (reachMax) then
        self.xmasDamageView.nextMilestone = self.listIgnatiusConfig:Count()
        self.xmasDamageView.milestoneDamage = self.listIgnatiusConfig:Get(self.xmasDamageView.nextMilestone).damage
    end
    local totalChest = self.eventXmasModel.christmasChallengeBossInBound:GetTotalChest()
    self.layoutConfig.textChestCount.text = tostring(totalChest)

    self.xmasDamageView:UpdateUi()

    self.uiScroll:Resize(zg.playerData.rewardList:Count())
end

function UIVictoryXmasLayout:OnHide()
    UIVictoryLayout.OnHide()
    self.uiScroll:Hide()
end