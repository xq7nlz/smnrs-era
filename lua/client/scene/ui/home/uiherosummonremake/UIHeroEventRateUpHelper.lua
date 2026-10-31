--- @class UIHeroEventRateUpHelper
UIHeroEventRateUpHelper = Class(UIHeroEventRateUpHelper)

function UIHeroEventRateUpHelper:Ctor(uiTransform)
    --- @type UIHeroEventRateUpHelperConfig
    self.config = UIBaseConfig(uiTransform)
    self:Localize()
end

function UIHeroEventRateUpHelper:Localize()
    self.config.guaranteedRequirementDescribe.text = LanguageUtils.LocalizeCommon("guaranteed_requirement_describe")
    self.config.guaranteedRequirementTitle.text = LanguageUtils.LocalizeCommon("guaranteed_requirement")
    self.config.eventRateUpHelper.onClick:AddListener(function()
        self:OnClickHide()
    end)
end
function UIHeroEventRateUpHelper:OnClickShow()
    self.config.eventRateUpHelper.gameObject:SetActive(true)
    DOTweenUtils.DOScale(self.config.popUp.transform, U_Vector3(1, 1, 1), 0.2, nil, function()
    end)
end
function UIHeroEventRateUpHelper:OnClickHide()
    DOTweenUtils.DOScale(self.config.popUp.transform, U_Vector3(0, 0, 0), 0.2, nil, function()
        self.config.eventRateUpHelper.gameObject:SetActive(false)
    end)
end