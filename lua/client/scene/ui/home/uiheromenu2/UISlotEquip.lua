--- @class UISlotEquip
UISlotEquip = Class(UISlotEquip)

--- @return void
--- @param transform UnityEngine_Transform
function UISlotEquip:Ctor(transform)
    ---@type UISlotEquipConfig
    self.config = UIBaseConfig(transform)
    ---@type ItemIconView
    self.itemEquipView = nil
end

--- @return void
--- @param isActive boolean
function UISlotEquip:ActiveAddImage(isActive)
    self.config.addImage.gameObject:SetActive(isActive)
end