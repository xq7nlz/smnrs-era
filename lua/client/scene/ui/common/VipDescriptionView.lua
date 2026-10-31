--- @class VipDescriptionView : IconView
VipDescriptionView = Class(VipDescriptionView, IconView)

--- @return void
function VipDescriptionView:Ctor()
    ---@type List
    self.listReward = List()
    IconView.Ctor(self)
end

--- @return void
function VipDescriptionView:SetPrefabName()
    self.prefabName = 'item_vip_content'
    self.uiPoolType = UIPoolType.VipDescriptionView
end

--- @return void
--- @param transform UnityEngine_Transform
function VipDescriptionView:SetConfig(transform)
    assert(transform)
    --- @type VipDescriptionConfig
    ---@type VipDescriptionConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param description string
--- @param listItem List
function VipDescriptionView:SetData(description, listItem)
    self.config.text.text = description
    if listItem ~= nil then
        ---@param v ItemIconData
        for i, v in pairs(listItem:GetItems()) do
            ---@type RootIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.reward.transform)
            iconView:SetIconData(v)
            iconView:RegisterShowInfo()
            self.listReward:Add(iconView)
        end
    else

    end
end

function VipDescriptionView:ShowInfo()

end

--- @return void
function VipDescriptionView:ReturnPool()
    IconView.ReturnPool(self)
    ---@param v ItemIconView
    for i, v in pairs(self.listReward:GetItems()) do
        v:ReturnPool()
    end
    self.listReward:Clear()
end

return VipDescriptionView