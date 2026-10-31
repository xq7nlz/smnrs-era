--- @class UnlockBattlePassPanelLayout
UnlockBattlePassPanelLayout = Class(UnlockBattlePassPanelLayout)

function UnlockBattlePassPanelLayout:Ctor(anchor, onClickBuy)
    --- @type UnlockBattlePassPanelLayoutConfig
    self.config = UIBaseConfig(anchor)

    --- @type function
    self.onClickBuy = onClickBuy

    self:InitScroll()
    --- @type EventBattlePassModel
    self.eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    self.config.buttonBuy.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.onClickBuy then
            self.onClickBuy()
        end
    end)
end

function UnlockBattlePassPanelLayout:InitLocalization(packId)
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("unlock_battle_pass_" .. packId)
end

function UnlockBattlePassPanelLayout:InitScroll()
    --- @param obj RootIconView
    local onCreateItem = function(obj, index)
        index = index + 1
        --- @type RewardInBound
        local reward = self.listReward:Get(index)
        obj:SetIconData(reward:GetIconData())
        if self.isBought then
            obj:ActiveMaskSelect(true)
        end
        obj:RegisterShowInfo()
    end
    self.scrollReward = UILoopScroll(self.config.scrollReward, UIPoolType.RootIconView, onCreateItem)
end

--- @param productConfig ProductConfig
function UnlockBattlePassPanelLayout:SetReward(productConfig, boughtCount)
    self.listReward = List()
    for i = 1, productConfig:GetRewardList():Count() do
        self.listReward:Add(productConfig:GetRewardList():Get(i))
    end
    --- @type Dictionary
    local lineRewardList = self.eventBattlePassModel:GetConfig():GetLineRewardConfig()
    local expectLevel = self.eventBattlePassModel:GetCurLevel().level
    if expectLevel < 50 then
        for i = 1, self.listReward:Count() do
            if (self.listReward:Get(i)).id == MoneyType.BATTLE_PASS_EXP then
                expectLevel =expectLevel + self.listReward:Get(i).number / 100
                if expectLevel > 50 then
                    expectLevel = 50
                end
            end
        end
        for i = 1, expectLevel do
            --- @type LineRewardConfig
            local lineReward = lineRewardList:Get(i)
            if not lineReward.isFree then
                self.listReward:Add(lineReward.reward)
            end
        end
    else
        for i = 1, expectLevel do
            --- @type LineRewardConfig
            local lineReward = lineRewardList:Get(i)
            if not lineReward.isFree then
                self.listReward:Add(lineReward.reward)
            end
        end
    end
    self.scrollReward:Resize(self.listReward:Count())

    if boughtCount >= productConfig.stock then
        self.config.textPrice.text = LanguageUtils.LocalizeCommon("sold_out")
    else
        self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(productConfig.productID)
    end
end

function UnlockBattlePassPanelLayout:OnHide()
    self.scrollReward:Hide()
end