--- @class UIHeroLinkingCardRequireItemView : MotionIconView
UIHeroLinkingCardRequireItemView = Class(UIHeroLinkingCardRequireItemView, MotionIconView)

--- @return void
function UIHeroLinkingCardRequireItemView:Ctor()
    ---@type BonusLinkingTierConfig
    self.bonusConfig = nil
    MotionIconView.Ctor(self)
end

--- @return void
function UIHeroLinkingCardRequireItemView:SetPrefabName()
    self.prefabName = 'linking_card_require'
    self.uiPoolType = UIPoolType.UIHeroLinkingCardRequireItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIHeroLinkingCardRequireItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UILinkingCardRequireConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param bonusConfig BonusLinkingTierConfig
function UIHeroLinkingCardRequireItemView:SetData(bonusConfig, count, isActive, countHero)
    self.bonusConfig = bonusConfig
    local localizeLinking = ""
    if self.bonusConfig.star > 1 then
        localizeLinking = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("hero_linking_description_2"), countHero, self.bonusConfig.star)
    else
        localizeLinking = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("hero_linking_description"), countHero)
    end
    self.config.textLinkingRequire.text = string.format( "%s (%s/%s)", localizeLinking, count or 0, countHero)
    self.config.iconLinkingActive:SetActive(isActive)
    local stat = ""
    ---@param v StatBonus
    for _, v in ipairs(self.bonusConfig.listBonus:GetItems()) do
        if stat == "" then
            stat = LanguageUtils.LocalizeStatBonus(v)
        else
            stat = string.format("%s   %s", stat, LanguageUtils.LocalizeStatBonus(v))
        end
    end
    self.config.textStat.text = stat
end

--- @return void
function UIHeroLinkingCardRequireItemView:UpdateUI()

end

--- @return void
function UIHeroLinkingCardRequireItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
end

return UIHeroLinkingCardRequireItemView