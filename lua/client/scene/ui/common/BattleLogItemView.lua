---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.BattleLogItemConfig"

--- @class BattleLogItemView : IconView
BattleLogItemView = Class(BattleLogItemView, IconView)

--- @return void
function BattleLogItemView:Ctor()
    ---@type ArenaOpponentInfo
    IconView.Ctor(self)
    ---@type HeroIconView
    self.heroIconView = nil
end

--- @return void
function BattleLogItemView:SetPrefabName()
    self.prefabName = 'battle_log_item_view'
    self.uiPoolType = UIPoolType.BattleLogItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function BattleLogItemView:SetConfig(transform)
    assert(transform)
    --- @type BattleLogItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
---@param heroData BaseHero
---@param percentDamage number
---@param percentHp number
function BattleLogItemView:SetData(heroData, damage, percentDamage, hp, percentHp)
    if self.heroIconView == nil then
        self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.heroIcon)
    end
    if heroData.isSummoner == true then
        self.heroIconView:SetDataMainHero(heroData.id, heroData.star, heroData.level)
    else
        self.heroIconView:SetIconData(HeroIconData.CreateInstance(ResourceType.Hero, heroData.id,
                heroData.star, heroData.level, heroData.originInfo.faction, nil, heroData.equipmentController:GetItem(HeroItemSlot.SKIN)))
    end
    self.config.textDamageBar.text = math.floor(damage)
    self.config.textHealing.text = math.floor(hp)
    self.config.damage_bar.fillAmount = percentDamage
    self.config.healing_bar.fillAmount = percentHp
end

--- @return void
function BattleLogItemView:ReturnPool()
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
    IconView.ReturnPool(self)
end

return BattleLogItemView