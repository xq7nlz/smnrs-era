--- @class RateView : IconView
RateView = Class(RateView, IconView)

--- @return void
function RateView:Ctor()
    IconView.Ctor(self)
end
--- @return void
function RateView:SetPrefabName()
    self.prefabName = 'rate_mask'
    self.uiPoolType = UIPoolType.RateView
end

--- @return void
--- @param transform UnityEngine_Transform
function RateView:SetConfig(transform)
    ---@type RateViewConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param rate string
function RateView:SetIconData(rate)
    self.config.textRate.text = rate
    self.gameObject  = self.config.gameObject
end

return RateView


