--- @class UIBattlePassRewardItemView : IconView
UIBattlePassRewardItemView = Class(UIBattlePassRewardItemView, IconView)

--- @return void
function UIBattlePassRewardItemView:Ctor()
    ---@type function
    self.callbackSelect = nil
    ---@type UILoopScroll
    self.uiScroll = nil

    IconView.Ctor(self)

end

--- @return void
function UIBattlePassRewardItemView:SetPrefabName()
    self.prefabName = 'battle_pass_reward_item_view'
    self.uiPoolType = UIPoolType.UIBattlePassRewardItemView
end
--- @return void
--- @param transform UnityEngine_Transform
function UIBattlePassRewardItemView:SetConfig(transform)
    assert(transform)
    --- @type UIBattlePassRewardItemConfig
    self.config = UIBaseConfig(transform)
end

function UIBattlePassRewardItemView:SetRewardLevelOnState(playerCurLevel, level)
    self.config.iconNumberBGOK:SetActive(playerCurLevel + 1 > level)
    self.config.iconNumberBGCur:SetActive(playerCurLevel + 1 == level)
    self.config.iconNumberBGNA:SetActive(playerCurLevel + 1 < level)
    self.config.barOn:SetActive(level ~= 50)
    self.config.barOff:SetActive(level ~= 50)
end

--- @return void
function UIBattlePassRewardItemView:SetData(data)
    ---@type LineRewardConfig
    local lineRewardConfig = data.lineRewardConfig
    self.dataId = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS).timeData.dataId
    self:SetImageByDataId()

    ---@type RewardState
    local rewardState = RewardState.AVAILABLE_TO_CLAIM -- hoangpl edit
    data.rewardState = rewardState
    local playerCurLevel = tonumber(data.currentLevel)

    local level = tonumber(data.lineRewardConfig.level)
    self:SetRewardLevelOnState(playerCurLevel, level)
    ---@type boolean
    local rewardIsPremiumType = not lineRewardConfig.isFree
    local userUnlockedPremium = data.userUnlockedPremium
    if (rewardIsPremiumType) then
        self.config.iconLockPremium:SetActive(not userUnlockedPremium)
        self.config.iconUnlockPremium:SetActive(userUnlockedPremium)
    else
        self.config.iconLockPremium:SetActive(false)
        self.config.iconUnlockPremium:SetActive(false)
    end

    local claimed = data.claimed
    self.config.rewardtick:SetActive(claimed)

    self.config.freeBackground:SetActive(data.lineRewardConfig.isFree)
    self.config.premiumGround:SetActive(rewardIsPremiumType)
    self.config.unlockPremiumBg:SetActive(playerCurLevel + 1 > level)
    self.config.textNumberReward.text = tostring(level)
    self.config.freeText.text = LanguageUtils.LocalizeCommon("free")

    ---@type RewardInBound
    local rewardInBound = data.lineRewardConfig.reward
    if self.rootIconView == nil and rewardInBound ~= nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardRoot)
        self.rootIconView:SetIconData(rewardInBound:GetIconData())
        self.rootIconView:RegisterShowInfo()
    end

end

--- @return void
function UIBattlePassRewardItemView:ReturnPool()
    IconView.ReturnPool(self)
    if (self.rootIconView ~= nil) then
        self.rootIconView:ReturnPool()
        self.rootIconView = nil
    end
end

--- @return void
function UIBattlePassRewardItemView:OnClickSelect()
    if self.callbackSelect ~= nil then
        self.callbackSelect()
    end
end

--- @return void
function UIBattlePassRewardItemView:SetImageByDataId()
    self:SetSprite("icon_reward_holder_lock", self.config.iconLockPremiumImage, true)
    self:SetSprite("bg_level_bar_1", self.config.bgLevelBar1)
    self:SetSprite("bg_level_bar_2", self.config.bgLevelBar2)
    self:SetSprite("bg_level_bar_3", self.config.bgLevelBar3)
    self:SetSprite("bg_premium_border_frame", self.config.borderImage, true)
    self:SetSprite("bg_reward_holder_off", self.config.freeBgImage, true)
    self:SetSprite("bg_reward_holder_on", self.config.bgImage, true)
    self:SetSprite("icon_stage_off", self.config.iconOff)
    self:SetSprite("icon_stage_current", self.config.iconCurrent)
    self:SetSprite("icon_stage_on", self.config.iconOn)
    self:SetSprite("demo_reward_efffect", self.config.unlockBgImage, true)
    self:SetSprite("icon_free_black", self.config.freeTextBG, true)
end

--- @return void
function UIBattlePassRewardItemView:SetSprite(spriteName, image, isSetNative)
	if self.lastDataId ~= self.dataId then
        self.lastDataId = self.dataId
    end
    image.sprite = ResourceLoadUtils.LoadAssetBattlePass(self.dataId, spriteName)
    if isSetNative then
        image:SetNativeSize()
    end
end

return UIBattlePassRewardItemView