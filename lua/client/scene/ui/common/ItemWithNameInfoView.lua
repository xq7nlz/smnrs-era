--- @class ItemWithNameInfoView : IconView
ItemWithNameInfoView = Class(ItemWithNameInfoView, IconView)

function ItemWithNameInfoView:Ctor()
    --- @type RootIconView
    self.rootIconView = nil
    IconView.Ctor(self)
end

--- @return void
function ItemWithNameInfoView:SetPrefabName()
    self.prefabName = 'item_with_name_info'
    self.uiPoolType = UIPoolType.ItemWithNameInfoView
end

--- @param transform UnityEngine_Transform
function ItemWithNameInfoView:SetConfig(transform)
    --- @type ItemWithNameInfoConfig
    self.config = UIBaseConfig(transform)
end

--- @param rewardInBound RewardInBound
function ItemWithNameInfoView:SetIconData(rewardInBound)
    self:GetItemIconView()
    self.rootIconView:SetIconData(rewardInBound:GetIconData())
    self.rootIconView:RegisterShowInfo()

    self.config.itemTitle.text = LanguageUtils.LocalizeNameItem(rewardInBound.type, rewardInBound.id)
    self.config.itemDesc.text = LanguageUtils.GetStringResourceInfo(rewardInBound.type, rewardInBound.id)
end

function ItemWithNameInfoView:EnableBgHighlight(isEnable)
    self.config.bgHighlight:SetActive(isEnable)
end

function ItemWithNameInfoView:GetItemIconView()
    if self.rootIconView == nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemAnchor)
    end
end

function ItemWithNameInfoView:ReturnPool()
    IconView.ReturnPool(self)
    if self.rootIconView ~= nil then
        self.rootIconView:ReturnPool()
        self.rootIconView = nil
    end
end

--- @return void
--- @param size UnityEngine_Vector2
function ItemWithNameInfoView:ActiveMaskSelect(isActive, size)
    if self.rootIconView then
        self.rootIconView:ActiveMaskSelect(isActive, size)
    end
end

return ItemWithNameInfoView

