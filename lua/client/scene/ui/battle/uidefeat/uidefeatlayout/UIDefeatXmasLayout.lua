require "lua.client.scene.ui.battle.uiBattleMain.XmasDamageView"

--- @class UIDefeatXmasLayout : UIDefeatLayout
UIDefeatXmasLayout = Class(UIDefeatXmasLayout, UIDefeatLayout)

function UIDefeatXmasLayout:Ctor(view, anchor)
    --- @type UILoopScroll
    self.uiScroll = nil
    UIDefeatLayout.Ctor(self, view, anchor)
end

function UIDefeatXmasLayout:InitLayoutConfig()
    --- @type UIDefeatXmasLayoutConfig
    self.layoutConfig = UIBaseConfig(self.anchor)
    --- @type XmasDamageView
    self.xmasDamageView = XmasDamageView(self.layoutConfig.xmasDamageView)
    self:InitScroll()
end

function UIDefeatXmasLayout:InitScroll()
    --- @param obj RootIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local itemIconData = zg.playerData.rewardList:Get(dataIndex)
        obj:SetIconData(itemIconData)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollView, UIPoolType.RootIconView, onCreateItem)
end

function UIDefeatXmasLayout:InitLocalization()
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("reward")
    self.layoutConfig.textRecord.text = LanguageUtils.LocalizeCommon("record")
end

function UIDefeatXmasLayout:OnShow()
    self:GetData()
    UIDefeatLayout.OnShow(self)
end

function UIDefeatXmasLayout:GetData()
    --- @type EventXmasModel
    self.eventXmasModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    --- @type EventXmasConfig
    self.eventXmasConfig = self.eventXmasModel:GetConfig()
    --- @type List -- BossChallengeRewardMilestoneData
    self.listIgnatiusConfig = self.eventXmasConfig:GetListIgnatiusConfig()
end

function UIDefeatXmasLayout:ShowData()
    self.xmasDamageView:OnShow()
    self.xmasDamageView.totalDamageDeal = self.eventXmasModel.christmasChallengeBossInBound.battleDamage
    self.xmasDamageView.nextMilestone = 1
    local reachMax = true
    for i = 1, self.listIgnatiusConfig:Count() do
        --- @type BossChallengeRewardMilestoneData
        local bossChallengeRewardMilestoneData = self.listIgnatiusConfig:Get(i)
        if bossChallengeRewardMilestoneData.damage >= self.xmasDamageView.totalDamageDeal then
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

function UIDefeatXmasLayout:OnHide()
    UIDefeatLayout.OnHide()
    self.uiScroll:Hide()
end