--- @class ChestIgnatiusItemView : MotionIconView
ChestIgnatiusItemView = Class(ChestIgnatiusItemView, MotionIconView)

--- @return void
function ChestIgnatiusItemView:Ctor()
    ---@type List
    self.listReward = List()
    ---@type List
    self.listIconData = List()
    MotionIconView.Ctor(self)
    self:InitButtons()
    self:InitLocalization()
end

--- @return void
function ChestIgnatiusItemView:SetPrefabName()
    self.prefabName = 'chest_ignatius'
    self.uiPoolType = UIPoolType.ChestIgnatiusItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function ChestIgnatiusItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type UIChestIgnatiusConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
function ChestIgnatiusItemView:InitButtons()
    self.config.buttonChest.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChest()
    end)
end

--- @return void
function ChestIgnatiusItemView:InitLocalization()
    self.config.instantRewardTxt.text = LanguageUtils.LocalizeCommon("random_reward")
end

--- @return void
--- @param listReward List
function ChestIgnatiusItemView:SetIconData(listReward, listAllReward, index)
    local chestTier = self:GetChestIdByIndex(index)
    self.config.chestText.text = LanguageUtils.LocalizeChestRewardDailyBoss("chest_" .. chestTier .. "_name")
    self.config.chest.sprite = ResourceLoadUtils.LoadChestIcon(chestTier)
    ---@param v RewardInBound
    for i, v in ipairs(listReward:GetItems()) do
        --- @type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewad)
        local iconData = v:GetIconData()
        iconView:SetIconData(iconData)
        iconView:RegisterShowInfo()
        self.listReward:Add(iconView)
    end
    self.listIconData = listAllReward
end

--- @return void
function ChestIgnatiusItemView:OnClickChest()
    --- @type {listRewardIconData : List}
    local data = {}
    --- @type List
    data.listRewardIconData = self.listIconData
    PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPool, data)
end

--- @return void
function ChestIgnatiusItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    ---@param v ItemIconView
    for i, v in ipairs(self.listReward:GetItems()) do
        v:ReturnPool()
    end
    self.listReward:Clear()
end

function ChestIgnatiusItemView:GetChestIdByIndex(index)
    if index == 1 then
        return 1
    elseif index == 2 then
        return 4
    elseif index == 3 then
        return 7
    elseif index == 4 then
        return 8
    elseif index == 5 then
        return 9
    end
    return 9
end

return ChestIgnatiusItemView