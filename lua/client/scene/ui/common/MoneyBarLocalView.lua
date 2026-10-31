--- @class MoneyBarLocalView : MoneyBarView
MoneyBarLocalView = Class(MoneyBarLocalView, MoneyBarView)

--- @return void
---@param transform UnityEngine_Transform
function MoneyBarLocalView:Ctor(transform)
    self.transform = transform
    MoneyBarView.Ctor(self)
end

--- @return void
function MoneyBarLocalView:GetTransform()
    return self.transform
end

function MoneyBarLocalView:SetMoneyRequirementText(myResourceType, requirementResource)
    if requirementResource == nil then
        return
    end
    if self.config.textMoney ~= nil then
        local myResource = ClientConfigUtils.FormatNumber(InventoryUtils.GetMoney(myResourceType))
        local require = ClientConfigUtils.FormatNumber(requirementResource)
        local show
        if InventoryUtils.GetMoney(myResourceType) < requirementResource then
            show = UIUtils.SetColorString(UIUtils.color7,myResource)
        else
            show = UIUtils.SetColorString(UIUtils.green_light,myResource)
        end
        self.config.textMoney.text = show .. "/" .. require
    end
end
--- @return void
--- @param value number -- money need to buy item
function MoneyBarLocalView:SetBuyText(value)
    MoneyBarView.SetBuyText(self, value)
    UIUtils.SetTextTestValue(self.config, InventoryUtils.GetMoney(self.moneyType))
end

--- @return void
function MoneyBarLocalView:RemoveListener()
    MoneyBarView._RemoveListener(self)
end