--- @class VipBenefitDetailView : UIPrefabView
VipBenefitDetailView = Class(VipBenefitDetailView, UIPrefabView)

function VipBenefitDetailView:Ctor()
    UIPrefabView.Ctor(self)
end

--- @return void
--- @param transform UnityEngine_Transform
function VipBenefitDetailView:SetConfig(transform)
    ---@type VipBenefitDetailConfig
    self.config = UIBaseConfig(transform)
end

function VipBenefitDetailView:SetPrefabName()
    self.prefabName = 'vip_benefit_detail'
    self.uiPoolType = UIPoolType.VipBenefitDetailView
end

--- @param data VipBenefitData
function VipBenefitDetailView:SetData(data)
    self.config.textIndex.text = data.index
    self.config.textContent.text = data.content
    self.config.notiNew.gameObject:SetActive(data.vipState == VipBenefitState.NEW)
    self.config.notiUpgrade.gameObject:SetActive(data.vipState == VipBenefitState.UPGRADE)
end

--- @return void
function VipBenefitDetailView:ReturnPool()
    UIPrefabView.ReturnPool(self)
end

return VipBenefitDetailView


