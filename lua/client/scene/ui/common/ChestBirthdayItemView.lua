--- @class ChestBirthdayItemView : ChestIgnatiusItemView
ChestBirthdayItemView = Class(ChestBirthdayItemView, ChestIgnatiusItemView)

--- @return void
function ChestBirthdayItemView:Ctor()
    ---@type List
    self.listReward = List()
    ---@type List
    self.listIconData = List()
    MotionIconView.Ctor(self)
    self:InitButtons()
    self:InitLocalization()
end

--- @return void
function ChestBirthdayItemView:SetPrefabName()
    self.prefabName = 'chest_kazetsu'
    self.uiPoolType = UIPoolType.ChestBirthdayItemView
end

function ChestBirthdayItemView:GetChestIdByIndex(index,factionType)
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
    elseif index == 6 then
        if factionType == HeroFactionType.LIGHT then
            return 12
        else
            return 13
        end
    end
    if factionType == HeroFactionType.LIGHT then
        return 12
    else
        return 13
    end
end

--- @return void
--- @param listReward List
function ChestBirthdayItemView:SetIconData(listReward, listAllReward, index)
    --- @type EventBirthdayModel
    local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    local chestTier = self:GetChestIdByIndex(index,eventBirthdayModel.selectSideId)
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


return ChestBirthdayItemView