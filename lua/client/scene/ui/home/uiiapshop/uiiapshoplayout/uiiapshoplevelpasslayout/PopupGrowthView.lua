require "lua.client.scene.ui.common.UIBarPercentView"

--- @class PopupGrowthView : PrefabView
PopupGrowthView = Class(PopupGrowthView, PrefabView)

function PopupGrowthView:Ctor()
    PrefabView.Ctor(self)
end

function PopupGrowthView:SetPrefabName()
    self.prefabName = 'popup_growth_patch'
end

--- @return void
--- @param transform UnityEngine_Transform
function PopupGrowthView:SetConfig(transform)
    --- @type PopupGrowthConfig
    ---@type PopupGrowthConfig
    self.config = UIBaseConfig(transform)
    self.expBar = UIBarPercentView(self.config.barPercent)
end

function PopupGrowthView:InitLocalization()
    self.config.textSummonerExp.text = LanguageUtils.LocalizeCommon("summoner_exp")
    self.config.textUnlock.text = LanguageUtils.LocalizeCommon("unlock_level_pass")
    self.config.textActive.text = LanguageUtils.LocalizeCommon("activated")
end

function PopupGrowthView:OnHide()
    self.config.buttonUnlock.onClick:RemoveAllListeners()
end

--- @param isActive boolean
--- @param isUnlock boolean
function PopupGrowthView:SetUnlock(isActive, isUnlock)
    self.config.buttonUnlock.gameObject:SetActive(isActive and not isUnlock)
    self.config.buttonActive:SetActive(isUnlock)
end

--- @param price string
function PopupGrowthView:SetPrice(price)
    self.config.textPrice.text = price
end

function PopupGrowthView:OnDestroy()
    U_Object.Destroy(self.config.gameObject)
end