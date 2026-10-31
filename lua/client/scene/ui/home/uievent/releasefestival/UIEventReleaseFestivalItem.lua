---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiEvent.releaseFestival.UIEventReleaseFestivalItemConfig"

--- @class UIEventReleaseFestivalItem : MotionIconView
UIEventReleaseFestivalItem = Class(UIEventReleaseFestivalItem, MotionIconView)

function UIEventReleaseFestivalItem:Ctor()
    --- @type RootIconView
    self.rootIconView = nil
    MotionIconView.Ctor(self)
end

function UIEventReleaseFestivalItem:SetPrefabName()
    self.prefabName = 'event_release_festival_item'
    self.uiPoolType = UIPoolType.UIEventReleaseFestivalItem
end

--- @param transform UnityEngine_Transform
function UIEventReleaseFestivalItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventReleaseFestivalItemConfig
    self.config = UIBaseConfig(transform)
end

function UIEventReleaseFestivalItem:InitLocalization()
    self.config.textClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.config.textClaimed.text = LanguageUtils.LocalizeCommon("archived")
    self.config.textNotEnough.text = LanguageUtils.LocalizeCommon("in_progress")
end

--- @param currentProgress number
--- @param itemConfig {numberPlayer : number, rewardInBound : RewardInBound}
function UIEventReleaseFestivalItem:SetData(currentProgress, itemConfig, isClaimed)
    self.config.textEventTarget.text = string.format("%s %s", UIUtils.SetColorString(UIUtils.color2, itemConfig.numberPlayer), LanguageUtils.LocalizeCommon("player_join_server"))
    self.config.progressBar.fillAmount = currentProgress / itemConfig.numberPlayer
    if isClaimed == false then
        self.config.textEventPregress.text = string.format("%s/%s", currentProgress, itemConfig.numberPlayer)
    else
        self.config.textEventPregress.text = string.format("%s/%s", itemConfig.numberPlayer, itemConfig.numberPlayer)
    end

    self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemTableAnchor)
    self.rootIconView:SetIconData(itemConfig.rewardInBound:GetIconData())
end

function UIEventReleaseFestivalItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.rootIconView ~= nil then
        self.rootIconView:ReturnPool()
        self.rootIconView = nil
    end
end

function UIEventReleaseFestivalItem:AddOnClaimListener(callback)
    self.config.claimed:SetActive(false)
    self.config.buttonNotEnough:SetActive(false)
    self.config.buttonClaim.onClick:RemoveAllListeners()
    self.config.buttonClaim.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if callback then
            callback()
        end
    end)
    self.config.buttonClaim.gameObject:SetActive(true)
end

function UIEventReleaseFestivalItem:SetDefaultButton()
    self.config.buttonClaim.gameObject:SetActive(false)
    self.config.claimed:SetActive(false)
end

function UIEventReleaseFestivalItem:SetAsNotEnough()
    self.config.claimed:SetActive(false)
    self.config.buttonClaim.gameObject:SetActive(false)
    self.config.buttonNotEnough.gameObject:SetActive(true)
end

function UIEventReleaseFestivalItem:HideAllButton()
    self.config.claimed:SetActive(false)
    self.config.buttonClaim.gameObject:SetActive(false)
    self.config.buttonNotEnough.gameObject:SetActive(false)
end

function UIEventReleaseFestivalItem:SetAsClaimed()
    self.config.buttonClaim.gameObject:SetActive(false)
    self.config.buttonNotEnough.gameObject:SetActive(false)
    self.config.claimed:SetActive(true)
end

return UIEventReleaseFestivalItem