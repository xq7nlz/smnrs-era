--- @class ResourceMappingResourceItemView : UIPrefabView
ResourceMappingResourceItemView = Class(ResourceMappingResourceItemView, UIPrefabView)

function ResourceMappingResourceItemView:Ctor()
    UIPrefabView.Ctor(self)
    self.id = nil
end

function ResourceMappingResourceItemView:SetPrefabName()
    self.prefabName = 'resrouce_mapping_resource_item'
    self.uiPoolType = UIPoolType.ResourceMappingResourceItemView
end


--- @return void
--- @param transform UnityEngine_Transform
function ResourceMappingResourceItemView:SetConfig(transform)
    --- @type ResourceMappingResourceItemViewConfig
    self.config = UIBaseConfig(transform)
    self:InitScroll()
end
--- @param heroList Dictionary
function ResourceMappingResourceItemView:InitScroll()

end


--- @return void
--- @param iconData RewardInBound
function ResourceMappingResourceItemView:SetData(iconData)
    self.id = iconData.id
    self.itemNameText =  LanguageUtils.LocalizeNameItem(iconData.type,iconData.id)
    self.decsText =LanguageUtils.LocalizeMoneyDescription(iconData.id)
    self.config.decs.text =  self.decsText
    self.config.itemName.text = self.itemNameText
    iconData.number = 0
    --- @type MoneyIconView
    self.iconItem = SmartPoolUtils.GetIconViewByIconData(iconData:GetIconData(),
            self.config.iconAnchor)
    self.iconItem:_SetQuantity(nil)
end
---@p
function ResourceMappingResourceItemView:AddListener(callback)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(callback)
end

function ResourceMappingResourceItemView:EnableHighLight()
    self.config.itemName.text = UIUtils.SetColorString(UIUtils.brown,self.itemNameText)
    self.config.decs.text = UIUtils.SetColorString(UIUtils.brown,self.decsText)
    self.config.highLight:SetActive(true)
end

function ResourceMappingResourceItemView:DisableHighLight()
    self.config.itemName.text = UIUtils.SetColorString(UIUtils.white,self.itemNameText)
    self.config.decs.text = UIUtils.SetColorString(UIUtils.white,self.decsText)
    self.config.highLight:SetActive(false)
end

--- @return void
function ResourceMappingResourceItemView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self:DisableHighLight()
    self.iconItem:ReturnPool()
end


return ResourceMappingResourceItemView